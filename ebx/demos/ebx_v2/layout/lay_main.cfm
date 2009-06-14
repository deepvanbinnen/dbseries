<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>deepvanbinnen</title>
<link type="text/css" href="layout/style.css" rel="stylesheet" media="screen" />
</head><body>

<div id="canvas"> 
	<div id="main-nav">
		<cfset request.ebx.do(action="nav.mainnav")>
	</div>
	<div id="sidebar">
		<cfparam name="content.sidebar" default="">
		<cfoutput>#content.sidebar#</cfoutput>
	</div>
	<div id="page-content">
		<cfoutput><h1>#attributes.title#</h1></cfoutput>
		<cfoutput>#request.ebx.layout#</cfoutput>
	</div>
</div>
<div id="footer">ebx_v2 demo &copy;2009</p>
</body></html>
