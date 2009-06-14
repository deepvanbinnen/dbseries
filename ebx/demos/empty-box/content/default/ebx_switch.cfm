<cfswitch expression="#request.ebx.act#">
	<cfdefaultcase>
		<!--- Content goes here --->
		<cfset request.ebx.include("dsp_lorem.cfm")>
	</cfdefaultcase>
</cfswitch>