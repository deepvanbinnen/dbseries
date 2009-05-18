<p><cfoutput>this is just another output<br />
self = <strong><cfif IsDefined("self")>#self#<cfelse>Undefined!</cfif></strong></cfoutput>
</p>

<cfdump var="#attributes#">
