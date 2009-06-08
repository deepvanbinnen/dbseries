<cfset start_exec = getTickCount()>
<cfsavecontent variable="pageOutput">
	<cfset sf = createObject("component", "cfc.sourceformat").init()>
	
	<cfset request.ebx = createObject("component", "ebx").init(appPath="", defaultact="home.tonen")>
	<cfset request.ebx.setup()>
	
	<cfset request.ebx = request.ebx.getParser()>
	<cfset request.ebx.execute()>
</cfsavecontent>

<cfoutput>#sf.freeTheSource(pageOutput)#</cfoutput>
<cfoutput><p style="clear: both;">Code executed in: #getTickCount()-start_exec#ms</p></cfoutput>

<!--- <cfdump var="#request.ebx.getEbx()#"> --->

<!--- 
STACK DEBUGGING
<cfset pi = request.ebx.getInterface()>
<cfset debug = pi.getExecutedStack()>
<cfloop from="1" to="#ArrayLen(debug)#" index="i">
	<cfdump var="#debug[i]._dump()#">
</cfloop>
<cfdump var="#debug#" version="long">

CONTEXT DEBUGGING
<cfdump var="#pi.getCurrentContext()._dump()#">

EBX DEBUGGING
<cfdump var="#request.ebx#">

 --->