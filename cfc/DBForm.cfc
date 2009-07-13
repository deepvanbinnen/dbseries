<cfcomponent name="DBForm">
	<cffunction name="init">
		<cfargument name="id"   type="string" default="#CreateUUID()#" required="false">
		<cfargument name="name" type="string" default="Unknown" required="false">
			<cfset variables.id   = arguments.id>
			<cfset variables.name = arguments.name>
		<cfreturn this>
	</cffunction>
</cfcomponent>