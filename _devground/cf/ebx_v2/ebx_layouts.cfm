<cfparam name="attributes.view" default="screen">
<cfparam name="attributes.stoplayout" default="false">

<cfset request.ebx.layoutdir = "layout/">
<cfset request.ebx.layoutfile = "">

<cfswitch expression="#attributes.view#">
	<cfcase value="xhr">
		<cfset request.ebx.layoutfile = "lay_xhr.cfm">
	</cfcase>
	
	<cfcase value="clean,widget">
		<cfset request.ebx.layoutfile = "lay_clean.cfm">
	</cfcase>
	
	<cfcase value="popup">
		<cfset request.ebx.layoutfile = "lay_popup.cfm">
	</cfcase>
	
	<cfcase value="preview">
		<cfset request.ebx.layoutfile = "lay_preview.cfm">
	</cfcase>
	
	<cfdefaultcase>
		<cfset request.ebx.layoutfile = "lay_main.cfm">
	</cfdefaultcase>
</cfswitch>

<cfif attributes.stoplayout>
	<cfset request.ebx.layoutDir = "">
	<cfset request.ebx.layoutFile = "">
</cfif>

