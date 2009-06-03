<cfcomponent extends="ebxExecutionContext">
	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
		<cfset super.init(arguments.ParserInterface, "mycontext")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMyVar">
		<cfreturn "1">
	</cffunction>
</cfcomponent>