<cfcomponent displayname="controller" hint="I am an controller and execute tasks and or display output.">
	<cfset variables.fb    = createObject("component", "FileBrowser").init()>
	<cfset variables.views = createObject("component", "views").init()>
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="listing">
		<cfreturn variables.v.getList(data=variables.fb.browse(ExpandPath(".")), keys=ListToArray("name,size,type"), labels=ListToArray("Name,Size,Type"), link="mvc.cfm?id=")>
	</cffunction>
	
	<cffunction name="detail">
		<cfargument name="id">
		<cfreturn variables.v.getDetail(data=variables.fb.get(arguments.name), keys=ListToArray("name,size,type"), labels=ListToArray("ID,Naam,Type"))>
	</cffunction>
	
</cfcomponent>