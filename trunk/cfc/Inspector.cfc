<cfcomponent name="Inspector" extends="AbstractObject">
	<cfset variables.object     = "">
	
	<cffunction name="init">
		<cfargument name="object" required="true" type="any">
			<cfset variables.object = arguments.object>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getName">
		<cfargument name="targetObj"   type="any" required="true">
		<cftry>
			<cfreturn arguments.targetObj.getName()>
			<cfcatch type="any">
				<cfreturn "">
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getNames">
		<cfargument name="targetArr" type="any"     required="true">
		<cfargument name="asList"    type="boolean" required="false" default="false">
		
		<cfset var local = StructNew()>
		<cfset local.result = ArrayNew(1)>
		<cftry>
			<cfloop from="1" to="#ArrayLen(arguments.targetArr)#" index="local.i">
				<cfset ArrayAppend(local.result, getName(arguments.targetArr[local.i]))>
			</cfloop>
			<cfcatch type="any">
				<cfreturn "">
			</cfcatch>
		</cftry>
		
		<cfif arguments.asList>
			<cfreturn ArrayToList(local.result)>
		<cfelse>
			<cfreturn local.result>
		</cfif>
	</cffunction>
	
	<cffunction name="getMethodList">
		<cfargument name="object" type="any" required="false" default="#variables.object#">
		<cfreturn getNames(arguments.object, true)>
	</cffunction>
	
	<cffunction name="getMethods">
		<cfargument name="object" type="any" required="false" default="#variables.object#">
		<cfreturn getNames(arguments.object)>
	</cffunction>

	<cffunction name="_call" access="public" output="true" returntype="any" hint="array of component methods as array">
		<cfargument name="targetCFC"   type="any" required="true">
		<cfargument name="proxyMethod" type="any" required="true">
		<cfargument name="proxyArguments" type="struct" required="false" default="#StructNew()#">
		
		<cfset var local = StructNew()>
		<cftry>
			<cfinvoke component="#arguments.targetCFC#" method="#arguments.proxyMethod#" argumentcollection="#arguments.proxyArguments#" returnvariable="local.result"></cfinvoke>
			<cfcatch type="any">
				<cfset local.result = cfcatch>
			</cfcatch>
		</cftry>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="_arrCall" access="public" output="false" returntype="string" hint="array of component methods as array">
		<cfargument name="targetArray"   type="array" required="true">
		<cfargument name="proxyMethod" type="any" required="true">
		<cfargument name="proxyArguments" type="struct" required="false" default="#StructNew()#">
		
		<cfset var local = StructNew()>
		<cfset local.result = ArrayNew(1)>
		<cfloop from="1" to="#Arrayen(arguments.targetArray)#" index="local.i">
			<cfset local.targetObj = arguments.targetArray[local.i]>
			<cfif _isCFC(local.targetObj)>
				<cfset ArrayAppend(local.result, _call(local.targetObj, arguments.proxyMethod, arguments.proxyArguments))>
			<cfelse>
				<cfset ArrayAppend(local.result, _callJ(local.targetObj, arguments.proxyMethod, arguments.proxyArguments))>
			</cfif>
		</cfloop>
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="_isCFC" access="public" output="false" returntype="boolean">
		<cfreturn NOT ArrayLen(arguments) eq 0 AND isObject(arguments[1]) AND StructKeyExists(getMetaData(arguments[1]), "extends")>
	</cffunction>
	 
	<cffunction name="_isMethod" access="public" output="false" returntype="boolean">
		<cfargument name="func" type="any">
		
		<cfset var local = StructNew()>
		<cfset local.fn  = arguments.func>
		
		<cfif NOT IsStruct(local.fn) AND NOT IsArray(local.fn) AND NOT IsObject(local.fn) AND NOT IsSimpleValue(local.fn)>
			<cfset local.metadata = getMetaData(local.fn)>
			<cfreturn StructKeyExists(local.metadata, "name") AND StructKeyExists(local.metadata, "parameters")>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="_methodExists" access="public" output="false" returntype="boolean">
		<cfargument name="cfc" type="any">
		<cfargument name="func" type="any">
		
		<cfset var local = StructNew()>
		<cfset local.cfc  = arguments.cfc>
		<cfset local.result = false>
		
		<cfif isObject(local.cfc) AND _isCFC(local.cfc)>
			<cfset local.fns = getMetaData(local.cfc).functions>
			<cfloop from="1" to="#ArrayLen(local.fns)#" index="local.i">
				<cfif local.fns[local.i] eq arguments.func>
					<cfset local.result = true>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="_getMethods" access="public">
		<cfargument name="cfc" type="any">
		
		<cfset var local = StructNew()>
		<cfset local.cfc  = arguments.cfc>
		<cfset local.result = ArrayNew(1)>
		
		<cfif isObject(local.cfc) AND _isCFC(local.cfc)>
			<cfset local.fns = getMetaData(local.cfc).functions>
			<cfloop from="1" to="#ArrayLen(local.fns)#" index="local.i">
				<cfset local.fn = local.fns[local.i]>
				<cfset local.stf = StructNew()>
				<cfset local.stf.name = local.fn.name>
				<cfset local.stf.parameters = _as2q(local.fn.parameters)>
				<cfset ArrayAppend(local.result, local.stf)>
			</cfloop>
		</cfif>
		
		<cfreturn _as2q(local.result)>
	</cffunction>
	
</cfcomponent>