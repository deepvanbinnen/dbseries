<cfset start_exec = getTickCount()>
<cfsavecontent variable="pageOutput">
	<cfset sf = createObject("component", "cfc.sourceformat").init()>
	
	<cfset request.ebx = createObject("component", "ebx").init(appPath="", defaultact="home.tonen")>
	<cfset request.ebx.setup()>
	
	<cfset request.ebx = request.ebx.getParser()>
	<!--- <cfset request.ebx.initialise()> --->
	<cfset request.ebx.execute()>
</cfsavecontent>

<cfoutput>#sf.freeTheSource(pageOutput)#</cfoutput>

<!--- <cfset intf = request.ebx.getInterface()._test()>
<cfdump var="#intf#"> --->
<!--- <cfdump var="#request.ebx.getTicks()#"> --->
<cfoutput><p style="clear: both;">Code executed in: #getTickCount()-start_exec#ms</p></cfoutput>
