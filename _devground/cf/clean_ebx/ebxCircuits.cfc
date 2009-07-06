<cfcomponent extends="AbstractSettings" hint="ebx circuits">
	<cffunction name="init">
		<cfargument name="appPath"    type="string" required="false" default="">
		<cfargument name="rootFolder" type="string" required="false" default="">
		<cfreturn super.init(argumentCollection = arguments)>
	</cffunction>
	
<!--- 	<cfset variables.circuits = QueryNew("id,name,path")>
	
	<cffunction name="init">
		<cfargument name="appPath"    type="string" required="false" default="">
		<cfargument name="rootFolder" type="string" required="false" default="">
		
	</cffunction>
	
	<cffunction name="add">
		<cfargument name="name" type="string" required="true">
		<cfargument name="path" type="string" required="true">
		
		<cfif NOT _update(arguments.name, arguments.path)>
			<cfset _add(arguments.name, arguments.path)>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get">
		<cfargument name="name" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset var c = variables.circuits>
		
		<cfquery name="local.result" dbtype="query">
			SELECT * FROM c
			WHERE  name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
		</cfquery>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="addAll">
		<cfargument name="circuits" type="struct" required="true">
		
		<cfset var local = StructNew()>
		<cfloop collection="#arguments.circuits#" item="local.circuit">
			<cfset add(local.circuit, arguments.circuits[local.circuit])>
		</cfloop>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAll">
		<cfreturn variables.circuits>
	</cffunction>
	
	<cffunction name="exists">
		<cfargument name="name" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.result = get(arguments.name)>
		<cfreturn local.result.recordcount>
	</cffunction>
	
	<cffunction name="_add">
		<cfargument name="name" type="string" required="true">
		<cfargument name="path" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset QueryAddRow(variables.circuits)>
		<cfset QuerySetCell(variables.circuits, "id", variables.circuits.recordcount)>
		<cfset QuerySetCell(variables.circuits, "name", arguments.name)>
		<cfset QuerySetCell(variables.circuits, "path", arguments.path)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_update">
		<cfargument name="name" type="string" required="true">
		<cfargument name="path" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.result = get(arguments.name)>
		<cfif local.result.recordcount>
			<cfset QuerySetCell(variables.circuits, "path", arguments.path, local.result.id)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction> --->
</cfcomponent>