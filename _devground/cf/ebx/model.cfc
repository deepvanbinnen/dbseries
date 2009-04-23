<cfcomponent displayname="model" hint="I am a model and reflect a data-layer">
	<cfset variables.data = QueryNew("")>
	<cfset QueryAddColumn(variables.data,"id", ListToArray("1,2,4,5,6"))>
	<cfset QueryAddColumn(variables.data,"name", ListToArray("Deepak,Dewi,Risi,Lotte,Carmen"))>
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getData">
		<cfreturn variables.data>
	</cffunction>
	
	<cffunction name="getDetail">
		<cfargument name="id">
		<cfset var q = variables.data>
		
		<cfquery name="local.result" dbtype="query">
		SELECT *
		FROM q
		WHERE id = #arguments.id#
		</cfquery>
		<cfreturn local.result>
	</cffunction>
	
	
</cfcomponent>