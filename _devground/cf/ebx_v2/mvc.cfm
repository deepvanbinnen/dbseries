<cfset ebx = createObject("component", "cfc.ebx.core.ebx").init("home.show")> 

<cfset y = 1>

<cfdump var="#variables#">
<cfoutput>#ebx.execute(variables)#<br />
#ArrayToList(ebx.getErrors(), "<br />")#
</cfoutput>
<cfdump var="#ebx#">
