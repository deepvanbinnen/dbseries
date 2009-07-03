<cfset start = getTickCount()>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>DBIterator</title>
<style type="text/css">
html {font-size: 62.5%;}
body {font-size: 1.2em;}
dl.simple-output {width: 250px;}
dl.simple-output dt {clear: left; width: 70px; float: left;}
dl.simple-output dd {width: 160px;}
</style>
</head><body>
<h2>Iterator demo</h2>

<h3>Array</h3>
<cfset myArray = ArrayNew(1)>
<cfset ArrayAppend(myArray,"deepak")>
<cfset ArrayAppend(myArray,"dewi")>
<cfset ArrayAppend(myArray,"lotte")>
<cfset ArrayAppend(myArray,"rishi")>

<cfset it = createObject("component", "DBIterator").init(myArray)>
<cfinclude template="simple_output.cfm">

<h3>Struct</h3>

<cfset myStruct = StructNew()>
<cfset StructInsert(myStruct,"deepak","31")>
<cfset StructInsert(myStruct,"dewi", "23")>
<cfset StructInsert(myStruct,"lotte", "24")>
<cfset StructInsert(myStruct,"rishi", "26")>

<cfset it.create(myStruct)>
<cfinclude template="simple_output.cfm">

<h3>List</h3>
<cfset myList = "deepak,dewi,lotte,rishi">
<cfset it.create(myList)>

<cfinclude template="simple_output.cfm">

 
<h3>String</h3>
<cfset myString = "deepak">
<cfset it = it.create(myString, "")>
<cfinclude template="simple_output.cfm">

<h3>Query</h3>
<cfset myQuery = QueryNew("name,age")>
<cfset QueryAddRow(myQuery)>
<cfset QuerySetCell(myQuery, "name", "deepak")>
<cfset QuerySetCell(myQuery, "age", "31")>
<cfset QueryAddRow(myQuery)>
<cfset QuerySetCell(myQuery, "name", "dewi")>
<cfset QuerySetCell(myQuery, "age", "23")>
<cfset QueryAddRow(myQuery)>
<cfset QuerySetCell(myQuery, "name", "lotte")>
<cfset QuerySetCell(myQuery, "age", "24")>
<cfset QueryAddRow(myQuery)>
<cfset QuerySetCell(myQuery, "name", "rishi")>
<cfset QuerySetCell(myQuery, "age", "26")>


<cfset it.create(myQuery)>
<cfinclude template="query_output.cfm">


<cfset it.reset()>
<cfoutput>

<p><strong>Second version</strong></p>
<cfdump var="#it.getCollection()#">

<cfset colit = createObject("component", "DBIterator").init("name,age")>
<cfloop condition="#it.whileHasNext()#">
<dl class="simple-output">
	<dt>Current</dt><dd><cfdump var="#it.current#"></dd>
	<dt>Key</dt><dd>#it.key#</dd>
	<dt>Index</dt><dd>#it.index#</dd>
	<cfset colit.reset()>
	<cfloop condition="#colit.whileHasNext()#">
		<dt>#colit.current#</dt><dd>#it.current[colit.current]#</dd>
	</cfloop>
</dl>
</cfloop>

<p>#getTickCount()-start#ms</p>
</cfoutput>

</body>
</html>