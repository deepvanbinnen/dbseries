<cfparam name="start" default="#getTickCount()#">

<cffunction name="tick">
	<cfparam name="current" default="#getTickCount()#">
	
	<cfif IsDefined("current")>
		<cfoutput>#current-getTickCount()#ms</cfoutput>
	</cfif>
	<cfset current = getTickCount()>
	<cfoutput>#current-start#ms</cfoutput>
</cffunction>

<cfset sf = createObject("component", "cfc.sourceformat").init()>

<cfset request.ebx = createObject("component", "ebx").init(appPath="", defaultact="home.tonen")>
<cfset request.ebx.setup()>
<cfset request.ebx = request.ebx.getParser()>
<cfset request.ebx.initialise()>
<cfset request.ebx.execute()>

<!--- <cfloop from="1" to="#ArrayLen(request.ebx.stack.getStack())#" index="i">
	<cfdump var="#request.ebx.stack.get(i)._dump()#" version="long">
</cfloop> --->
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