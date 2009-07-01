<cfoutput>

<p>Original</p>
<cfdump var="#it.getCollection()#">
	
<cfloop condition="#it.whileHasNext()#">
<dl class="simple-output">
	<dt>Current</dt><dd><cfdump var="#it.current#"></dd>
	<dt>Key</dt><dd>#it.key#</dd>
	<dt>Index</dt><dd>#it.index#</dd>
	<dt>Name</dt><dd>#it.current.name#</dd>
	<dt>Age</dt><dd>#it.current.age#</dd>
</dl>
</cfloop>

</cfoutput>