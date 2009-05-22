<cfcomponent hint="I am an interface for the this scope" output="false">
	<cffunction name="getProperty" returntype="any" access="public" hint="return property value or if the property does not exist default value which defaults to empty string">
		<cfargument name="key"     required="true"  type="string" hint="key to get">
		<cfargument name="default" required="false" type="any"    default="" hint="default value to return if key doesn't exist">
	
		<cfif hasProperty(arguments.key)>
			<cfreturn this[arguments.key]>
		</cfif>
		<cfreturn arguments.default>
	</cffunction>
	
	<cffunction name="getProperties" returntype="struct" access="public" hint="set properties from a data object">
		<cfargument name="maplist" required="false" type="any" default="" hint="propertylist or struct used to remap keys">
		
		<cfset var local = StructNew()>
		<cfset local.out = StructNew()>
		
		<cfif IsStruct(arguments.maplist)>
			<cfloop collection="#arguments.maplist#" item="local.i">
				<cfif hasProperty(local.i)>
					<cfset StructInsert(local.out, arguments.maplist[local.i], getProperty(local.i), true)>
				</cfif>
			</cfloop>
		<cfelseif IsSimpleValue(arguments.maplist)>
			<cfloop list="#arguments.maplist#" index="local.i">
				<cfif hasProperty(local.i)>
					<cfset StructInsert(local.out, local.i, getProperty(local.i), true)>
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop collection="#this#" item="local.i">
				<cfif IsSimpleValue(getProperty(local.i))>
					<cfset StructInsert(local.out, local.i, getProperty(local.i), true)>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn local.out>
	</cffunction>
	
	<cffunction name="hasProperty" returntype="boolean" access="public" hint="returns true on success otherwise false">
		<cfargument name="key"   required="true"  type="string" hint="key to update">
		<cfreturn StructKeyExists(this, arguments.key) AND IsSimpleValue(this[arguments.key])>
	</cffunction>
	
	<cffunction name="retainList" access="public">
		<cfargument name="sourcelist" type="string" required="true">
		<cfargument name="targetlist" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.target = listToArray(arguments.targetlist)>
		<cfset local.source = listToArray(arguments.sourcelist)>
		<cfset local.target.retainAll(local.source)>
		
		<cfreturn ArrayToList(local.target)>
	</cffunction>
	
	<cffunction name="setFromList" access="private">
		<cfargument name="list" required="true" type="string" hint="list data">
		<cfargument name="force"  required="false" type="boolean" default="false" hint="force setting property">
		<cfargument name="overwrite" required="false" type="boolean" default="true" hint="overwrite property">
		
		<cfset var local = StructNew()>
		<cfloop list="#arguments.list#" index="local.key">
			<cfset setProperty(local.key, "", arguments.force, arguments.overwrite)>
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setFromRecord" access="private">
		<cfargument name="record" required="true" type="query" hint="query data">
		<cfargument name="recidx" required="false" type="numeric" default="1" hint="the record index used if objectdata is queryable">
		<cfargument name="force"  required="false" type="boolean" default="false" hint="force setting property">
		<cfargument name="overwrite" required="false" type="boolean" default="true" hint="overwrite property">
			
		<cfset var local = StructNew()>
		<cfloop list="#arguments.record.columnlist#" index="local.column">
			<cfset local.value = "">
			<cfif arguments.record.recordcount GTE arguments.recidx>
				<cfset local.value = arguments.record[local.column][arguments.recidx]>
			</cfif>
			<cfset setProperty(local.column, local.value, arguments.force, arguments.overwrite)>
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setFromStruct" access="private">
		<cfargument name="object" required="true" type="struct" hint="struct data">
		<cfargument name="force" required="false" type="boolean" default="false" hint="force setting property">
		<cfargument name="overwrite" required="false" type="boolean" default="true" hint="overwrite property">
	
		<cfset var local = StructNew()>
		<cfloop collection="#arguments.object#" item="local.key">
			<cfset setProperty(local.key, arguments.object[local.key], arguments.force, arguments.overwrite)>
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setProperty" returntype="boolean" access="private" hint="returns true on success otherwise false">
		<cfargument name="key"   required="true"  type="string"  hint="key to update">
		<cfargument name="value" required="false" type="any"     default="" hint="value for the key">
		<cfargument name="force"     required="false" type="boolean" default="false" hint="force setting property">
		<cfargument name="overwrite" required="false" type="boolean" default="true" hint="overwrite property">
	
		<cfif arguments.force OR hasProperty(arguments.key) AND arguments.overwrite>
			<cfif NOT hasProperty(arguments.key) OR arguments.overwrite>
				<cfset this[arguments.key] = arguments.value>
			</cfif>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="setProperties" access="private" hint="set properties from a data object">
		<cfargument name="data"   required="true"  type="any"     hint="the object that holds the data">
		<cfargument name="force"  required="false" type="boolean" default="false" hint="force setting property">
		<cfargument name="overwrite"  required="false" type="boolean" default="true" hint="overwrite property">
		<cfargument name="recidx" required="false" type="numeric" default="1" hint="the record index used if objectdata is queryable">
		
		<cfset var local = StructNew()>
		<cfif IsQuery(arguments.data)>
			<cfset setFromRecord(arguments.data, arguments.recidx, arguments.force, arguments.overwrite)>
		<cfelseif IsStruct(arguments.data)>
			<cfset setFromStruct(arguments.data, arguments.force, arguments.overwrite)>
		<cfelseif ListLen(arguments.data)>
			<cfset setFromList(arguments.data, arguments.force, arguments.overwrite)>
		</cfif>
		
		<cfreturn true>
	</cffunction>
</cfcomponent>	