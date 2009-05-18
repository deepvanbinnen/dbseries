<cfset sf = createObject("component", "cfc.sourceformat").init()>

<cfset request.ebx = createObject("component", "ebx").init()>
<cfset request.ebx.setup(appPath="", defaultact="home.tonen")>

<cfset request.ebx = request.ebx.initialise(scopecopylist="url,form", parsesettingsfile=true)>
<cfsavecontent variable="outHTML">
	<cfset request.ebx.execute()>
</cfsavecontent>
<cfoutput>#sf.freeTheSource(outHTML)#</cfoutput>
<cfset act = request.ebx.getAttribute(request.ebx.getParameter("actionvar"), request.ebx.getParameter("defaultact"))>


<!--- <cfset request.ebx = createObject("component", "ebxParser").init(request.ebx)>

<cfoutput>
	#obj._dump()#
</cfoutput>

<cfset req = obj.createRequest(act)>
<cfif req.isExecutable()>
	<cfset obj.addRequest(req)>
	<cfoutput>
		#obj._dump()#
	</cfoutput>
</cfif>
<!--- <cfdump var="#obj#"> --->

 --->