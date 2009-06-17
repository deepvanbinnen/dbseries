<cfset start_exec = getTickCount()>

<!--- ------------------------------------------------------------------------------------------- --->
<!--- 
Instantiation happens in two phases: 
 * first we do configuration and from the configuration we request the parser. 
 * This allows us to cache/freeze the config  
--->
<!--- ------------------------------------------------------------------------------------------- --->

<!--- ------------------------------------------------------------------------------------------- --->
<!--- 1. Create config, this may go in application scope --->
<!--- ------------------------------------------------------------------------------------------- --->
<!--- Include the structs which contain the mappings for the circuits and plugins --->
<cfinclude template="ebx_circuits.cfm">
<cfinclude template="ebx_plugins.cfm">

<!--- 
Change mapping to component and application path conform your own settings.
Application path is the mapping to the directory that contains the ebx_settings.cfm file.
 --->
<cfset ebx = createObject(
	  "component"
	, "dbseries.trunk.ebx.cfc.ebx"
	).init(
		  appPath="/dbseries/trunk/ebx/demos/ebx_example/"
		, defaultact="home.show"
		, circuits=circuits
		, plugins=plugins
		)>
<!--- ------------------------------------------------------------------------------------------- --->

<!--- ------------------------------------------------------------------------------------------- --->
<!--- 2. Request the parser  --->
<!--- NOTE: you must have a parser per client request  --->
<!--- ------------------------------------------------------------------------------------------- --->
<cfset request.ebx = ebx.getParser()>
<cfset request.ebx.execute()>
<!--- ------------------------------------------------------------------------------------------- --->

<!-- <cfoutput>Code executed in: #getTickCount()-start_exec#ms</cfoutput> -->