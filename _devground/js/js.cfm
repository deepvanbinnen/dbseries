<cfparam name="attributes.javascripts" default="#ArrayNew(1)#">
<cfset ArrayAppend(attributes.javascripts,"DBScript/DBScript.js")>
<cfset ArrayAppend(attributes.javascripts,"DBScript/dollar_v2.js")>
<cfset ArrayAppend(attributes.javascripts,"DBScript/events_v2.js")>
<cfset ArrayAppend(attributes.javascripts,"DBScript/DOMHelper_v2.js")>
<cfset ArrayAppend(attributes.javascripts,"DBScript/string.js")>
<cfset ArrayAppend(attributes.javascripts,"DBScript/tables.js")>
<cfset ArrayAppend(attributes.javascripts,"DBScript/xhr_v2.js")>
<cfset ArrayAppend(attributes.javascripts,"DBScript/array_v2.js")>
<cfset ArrayAppend(attributes.javascripts,"myscripts.js")>

<cfcontent type="text/javascript">
<cfloop array="#attributes.javascripts#" index="jsfile"><cfinclude template="#jsfile#"></cfloop>