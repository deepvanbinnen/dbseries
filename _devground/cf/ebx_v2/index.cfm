<cfset sf = createObject("component", "cfc.sourceformat").init()>

<cfset request.ebx = createObject("component", "ebx").init(appPath="", defaultact="home.tonen")>
<cfset request.ebx.setup()>
<cfset request.ebx = request.ebx.getParser()>
<cfset request.ebx.execute()>

<cfdump var="#request.ebx#">






<!--- <cfdump var="#a.indexOf(JavaCast( "string", "a"))#"> --->
<!--- Used
<cfparam name="attributes" default="#StructNew()#">
<cfset request.ebx = createObject("component", "ebx").init(appPath="", defaultact="home.tonen")>
<cfset request.ebx.setup()>
<cfset request.ebx = request.ebx.getParser(attributes)>
<cfsavecontent variable="outHTML">
	<cfset request.ebx.execute()>
</cfsavecontent>
<cfoutput>#sf.freeTheSource(outHTML)#</cfoutput>
  --->

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