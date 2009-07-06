<cffunction name="_get%1%" output="No">
	<cfreturn %3%.%2%>
</cffunction>

<cffunction name="_set%1%" output="No">
	<cfargument name="%2%" type="%4%" required="%5%">
	<cfset %3%.%2% = arguments.%2%>
</cffunction>
