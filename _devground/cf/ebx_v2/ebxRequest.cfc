<cfcomponent displayname="ebxRequest" hint="I am the main ebx request and handle the execution of the default/given fuseaction">
	<cfset variables.ebx         = "">
	
	<cfset variables.attributes  = StructNew()>
	<cfset variables.thisCircuit = "">
	<cfset variables.thisAction  = "">
	<cfset variables.act         = "">
	<cfset variables.circuitdir  = "">
	<cfset variables.rootPath    = "">

	<!--- <cfset variables.layoutdir     = "">
	<cfset variables.layoutfile    = "">
	<cfset variables.includelayout = variables.layoutdir & variables.layoutfile>
	
	<cfset variables.handlerIndex = -1> --->
	
	<cfset variables.output      = "">
	
	<cffunction name="init">
		<cfargument name="ebx" required="true" type="ebx">
			<cfset variables.ebx = arguments.ebx>
			<cfset variables.ebx.setDebug("Initializing ebxRequest", 0)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="parseAction">
		<cfargument name="action" type="string" required="true">
		
		<cfset variables.act = arguments.action>
		<cfif ListLen(variables.act, ".") eq 2>
			<cfset setCircuit(ListFirst(variables.act, "."))>
			<cfset setAction(ListFirst(variables.act, "."))>
			<cfreturn true>
		<cfelse>
			<cfset variables.ebx.setError("Invalid action: #arguments.action#")>
			<cfreturn false>
		</cfif>
		
	</cffunction>
	
	<cffunction name="setCircuit">
		<cfargument name="circuit" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.settings = variables.ebx.getInterface("settings")>
		
		<cfset variables.thisCircuit = arguments.circuit>
		<cfif local.settings.hasCircuit(variables.thisCircuit)>
			<cfset variables.circuitdir  = local.settings.getCircuit(variables.thisCircuit)>
			<cfset variables.rootPath    = RepeatString("../", ListLen(variables.circuitdir, "/"))>
		<cfelse>
			<cfset variables.ebx.setError("Invalid request: circuit not found #arguments.circuit#")>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getCircuit">
		<cfreturn variables.thisCircuit>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfreturn variables.circuitdir>
	</cffunction>
	
	<cffunction name="getSwitch">
		<cfreturn getCircuitDir() & "ebx_switch.cfm">
	</cffunction>
	
	<cffunction name="setAction">
		<cfargument name="action" type="string" required="true">
		<cfset variables.thisAction = arguments.action>
	</cffunction>
	
	<cffunction name="getAction">
		<cfreturn variables.thisAction>
	</cffunction>

	<cffunction name="appendOutput">
		<cfargument name="output" type="string" required="true">
		<cfset variables.output = variables.output & arguments.output>
	</cffunction>
	
	<cffunction name="prependOutput">
		<cfargument name="output" type="string" required="true">
		<cfset variables.output = arguments.output & variables.output>
	</cffunction>
	
	<cffunction name="getOutput">
		<cfreturn variables.output>
	</cffunction>
	
	<cffunction name="updateBoxProperties">
		<cfset variables.ebx.scopeCopy("attributes,thisCircuit,thisAction,act,circuitdir,rootPath", variables, variables.ebx)>
	</cffunction>
</cfcomponent>