<cfcomponent>
	<cffunction name="_constructor" access="private" output="false" returntype="void" hint="default constructor">
	</cffunction>
	
	<cffunction name="_isNull" access="public" output="false" returntype="boolean" hint="detect null">
		<cfreturn ArrayLen(arguments) eq 0>
	</cffunction>
	
	<cffunction name="_dump" access="public" output="false" returntype="struct">
		<cfset var i = "">
		<cfset var j = "">
		<cfset var tmp ="">
		<cfset var ret = structnew()>
		<cfloop collection="#this#" item="i">
			<cfif lcase(left(i, 3)) EQ "get">
				<cfinvoke component="#this#" method="#i#" returnvariable="tmp"/>
				<!--- if its an object, call its _dump() method --->
				<cfif isObject(tmp)>
					<cfset tmp = tmp._dump()>
				<!--- if its an array, call each elements dump method in turn --->
				<cfelseif isArray(tmp) AND structkeyexists(tmp[1], "_dump")>
					<cfloop from="1" to="#arraylen(tmp)#" index="j">
						<cfset tmp[j] = tmp[j]._dump()>
					</cfloop>
				</cfif>
				<cfset ret[replacenocase(i, "get", "")] = tmp>
			</cfif>
		</cfloop>
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="_dumpClass" access="public" output="false" returntype="struct" hint="dump java class">
		<cfargument name="cls" type="any">
		
		<cfset var local = StructNew()>
		<cfset local.cls = arguments.cls>
		<cfset local.result = StructNew()>
		
		<cfset local.result.name   = local.cls.getName()>
		<cfset local.result.fields = getNames(local.cls.getFields())>
		
		<!--- <cfset local.fld = StructNew()>
		<cfset local.f = local.cls.getFields()>
		<cfloop from="1" to="#ArrayLen(local.f)#" index="local.i">
			<cfdump var="#local.f[local.i]#">
			<!--- <cfset StructInsert(local.fld, local.f[local.i].getName(), local.cls.getField(local.f[local.i]), TRUE)> --->
		</cfloop> 
		<cfdump var="#local.fld#">
		--->
		
		<!--- this must be in its own method --->
		<cfset local.mt = ArrayNew(1)>
		<cfset local.m = local.cls.getMethods()>
		<cfloop from="1" to="#ArrayLen(local.m)#" index="local.i">
			<cfset local.mtemp = local.m[local.i]>
			<cfset local.st = StructNew()>
			<cfset local.st.name = local.mtemp.getName()>
			<cfset local.st.args = ArrayToList(getNames(local.mtemp.getParameterTypes()))>
			<cfset local.st.retv = local.mtemp.getReturnType().getName()> 
			<cfset ArrayAppend(local.mt, local.st)>
		</cfloop>
		<cfset local.result.methods = _as2q(local.mt)>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="_as2q" access="public" output="false" returntype="query" hint="array of structs to query">
		<cfargument name="data" type="array" required="true">
		<cfargument name="keys" type="string" required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.result = QueryNew("")><!--- result query --->
		
		<!--- struct that holds columns with an array of their (row)-values --->
		<cfset local.temp   = StructNew()>
		
		<!--- setup columns --->
		<cfif arguments.keys neq "">
			<!--- columns are given only process these keys (make the list immutable) and initialise result struct --->
			<cfset local.immutable_keys = true>
			<cfset local.keys = arguments.keys>
			<!--- initialise result struct --->
			<cfloop list="#local.keys#" index="local.key">
				<cfif NOT StructKeyExists(local.temp, local.key)>
					<cfset StructInsert(local.temp, local.key, ArrayNew(1))>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset local.immutable_keys = false>
			<cfset local.keys = "">
		</cfif>
		
		<!--- loop the data --->
		<cfloop from="1" to="#ArrayLen(arguments.data)#" index="local.i">
			<cfset local.item = arguments.data[local.i]>
			<!--- reset columnlist if applicable--->
			<cfif NOT local.immutable_keys>
				<cfset local.keys = StructKeyList(local.item)>
			</cfif>
			<cfloop list="#local.keys#" index="local.key">
				<!--- Only process keys that exist --->
				<cfif StructKeyExists(local.item,local.key)>
					<!--- If applicable check and add struct key --->
					<cfif NOT local.immutable_keys AND NOT StructKeyExists(local.temp, local.key)>
						<cfset StructInsert(local.temp, local.key, ArrayNew(1))>
					</cfif>
					<!--- Set value --->
					<cfset ArraySet(local.temp[local.key], local.i, local.i, local.item[local.key])>
				</cfif>
			</cfloop>
		</cfloop>
		
		<cfset local.keys = StructKeyList(local.temp)>
		<cfloop list="#local.keys#" index="local.key">
			<cfset QueryAddColumn(local.result, local.key, local.temp[local.key])>
		</cfloop>
		
		
		<cfreturn local.result>
	</cffunction>
	
	
	
	
	
</cfcomponent>