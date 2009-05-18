<!---
File: example2.cfc

Print out all the CF functions.
--->
<cfset methods = getPageContext().getPage().getClass().getSuperClass().getMethods()>

<cfloop array="#methods#" index="i">
<cfset writeOutput(i)><br>
</cfloop>