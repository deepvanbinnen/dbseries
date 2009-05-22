<cfswitch expression="#request.ebx.act#">
	<cfcase value="test">
		<cfparam name="attributes.x" default="some value">
		<cfoutput><hr />x is now: #attributes.x#</cfoutput>
		asss
	</cfcase>
	
	<cfcase value="test2">
		<cfoutput>I was caught</cfoutput>
	</cfcase>
	
	<cfdefaultcase>
		asdcvv - <!--- <p><cfoutput>#self#</cfoutput></p> --->
	<!--- 	 --->
	
		<cfset mycontent = "hello">
		<cfset request.ebx.do(action="home.test", contentvar="mycontent", append="true")>
		<cfset request.ebx.include(template="dsp_joker.cfm", contentvar="somecontent", append="true")>
		<cfoutput>#somecontent#</cfoutput>
		<p>testing</p>
		<cfoutput>#mycontent#</cfoutput>
	</cfdefaultcase>
</cfswitch>