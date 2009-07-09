<cfoutput>

<p>Original</p>
<cfdump var="#it.getCollection()#">
	
<cfloop condition="#it.whileHasNext()#">
<dl class="simple-output">
	<dt>Current</dt><dd>
		<ul>
			<li>age: #it.getValue("age")#; </li>
			<li>name: #it.getValue("name")#</li>
		</ul>
		<cfset it2 = it.new().init(it.current)>
		<dl class="simple-output">
			<cfloop condition="#it2.whileHasNext()#">
				<dt>#it2.key#</dt><dd>#it2.current#</dd>
			</cfloop>
		</dl>
		<cfdump var="#it2.getCollection()#"></dd>
	<dt>Key</dt><dd>#it.key#</dd>
	<dt>Index</dt><dd>#it.index#</dd>
	<dt>Name</dt><dd>#it.current.name#</dd>
	<dt>Age</dt><dd>#it.current.age#</dd>
</dl>
</cfloop>

</cfoutput>