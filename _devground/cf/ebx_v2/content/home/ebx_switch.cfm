<cfswitch expression="#request.ebx.act#">
	<cfcase value="box">
		<cfparam name="attributes.title"  default="aaa">
		<cfparam name="attributes.content" default="">
		<cfset request.ebx.include("inc_box.cfm")>
		<!--- <cfset request.ebx.stack._dump()> --->
	</cfcase>
	
	<cfcase value="loginform">
		<cfset login.title  = "Login">
		<cfset request.ebx.include(template="dsp_loginform.cfm", contentvar="login.content")>
		<cfset request.ebx.do(action="home.box", params=login)>
	</cfcase>
	
	<cfcase value="form">
		<cfset request.ebx.include(template="dsp_loginform.cfm")>
	</cfcase>
	
	<cfdefaultcase>
		<cfset request.ebx.do(action="home.loginform", contentvar="content.loginbox")>
		<cfset request.ebx.include(template="inc_footer.cfm", contentvar="content.loginbox", append="true")>
		<cfset request.ebx.include(template="inc_hometekst.cfm", contentvar="content.home")> 
		<cfset request.ebx.include("dsp_tonen.cfm")>
	</cfdefaultcase>
</cfswitch>