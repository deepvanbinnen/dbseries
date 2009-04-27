<cfcomponent displayname="ebxRequestHandler" hint="I am a ebx-request-handler and handle an ebx-request">
	<cfset variables.ebx = StructNew()>
	<cfset variables.ebx.VERSION = "2.0">
	<cfset variables.ebx.AUTHOR = "Bharat Deepak Bhikharie - Leiden 2009">
	<cfset variables.ebx.DESCRIPTION = "This file is designed to mimic fusebox functionality in a non-fusebox environment.">
	
	<cfset variables.ebx.errors     = ArrayNew(1)><!--- provide simple "sink" for error messages --->
	<cfset variables.ebx.debug      = ArrayNew(1)><!--- provide simple "sink" for debug messages --->
	
	<cfset variables.ebx.appPath    = "">
	<cfset variables.ebx.reqName    = "">
	<cfset variables.ebx.actionvar  = "act">
	<cfset variables.ebx.defaultact = "home.tonen">
	
	<cfset variables.ebx.circuits = StructNew()>
	
	<cfset variables.ebx.plugins = StructNew()>
	<cfset variables.ebx.prePlugins = ArrayNew(1)>
	<cfset variables.ebx.postPlugins = ArrayNew(1)>
	
	<cfset variables.ebx.requestHandler = ArrayNew(1)>
	<!--- <cfset ArrayAppend(variables.ebx.requestHandler, variables.ebx.thisRequest)>
	<cfset variables.ebx.thisRequest.handlerIndex = ArrayLen(variables.ebx.requestHandler)> --->
	
	<!--- declare properties and interfaces --->
	<cfset variables.ebx.ebxroot    = "">
	<cfset variables.ebx.context    = "">
	<cfset variables.ebx.request    = "">
	<cfset variables.ebx.parameters = "">
	<cfset variables.ebx.settings   = "">
	
	<cfset setDebug("Init ebx", 0)>
	
	<cffunction name="init">
		<cfargument name="appPath" required="true" type="string" hint="coldfusion mapping to the root of the box" default="">
			<!--- setup properties and interfaces --->
			<cfset setDebug("Initializing ebx with app path set at #arguments.appPath#", 0)>
			<cfset variables.ebx.appPath    = arguments.appPath>
			<cfset variables.ebx.context    = createObject("component", "ebxExecutionContext").init(this)>
			<cfset variables.ebx.request    = createObject("component", "ebxRequest").init(this)>
			<cfset variables.ebx.parameters = createObject("component", "ebxParameters").init(this)>
			<cfset variables.ebx.settings   = createObject("component", "ebxSettings").init(this)>
			<cfset scopeCopy("VERSION,AUTHOR,DESCRIPTION,circuits", variables.ebx, this)>
			<cfset handleRequest()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="handleRequest">
		<cfset var local = StructNew()>
		
		<cfset setDebug("Start handling main request", 0)>
		
		<cfset local.act = variables.ebx.parameters.getParameter(variables.ebx.actionvar, variables.ebx.defaultact)>
		<cfset setDebug("Executing action #local.act#", 0)>
		<cfif variables.ebx.request.parseAction(local.act)>
			<cfset local.circuit = variables.ebx.request.getSwitch()>
			<cfset variables.ebx.request.updateBoxProperties()>
			<cfset include(variables.ebx.request.getSwitch())>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getInclude" hint="get the full path for file include">
		<cfargument name="filename" required="true" type="string" hint="the file to include">
		<cfreturn variables.ebx.appPath & arguments.filename>
	</cffunction>
	
	<cffunction name="include">
		<cfargument name="filename" required="true" type="string" hint="the file to include">
		<cfset variables.ebx.context.include(getInclude(arguments.filename))>
	</cffunction>
	
	<cffunction name="appendOutput">
		<cfargument name="output" required="true" type="string" hint="the output to append">
		<cfset variables.ebx.request.appendOutput(arguments.output)>
	</cffunction>
	
	<cffunction name="getOutput">
		<cfreturn variables.ebx.request.getOutput()>
	</cffunction>
	
	<cffunction name="scopeCopy" hint="copy variables from source scope to destination scope">
		<cfargument name="keys" required="true" type="string" hint="the list of keys to copy">
		<cfargument name="source" required="true" type="struct" hint="the source scope">
		<cfargument name="destination" required="true" type="struct" hint="the destination scope">
		<cfargument name="overwrite"    required="false" type="boolean" default="false" hint="whether to overwrite the variable in the this scope variable if it already exists">
		
		<cfset var local = StructNew()>
		<cfloop list="#arguments.keys#"  index="local.varname">
			<cfif StructKeyExists(arguments.source,local.varname) AND (NOT StructKeyExists(arguments.destination,local.varname) OR arguments.overwrite)>
				<cfset arguments.destination[local.varname] = arguments.source[local.varname]>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="getInterface">
		<cfargument name="name" required="true" type="string" hint="the internal interface to return">
		<cfswitch expression="#arguments.name#">
			<cfcase value="settings,parameters,request,context">
				<cfreturn variables.ebx[arguments.name]>
			</cfcase>
			<cfdefaultcase>
				<cfset setError("No such interface: #arguments.name#")>
			</cfdefaultcase>
		</cfswitch>
		<cfreturn>
	</cffunction>
	
	<cffunction name="setError" hint="adds message to errorsink">
		<cfargument name="message" required="true">
		<cfset setDebug(arguments.message, 1)>
		<cfset ArrayAppend(variables.ebx.errors, arguments.message)>
	</cffunction>
	
	<cffunction name="getErrors" hint="get the error sink">
		<cfreturn variables.ebx.errors>
	</cffunction>
	
	<cffunction name="hasError" hint="returns number of errors in sink">
		<cfreturn ArrayLen(variables.ebx.errors)>
	</cffunction>
	
	<cffunction name="setDebug" hint="adds message to debugsink">
		<cfargument name="message" required="true">
		<cfargument name="level"   required="true" type="numeric">
		
		<cfset var local = StructNew()>
		<cfset local.message = arguments.message>
		<cfset local.level   = arguments.level>
		<cfset ArrayAppend(variables.ebx.debug, local)>
	</cffunction>
	
	<cffunction name="getDebug" hint="get messages from debugsink based on level">
		<cfargument name="level"    required="true" type="numeric" default="0">
		<cfargument name="asstring" required="false" type="boolean" default="true">
		
		<cfset var local = StructNew()>
		<cfset local.output = ArrayNew(1)>
		<cfset local.debug  = _getDebug()>
		<cfloop from="1" to="#ArrayLen(local.debug)#" index="local.i">
			<cfif local.debug[local.i].level GTE arguments.level>
				<cfset ArrayAppend(local.output, local.debug[local.i].level & ": " & local.debug[local.i].message)>
			</cfif>
		</cfloop>
		<cfif arguments.asstring>
			<cfreturn ArrayToList(local.output, "<br />")>
		<cfelse>
			<cfreturn local.output>
		</cfif>
	</cffunction>
	
	<cffunction name="_getDebug" hint="get messages from debugsink based on level">
		<cfreturn variables.ebx.debug>
	</cffunction>
	
</cfcomponent>