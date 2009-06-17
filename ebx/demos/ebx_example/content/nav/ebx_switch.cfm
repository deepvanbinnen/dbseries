<cfswitch expression="#request.ebx.act#">
	<cfdefaultcase>
		<cfset xfa.home    = self & "home.show">
		<cfset xfa.contact = self & "contact.form">
		<cfset xfa.source  = self & "source.browse">
		<cfinclude template="dsp_mainnav.cfm">
		<!--- <cfset request.ebx.include("dsp_mainnav.cfm")> --->
	</cfdefaultcase>
</cfswitch>