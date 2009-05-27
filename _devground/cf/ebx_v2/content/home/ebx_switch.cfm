<cfswitch expression="#request.ebx.act#">
	<cfcase value="test">
		<cfparam name="attributes.x" default="some value">
		<cfoutput><hr />x is now: #attributes.x#</cfoutput>
		asss
		<cfdump var="#request.ebx#">
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
		<cfset myCustomAttr.x = "4560">
		
		<cfset aVar = "abcdef">
		<cfoutput>#aVar#</cfoutput>
		<cfset request.ebx.do(action="home.test2", params=myCustomAttr)>
		<cfset myCustomAttr.abc = "5860">
		<cfset request.ebx.include(template="dsp_incl.cfm", params=myCustomAttr, contentvar="aVar", append="true")>
		<cfoutput>#aVar#</cfoutput>
		<cfset request.ebx.do(action="home.test", params=myCustomAttr, contentvar="aVar")>
		<!--- <p>testing</p>
		<cfoutput>#mycontent#</cfoutput> --->
		
		<cfoutput>#aVar#</cfoutput>
	</cfdefaultcase>
</cfswitch>