<cfcomponent displayname="ebxSettings" hint="I set the global properties for the ebx">
	<cfset variables.ebx      = "">
	
	<cfset variables.includes = StructNew()>
	<cfset variables.includes.settings = "ebx_settings.cfm">
	<cfset variables.includes.circuits = "ebx_circuits.cfm">
	<cfset variables.includes.layouts  = "ebx_layouts.cfm">
	<cfset variables.includes.plugins  = "ebx_plugins.cfm">
	
	<cffunction name="init">
		<cfargument name="ebx" required="true" type="ebx">
		
		<cfset variables.ebx = arguments.ebx>
		<cfset variables.ebx.setDebug("Initialising settings", 0)>
		<cfset parseSettings()>
		<cfset parseCircuits()>
		<cfset parsePlugins()>
		<cfset parseLayouts()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="parseSettings">
		<cfset variables.ebx.include(variables.includes.settings)>
		<cfset variables.ebx.setDebug("Settings file parsed", 0)>
	</cffunction>
	
	<cffunction name="parseCircuits">
		<cfset variables.ebx.include(variables.includes.circuits)>
		<cfset variables.ebx.setDebug("Circuits file parsed", 0)>
	</cffunction>
	
	<cffunction name="parsePlugins">
		<cfset variables.ebx.include(variables.includes.plugins)>
		<cfset variables.ebx.setDebug("Plugins file parsed", 0)>
	</cffunction>
	
	<cffunction name="parseLayouts">
		<cfset variables.ebx.include(variables.includes.layouts)>
		<cfset variables.ebx.setDebug("Layouts file parsed", 0)>
	</cffunction>
	
	<cffunction name="getCircuit" hint="get the path to the circuit">
		<cfargument name="circuit" required="true" type="string" hint="the circuit to lookup">
		<cfif hasCircuit(arguments.circuit)>
			<cfreturn variables.ebx.circuits[arguments.circuit]>
		<cfelse>
			<cfset variables.ebx.setError("Circuit not found: #arguments.circuit#")>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="hasCircuit" hint="check if circuit exists">
		<cfargument name="circuit" required="true" type="string" hint="the circuit to lookup">
		<cfreturn StructKeyExists(variables.ebx.circuits, arguments.circuit)>
	</cffunction>
	
	
</cfcomponent>