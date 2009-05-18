<cfset ds = "">
<cfset mappingpath = "/deepak/ebx_v2/"><!--- MUST include trailing slash --->

<cfapplication name="test" sessionmanagement="true" >

<cfif NOT IsDefined("application.ctx")>
	<cfset application.ctx = "aaa">
</cfif>

<cfif NOT IsDefined("application.tmpout")>
	<cfset application.tmpout = "">
</cfif>