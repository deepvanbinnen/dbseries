<cfset dmp=createobject("component", "introspect").init()>
<!--- <cfset dmp._dumpCurr()> --->

<cfset self = "claudia">

<cfinclude template="tpl2.cfm">

<cfset dmp.context.include("ebx_settings.cfm")>


<cfset  application.ctx = getPageContext()>
<cfset application.ctx.include("tpl2.cfm")>

<cfset dmp._dumpCurr()>


<cfset it = dmp.response.getClass().getDeclaredField('jspInclude').getClass().getFields()>
<cfloop from="1" to="#ArrayLen(it)#" index="i">
	<cfdump var="#it[i].getName()#">
</cfloop>
zsasasa
<cfdump var="#dmp.response.getClass().getDeclaredField('jspInclude').getClass().getFields()#">

<!--- <cfdump var="#dmp.response.getOutputAsString()#">

<cfset it = dmp.servlet.getClass().getDeclaredFields()>



 --->

<!--- <cfset dmp.context.getOut().flush()> --->