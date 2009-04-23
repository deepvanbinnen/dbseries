<cfcomponent displayname="controller" hint="I am a simple controller and execute tasks.">
	<cfset variables.m = createObject("component", "model").init()>
	<cfset variables.v = createObject("component", "views").init()>
	
	<cffunction name="init"></cffunction>
	
	<cffunction name="listing">
		<cfreturn variables.v.getList(data=variables.m.getData(), keys=ListToArray("id,name"), labels=ListToArray("ID,Naam,"), link="mvc.cfm?id=")>
	</cffunction>
	
	<cffunction name="detail">
		<cfargument name="id">
		<cfreturn variables.v.getDetail(data=variables.m.getDetail(arguments.id), keys=ListToArray("id,name"), labels=ListToArray("ID,Naam,"))>
	</cffunction>
	
</cfcomponent>