<cfcomponent displayname="ebxExecutionContext" hint="I execute a ebx action">
	<cfset variables.ebx      = "">
	
	<cffunction name="init">
		<cfargument name="ebx">
			<cfset variables.ebx = arguments.ebx>
			<cfset variables.ebx.setDebug("Initializing ebxExecutionContext", 0)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="include">
		<cfargument name="template" type="string" hint="full mapping path to include template">
		
		<cfset var local = StructNew()>
		<cfset local.request =  variables.ebx.getInterface("request")>
		
		<cfset local.output = "">
		<cfsavecontent variable="local.output">
			<cftry>
				<cfoutput>
					<cfinclude template="#arguments.template#">
					<cfset variables.ebx.setDebug("Including: #arguments.template#", 0)>
				</cfoutput>
				
				<cfcatch type="missinginclude">
					<cfset variables.ebx.setError("missing include: #arguments.template#")>
				</cfcatch>
			
				<cfcatch type="any">
					<cfrethrow>
				</cfcatch>
			</cftry>
		</cfsavecontent>
		<cfset local.request.appendOutput(local.output)>	
	</cffunction>
	
	<cffunction name="do">
		<cfargument name="action" type="string" hint="the action to execute">
		<cfargument name="params" type="struct" hint="parameters to use">
		<cfset variables.ebx.setDebug("Excuting do: #arguments.action#", 0)>
		<cfset var local = StructNew()>
	</cffunction>
	
</cfcomponent>