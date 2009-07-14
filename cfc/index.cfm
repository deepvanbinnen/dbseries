<cfset ins = createObject("component", "Inspector")>
<cfset myCFC = createObject("component", "DBForm")>

<cfdump var="#myCFC._dump()#">

<cfset start = getTickCount()>
<cfset myArr = ArrayNew(1)>
<cfloop from="1" to="1000" index="i">
	<!--- <cfset myStr = StructNew()>
	<cfset StructInsert(myStr, "id", i)>
	<cfset StructInsert(myStr, "name", "property_" & i)>
	<cfset StructInsert(myStr, "value", Ceiling(Rand()*100))>
	<cfif i eq 5>
		<cfset StructInsert(myStr, "flag", true)>
	</cfif>
	<cfif i eq 1>
		<cfset StructInsert(myStr, "flag", myCFC.addRule)>
	</cfif>
	
	<cfset ArrayAppend(myArr, myStr)> --->
	<cfset myCFC = createObject("component", "DBForm").init("obj " & i)>
	<cfset ArrayAppend(myArr, myCFC)>
</cfloop>

<cfoutput>1000 objects created: #getTickCount()-start#ms</cfoutput>


<cfset start = getTickCount()>
<cfset myArr = ArrayNew(1)>

<cfset secCFC = createObject("component", "DBForm")>



<cfdump var="#ins._dumpClass(getMetaData(secCFC).getClass().getSuperClass())#" version="long">

<!--- <cfloop from="1" to="1000" index="i">
	
	<cfset ArrayAppend(myArr, myCFC)>
</cfloop>

<cfoutput>1000 objects created: #getTickCount()-start#ms</cfoutput>
 --->
<!--- <cfset q1 = ins._as2q(myArr)> --->


