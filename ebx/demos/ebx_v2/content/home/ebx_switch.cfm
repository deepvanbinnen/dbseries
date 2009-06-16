<cfif request.ebx.isOriginalAction()>
	<cfset ArrayAppend(request.ebx.postPlugins, "dumpContext")>
</cfif>

<cfswitch expression="#request.ebx.act#">
	<cfcase value="box">
		<cfparam name="attributes.title"  default="aaa">
		<cfparam name="attributes.content" default="">
		<cfset request.ebx.include("inc_box.cfm")>
	</cfcase>
	
	<cfcase value="login">
		<cfparam name="attributes.returl" default="#self#home.tonen">
		<cfset session.user = 1>
		<cflocation addtoken="false" url="#attributes.returl#">
	</cfcase>
	
	<cfcase value="logout">
		<cfparam name="attributes.returl" default="#self#home.tonen">
		<cfset session.user = 0>
		<cflocation addtoken="false" url="#attributes.returl#">
	</cfcase>
	
	<cfcase value="loginform">
		<cfset xfa.login  = self & "home.login">
		<cfset xfa.returl = self & request.ebx.originalAction>
		<cfset sidebarBox = StructNew()>
		<cfset sidebarBox.title  = "Login">
		<cfset request.ebx.include(template="dsp_loginform.cfm", contentvar="sidebarBox.content")>
		<cfset request.ebx.include(template="inc_loginfooter.cfm", contentvar="sidebarBox.content", append="true")>
		<cfset request.ebx.do(action="home.box", params=sidebarBox)>
	</cfcase>
	
	<cfcase value="logininfo">
		<cfset xfa.returl = self & request.ebx.originalAction>
		<cfset xfa.logout  = self & "home.logout&amp;returl=#xfa.returl#">
		<cfset sidebarBox = StructNew()>
		<cfset sidebarBox.title  = "Userinfo">
		<cfset request.ebx.include(template="dsp_logininfo.cfm", contentvar="sidebarBox.content")>
		<cfset request.ebx.do(action="home.box", params=sidebarBox)>
	</cfcase>
	
	<cfcase value="loginbox">
		<cfif session.user eq 0>
			<cfset request.ebx.do(action="home.loginform")>
		<cfelse>
			<cfset request.ebx.do(action="home.logininfo")>
		</cfif>
	</cfcase>
	
	<cfcase value="downloadbutton">
		<cfset sidebarBox = StructNew()>
		<cfset sidebarBox.title = "">
		<cfset xfa.download = self & "source.download">
		<cfset request.ebx.include(template="dsp_downloadbutton.cfm", contentvar="sidebarBox.content")>
		<cfset request.ebx.do(action="home.box", params=sidebarBox)>
	</cfcase>
	
	<cfdefaultcase>
		<cfset request.ebx.do(action="loginbox", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.do(action="downloadbutton", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.include("dsp_home.cfm")>
	</cfdefaultcase>
</cfswitch>