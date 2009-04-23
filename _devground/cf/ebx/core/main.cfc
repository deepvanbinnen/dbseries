<cfcomponent displayname="ebx.core.main" hint="main ebx controller">
	<cfset variables.requests = ArrayNew(1)>
	<cfset variables.rootpath = "">
	<cfset variables.circuits = StructNew()>
	<cfset variables.includes = ArrayNew(1)>
	
	<cffunction name="init">
		<cfargument name="rootpath" required="true" type="string" hint="the rootpath to the ebx application">
		<cfset variables.rootpath = arguments.rootpath>
		<cfset variables.parameters["form"]    = StructKeyList(form)>
		<cfset variables.parameters["url"]     = StructKeyList(url)>
		<cfset variables.parameters["formurl"] = ListAppend(variables.parameters["form"],variables.parameters["url"])>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addRequest">
		<cfargument name="ebxRequest" hint="a ebx.core.request object">
		<cfset ArrayAppend(variables.requests, arguments.ebxRequest)>
	</cffunction>
	
	<cffunction name="parseGlobalSettings">
		<cfargument name="ebx_settings_file" hint="global settings file to include">
		<cfset include("#variables.rootpath##arguments.ebx_settings_file#")>
	</cffunction>
	
	<cffunction name="parseCircuits">
		<cfargument name="ebx_circuits_file" hint="circuits file to include">
		<cfinclude template="#variables.rootpath##arguments.ebx_circuits_file#">
		<cfset variables.circuits = request.ebx.circuits>
	</cffunction>
	
	<cffunction name="include">
		<cfargument name="include_file" hint="circuits file to include">
		<cfinclude template="#arguments.include_file#">
	</cffunction>
	
	<cffunction name="getRequest">
		<cfargument name="fuseAction" hint="circuit and action">
		<cfset local = StructNew()>
		<cfset local.fuseAction = parseFuseAction(arguments.fuseAction)>
		<cfset local.output = "">
		
		<cfif local.fuseAction.circuit neq "">
			<cfset request.ebx.act = local.fuseaction.action>
			<cfset local.include = variables.rootpath & variables.circuits[local.fuseaction.circuit] & "ebx_switch.cfm">
			<cfsavecontent variable="local.output">
				<cfset include(local.include)>
			</cfsavecontent>
		</cfif>
		
		<cfreturn local.output>
	</cffunction>
	
	<cffunction name="parseFuseAction">
		<cfargument name="fuseAction" hint="circuit and action">
		
		<cfset local = StructNew()>
		
		<cfset local.fuseAction = StructNew()>
		<cfset local.fuseAction.circuit = "">
		<cfset local.fuseAction.action  = "">
		
		<cfif ListLen(arguments.fuseAction,".") eq 2>
			<cfset local.fuseAction.circuit = ListFirst(arguments.fuseAction,".")>
			<cfif StructKeyExists(variables.circuits, local.fuseAction.circuit)>
				<cfset local.fuseAction.action  = ListLast(arguments.fuseAction,".")>
			</cfif>
		</cfif>
		
		<cfreturn local.fuseAction>
	</cffunction> 
	
	<cffunction name="getIncludes">
		<cfreturn variables.includes> 
	</cffunction>
	 
	<cffunction name="test">
		<cfdump var="#variables#">
	</cffunction>
</cfcomponent>