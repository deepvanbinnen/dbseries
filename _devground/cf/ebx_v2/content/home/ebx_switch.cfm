<cfswitch expression="#request.ebx.act#">
	<cfcase value="test">
		<cfparam name="attributes.x" default="some value">
		<cfoutput><hr />x is now: #attributes.x#</cfoutput>
		asss
	</cfcase>
	
	<cfcase value="test2">
		<cfoutput>I was caught: #attributes.abc#</cfoutput>
	</cfcase>
	
	<cfdefaultcase>
		asdcvv - <!--- <p><cfoutput>#self#</cfoutput></p> --->
	<!--- 	 --->
		<cfoutput>#y#</cfoutput>
		<cfset mycontent = "hello">
		
		<cfset attributes.abc = "123">
		
		<cfset myCustomAttr = StructNew()>
		<cfset myCustomAttr.abc = "4560">
		
		<cfset request.ebx.do(action="home.test2", params=myCustomAttr)>
		<cfset request.ebx.include(template="dsp_incl.cfm", params=myCustomAttr)>
		
		<cfoutput>#attributes.abc#</cfoutput>
		<!--- <cfset request.ebx.do(action="home.test", contentvar="mycontent", append="true")>
		<cfset request.ebx.include(template="dsp_joker.cfm", contentvar="somecontent", append="true")>
		<cfoutput>#somecontent#</cfoutput> --->
		<p>testing</p>
		<cfoutput>#mycontent#</cfoutput>
	</cfdefaultcase>
</cfswitch>