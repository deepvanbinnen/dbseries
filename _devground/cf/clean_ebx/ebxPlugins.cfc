<cfcomponent extends="AbstractSettings" hint="ebx plugins">
	<cffunction name="init">
		<cfargument name="appPath"    type="string" required="false" default="">
		<cfargument name="rootFolder" type="string" required="false" default="">
		<cfreturn super.init(argumentCollection = arguments)>
	</cffunction>
	
	
	<!--- <cfset variables.plugins = QueryNew("id,name,path")>
	
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
		<cfset var p = variables.plugins>
		
		<cfquery name="local.result" dbtype="query">
			SELECT * FROM p
			WHERE  name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
		</cfquery>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="addAll">
		<cfargument name="plugins" type="struct" required="true">
		
		<cfset var local = StructNew()>
		<cfloop collection="#arguments.plugins#" item="local.plugin">
			<cfset add(local.plugin, arguments.plugins[local.plugin])>
		</cfloop>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAll">
		<cfreturn variables.plugins>
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
		<cfset QueryAddRow(variables.plugins)>
		<cfset QuerySetCell(variables.plugins, "id", variables.plugins.recordcount)>
		<cfset QuerySetCell(variables.plugins, "name", arguments.name)>
		<cfset QuerySetCell(variables.plugins, "path", arguments.path)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_update">
		<cfargument name="name" type="string" required="true">
		<cfargument name="path" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.result = get(arguments.name)>
		<cfif local.result.recordcount>
			<cfset QuerySetCell(variables.plugins, "path", arguments.path, local.result.id)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction> --->
</cfcomponent>