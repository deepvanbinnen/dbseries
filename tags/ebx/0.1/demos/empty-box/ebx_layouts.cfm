<cfparam name="attributes.view" default="screen">

<cfset request.ebx.layoutdir = "layout/">
<cfset request.ebx.layoutfile = "">

<cfswitch expression="#attributes.view#">
	<cfdefaultcase>
		<cfset request.ebx.layoutfile = "lay_main.cfm">
	</cfdefaultcase>
</cfswitch>

