<cfset request.ebx = createObject("component", "dbseries.trunk.ebx.cfc.ebx").init(
	  appPath="/dbseries/trunk/ebx/demos/empty-box/"
	, defaultact="default.tonen")>

<cfset request.ebx.addCircuit("default", "content/default/")>

<cfset request.ebx = request.ebx.getParser()>
<cfset request.ebx.execute()>
