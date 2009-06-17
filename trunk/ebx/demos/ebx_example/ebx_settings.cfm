<cfapplication name="test" sessionmanagement="true" >
<cfparam name="session.user" default="0">

<cfparam name="attributes.title" default="e-Box v2">
<!--- <cfparam name="attributes.act" default="nav.tonen"> --->
<cfset self = "index.cfm?#request.ebx.getParameter("actionvar")#=">
