<cfswitch expression="#request.ebx.act#">
	<cfcase value="box">
		<cfparam name="attributes.title"  default="">
		<cfparam name="attributes.content" default="">
		<cfset request.ebx.include("inc_box.cfm")>
	</cfcase>
	
	<cfcase value="loginform">
		<cfset login.title  = "Login">
		<cfset request.ebx.include(template="dsp_loginform.cfm", contentvar="login.content")>
		<cfset request.ebx.do(action="home.box", params=login)>
	</cfcase>
	
	<cfdefaultcase>
		<cfset request.ebx.do(action="home.loginform", contentvar="content.loginbox")>
		<cfset request.ebx.include(template="inc_hometekst.cfm", contentvar="content.home")>
		<cfset request.ebx.include("dsp_tonen.cfm")>
	</cfdefaultcase>
</cfswitch>