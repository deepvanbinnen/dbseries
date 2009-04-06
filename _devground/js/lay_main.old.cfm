<cfparam name="attributes.javascripts" default="#ArrayNew(1)#">
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/lib/dollar.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/lib/events.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/lib/email.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/lib/classes.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/lib/DOMHelper.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/lib/string.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/widgets.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/xhr.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/taconite2.0/taconite-client-min.js")>
<cfset ArrayAppend(attributes.javascripts,"http://www.wnf.nl/media/js/taconite2.0/taconite-parser-min.js")>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head><title>Rangerclub Moderator</title>
<link type="text/css" rel="stylesheet" href="layout/css/global.css" />
<cfloop array="#attributes.javascripts#" index="jsfile"><script src="#jsfile#" type="text/javascript"></script>
</cfloop>
</head><body>

<div id="main">
	
	<ul id="tabs">
		<li>Gebruikers selecteren</li>
		<li>Actie selecteren</li>
		<li>Uitvoeren</li>
	</ul>
	
	<div class="tabcontent"> 
		<form name="filter" id="filter" method="post" action="">
			<label for="name">Naam</label>
			<span>bevat</span>
			<input type="text" id="name" name="name" value="" />
			<input type="submit" id="filterbtnsubmit" name="filterbtnsubmit" value="tonen" />
		</form>
		<div id="gebruikers"></div>
	</div>
	<div class="tabcontent hidden">
		<li><a href="#xfa.blokkeren#">Blokkeren</a></li>
		<li><a href="#xfa.mailen#">Mailen</a></li>
		<li><a href="#xfa.sinterklaas#">Hupies toekennen</a></li>
	</div>
	<div class="tabcontent hidden">
		<div>Blokkeren</div>
		<div>Aantal hupies</div>
		<div>Mail tekst</div>
	</div>
</div>

<div id="gebrselectie">
	<h2>Geselecteerde gebruikers</h2>
	<ul id="gebr">
		
	</ul>
</div>


</body></html>
</cfoutput>

