<cfcomponent displayname="model" hint="I am a model and reflect a data-layer">
	<cfset variables.data = QueryNew("id,name")>
	<cfset QueryAddColumn(variables.data,"id","",ListToArray("1,2,4,5,6"))>
	<cfset QuerySetCell(variables.data,"name","",ListToArray("Deepak,Dewi,Risi,Lotte,Carmen"))>
	
	<cffunction name="init">
	</cffunction>
	
	<cffunction name="getData">
		<cfreturn variables.data>
	</cffunction>
	
	<cffunction name="getDetail">
		<cfargument name="id">
		<cfset var local = StructNew()>
		<cfquery name="local.result" dbtype="query">
		SELECT *
		FROM variables["data"]
		WHERE id = #arguments.id#
		</cfquery>
		<cfreturn local.result>
	</cffunction>
	
	
</cfcomponent>