<cfcomponent extends="ebxContext" displayname="ebxRequest" hint="I am the main ebx request and handle the execution of the default/given fuseaction">
	<cfset variables.act        = "">
	<cfset variables.action    = "">
	<cfset variables.circuit    = "">
	<cfset variables.circuitdir = "">
	<cfset variables.rootPath   = "">
	<cfset variables.execDir    = "">
	
	<cffunction name="init">
		<cfargument name="type"       type="string" required="true">
		<cfargument name="action"     type="string" required="true">
		<cfargument name="appPath"    type="string" required="false" default="">
		<cfargument name="circuitdir" type="string" required="false" default="">
		<cfargument name="execDir"    type="string" required="false" default="#arguments.appPath##arguments.circuitdir#">
		<cfargument name="circuit"    type="string" required="false" default="#ListFirst(arguments.action, '.')#">
		<cfargument name="act"        type="string" required="false" default="#ListLast(arguments.action, '.')#">
		<cfargument name="rootPath"   type="string" required="false" default="#RepeatString('../', ListLen(arguments.circuitdir,'/')#">
			<cfset StructAppend(variables, arguments, true)>
		<cfreturn super.init(arguments.type)>	
	</cffunction>
	
	<cffunction name="get">
		<cfargument name="property" type="string" required="true">
		<cfif StructKeyExists(variables, property)>
			<cfreturn variables[property]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getAct">
		<cfreturn variables.act>
	</cffunction>
	
	<cffunction name="getAction">
		<cfreturn variables.action>
	</cffunction>
	
	<cffunction name="getCircuit">
		<cfreturn variables.circuit>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfreturn variables.circuitdir>
	</cffunction>
	
	<cffunction name="getRootPath">
		<cfreturn variables.rootPath>
	</cffunction>
	
	<cffunction name="getExecDir">
		<cfreturn variables.execdir>
	</cffunction>
	
	
</cfcomponent>