<cfswitch expression="#request.ebx.act#">
	<cfcase value="thankyou">
		<cfset request.ebx.do(action="home.loginform", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.do(action="home.downloadbutton", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.include("dsp_thankyou.cfm")>
	</cfcase>
	
	<cfcase value="send">
		<cfset xfa.sent = self & "contact.thankyou">
		<cfset request.ebx.include("act_send.cfm")>
		<cflocation addtoken="false" url="#xfa.sent#">
	</cfcase>
	
	<cfdefaultcase>
		<cfset attributes.title = "Contact">
		<cfset xfa.contact = self & "contact.send">
		<cfset request.ebx.do(action="home.loginbox", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.do(action="home.downloadbutton", contentvar="content.sidebar", append="true")>
		<cfset request.ebx.include("dsp_form.cfm")>
	</cfdefaultcase>
</cfswitch>