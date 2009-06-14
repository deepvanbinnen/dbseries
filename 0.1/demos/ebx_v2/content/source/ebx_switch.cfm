<cfswitch expression="#request.ebx.act#">
	<cfcase value="list">
		<cfset request.ebx.include("dsp_list.cfm")>
	</cfcase>
	
	<cfcase value="download">
		<cfset attributes.title = "Download">
		<cfset request.ebx.do(action="home.loginbox", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.do(action="#request.ebx.thisCircuit#.list", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.include("dsp_download.cfm")>
	</cfcase>
	
	<cfdefaultcase>
		<cfset attributes.title = "Browse Source">
		<cfset request.ebx.do(action="home.loginbox", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.do(action="#request.ebx.thisCircuit#.list", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.include("dsp_info.cfm")>
	</cfdefaultcase>
</cfswitch>