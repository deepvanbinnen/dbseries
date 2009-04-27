<cfcomponent displayname="ebxParameters" hint="I provide an interface for the parameters used in an ebxRequest">
	<cfset variables.ebx  = "">
	
	<cfset variables.form   = form>
	<cfset variables.url    = url>
	<cfset variables.params = StructNew()>
	
	<cffunction name="init">
		<cfargument name="ebx" required="true" type="ebx">
		
		<cfset variables.ebx = arguments.ebx>
		<cfset variables.ebx.setDebug("Initialising parameters", 0)>
		<cfset copyParameters(variables.url)>
		<cfset variables.ebx.setDebug("URL parameters copied", 0)>
		<cfset copyParameters(variables.form)>
		<cfset variables.ebx.setDebug("Form parameters copied", 0)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="copyParameters">
		<cfargument name="scope">
		<cfset var local = StructNew()>
		<cfloop collection="#arguments.scope#" item="local.varname">
			<cfif NOT StructKeyExists(variables.params,local.varname)>
				<cfset StructInsert(variables.params,local.varname,arguments.scope[local.varname])>
			</cfif>
		</cfloop>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn variables.params>
	</cffunction>
	
	<cffunction name="getParameter">
		<cfargument name="name" required="true" hint="the parameter to lookup">
		<cfargument name="value" required="false" hint="the default value for the parameter" default="">
		<cfif NOT StructKeyExists(variables.params,arguments.name)>
			<cfset StructInsert(variables.params,arguments.name,arguments.value)>
		</cfif>
		<cfreturn variables.params[arguments.name]>
	</cffunction>
	
</cfcomponent>