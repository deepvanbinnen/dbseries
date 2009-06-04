<cfswitch expression="#request.ebx.act#">
	<cfdefaultcase>
		<cfset xfa.home    = self & "home.show">
		<cfset xfa.contact = self & "contact.form">
		<cfset xfa.source  = self & "source.browse">
		<cfset request.ebx.include("dsp_mainnav.cfm")>
	</cfdefaultcase>
</cfswitch>