<cfswitch expression="#request.ebx.act#">
	<cfdefaultcase>
		<cfset x = "1">
		<cfinclude template="dsp_tonen.cfm">
	</cfdefaultcase>
</cfswitch>