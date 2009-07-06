<cfcomponent hint="Abstract settings object">
	<cfset variables.collection = QueryNew("id,name,data")>
	
	<cffunction name="init">
		<cfargument name="appdata"    type="string" required="false" default="">
		<cfargument name="rootFolder" type="string" required="false" default="">
			<cfset variables.appdata = arguments.appdata>
			<cfset variables.rootFolder = arguments.rootFolder>
		<cfreturn this>				
	</cffunction>
	
	<cffunction name="add">
		<cfargument name="name" type="string" required="true">
		<cfargument name="data" type="any" required="true">
		
		<cfif NOT _update(arguments.name, arguments.data)>
			<cfset _add(arguments.name, arguments.data)>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get">
		<cfargument name="name" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset var c = variables.collection>
		
		<cfquery name="local.result" dbtype="query">
			SELECT * FROM c
			WHERE  name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
		</cfquery>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="addAll">
		<cfargument name="elements" type="struct" required="true">
		
		<cfset var local = StructNew()>
		<cfloop collection="#arguments.elements#" item="local.element">
			<cfset add(local.element, arguments.elements[local.element])>
		</cfloop>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getLength">
		<cfreturn variables.collection.recordcount>
	</cffunction>
	
	<cffunction name="getAll">
		<cfreturn variables.collection>
	</cffunction>
	
	<cffunction name="exists">
		<cfargument name="name" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.result = get(arguments.name)>
		<cfreturn local.result.recordcount>
	</cffunction>
	
	<cffunction name="_add">
		<cfargument name="name" type="string" required="true">
		<cfargument name="data" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset QueryAddRow(variables.collection)>
		<cfset QuerySetCell(variables.collection, "id", variables.collection.recordcount)>
		<cfset QuerySetCell(variables.collection, "name", arguments.name)>
		<cfset QuerySetCell(variables.collection, "data", arguments.data)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_update">
		<cfargument name="name" type="string" required="true">
		<cfargument name="data" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.result = get(arguments.name)>
		<cfif local.result.recordcount>
			<cfset QuerySetCell(variables.collection, "data", arguments.data, local.result.id)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="addColumn">
		<cfargument name="name" type="string" required="true">
		<cfargument name="data" type="array" required="false" default="#ArrayNew(1)#">

		<cfset QueryAddColumn(variables.collection, arguments.name, arguments.data)>

		<cfreturn this>
	</cffunction>
</cfcomponent>