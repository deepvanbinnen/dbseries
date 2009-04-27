<cfset ebx.parseGlobalSettings("ebx_settings.cfm")>
<cfset ebx.parseCircuits("ebx_circuits.cfm")>
<cfset a = ebx.getRequest("home.tonen")>

<cfdump var="#request.ebx.circuits#">
<cfdump var="#a#">
