<p>hoi</p>

<cfset self = "self is ">

<cfdump var="#request.ebx.include('tpl2.cfm')#">

<!--- <cfset x = "I am set by the page">
<cfoutput>#x#</cfoutput>
<cfset y = createObject("component", "myComponent").init()>
<cfoutput>#x#</cfoutput> --->
<!--- <cfmodule template="index.cfm"> --->

<!--- <cfoutput>#self#</cfoutput> --->
<!--- <cfset application.ctx = getPageContext()>
<cfset application.ctx.include("mvc.cfm")>

<cfset output = application.ctx.getOut().getString()>
<cfset application.ctx.getOut().clearBuffer()>
<cfoutput>#output#</cfoutput>
<cfoutput>#application.tmpout#</cfoutput> --->

<!--- <cfdump var="#getPageContext().getRequest()#">


<cfdump var="#getPageContext().getResponse()#">

<cfdump var="#getPageContext().getServletContext()#"> --->
<!---



<cfset output2 = ctx.getOut().getString()>
<cfset ctx.getOut().clearBuffer()>

<cfoutput>#output2#</cfoutput> --->
