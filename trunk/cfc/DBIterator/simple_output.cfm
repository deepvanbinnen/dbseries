<cfoutput>

<p>Original</p>
<cfdump var="#it.getCollection()#">
	
<cfloop condition="#it.whileHasNext()#">
<dl class="simple-output">
	<dt>Current</dt><dd>#it.current#</dd>
	<dt>Key</dt><dd>#it.key#</dd>
	<dt>Index</dt><dd>#it.index#</dd>
</dl>
</cfloop>

</cfoutput>