<cfcomponent extends="ebxCore" displayname="ebxDebug" hint="I provide a container for debugging">
	<cfset variables.errors     = ArrayNew(1)><!--- provide simple "sink" for error messages --->
	<cfset variables.debug      = ArrayNew(1)><!--- provide simple "sink" for debug messages --->
	
	<cffunction name="init">
		<cfargument name="ebx" required="true">
		
		<cfset variables.ebx = arguments.ebx>
		<cfset super.init(variables.ebx)>
		<cfset setDebug("Initialising Debug", 0)>
		
		<cfreturn this>
	</cffunction>	
	
	<cffunction name="setDebug" hint="adds message to debugsink">
		<cfargument name="message" required="true">
		<cfargument name="level"   required="true" type="numeric">
		
		<cfset var local = StructNew()>
		<cfset local.message = arguments.message>
		<cfset local.level   = arguments.level>

		<cfset ArrayPrepend(variables.debug, local)>
	</cffunction>
	
	<cffunction name="setError" hint="adds message to errorsink">
		<cfargument name="message" required="true">
		<cfset setDebug(arguments.message, 1)>
		<cfset ArrayPrepend(variables.errors, arguments.message)>
	</cffunction>
	
	<cffunction name="getErrors" hint="get the error sink">
		<cfreturn variables.errors>
	</cffunction>
	
	<cffunction name="hasError" hint="returns number of errors in sink">
		<cfreturn ArrayLen(variables.errors)>
	</cffunction>
	
	<cffunction name="getDebug" hint="get all messages from debugsink">
		<cfreturn variables.debug>
	</cffunction>

</cfcomponent>