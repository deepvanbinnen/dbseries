<cfcomponent name="DBForm" extends="AbstractObject">
	<cfset variables.id   = createUUID()>
	<cfset variables.name = "Unknown">
	
	<cfset _constructor()>
	<cffunction name="_constructor">
		<cfset setId(createUUID())>
		<cfset setName("Unknown")>
	</cffunction>

	<cffunction name="init">
		<cfargument name="id"   type="string" default="#variables.id#" required="false">
		<cfargument name="name" type="string" default="#variables.name#" required="false">
			<cfset setId(arguments.id)>
			<cfset setName(arguments.name)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getId">
		<cfreturn variables.id>
	</cffunction>
	
	<cffunction name="setId">
		<cfargument name="id"   type="string" required="true">
			<cfset variables.id = arguments.id>
		<cfreturn this>
	</cffunction>
		
	<cffunction name="getName">
		<cfreturn variables.name>
	</cffunction>
	
	<cffunction name="setName">
		<cfargument name="name"   type="string" required="true">
			<cfset variables.name = arguments.name>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>