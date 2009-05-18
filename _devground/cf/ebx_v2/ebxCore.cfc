<cfcomponent displayname="ebxCore" hint="I represent an abstract interface for ebx">
	<cfset variables.ebx = "">
	<cfset variables.interfaces = StructNew()>
	
	<cffunction name="init">
		<cfargument name="ebx" type="ebx" required="true">
		<cfset variables.ebx = arguments.ebx>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getInterface" hint="get an ebx interface">
		<cfargument name="name" required="false" type="string" default="" hint="name of the interface to return">
		<!--- <cfset var local = StructNew()>
		<cfif NOT StructKeyExists(variables.interfaces, arguments.name)>
			<cfset local.interface = variables.ebx.getInterface(arguments.name)>
			<cfif NOT IsBoolean(local.interface)>
				<cfset StructInsert(variables.interfaces, arguments.name, local.interface)>
			</cfif>
			<cfreturn local.interface>
		<cfelse>
			<cfreturn variables.interfaces[arguments.name]>
		</cfif> --->
		<cfreturn getCoreInterface(arguments.name)>
	</cffunction>
	
	<cffunction name="getCoreInterface" hint="get an ebx interface">
		<cfargument name="name" required="false" type="string" default="" hint="name of the interface to return">
		<cfreturn variables.ebx.getInterface(arguments.name)>
	</cffunction>
	
	<cffunction name="getAppPath">
		<cfreturn variables.ebx.getAppPath()>
	</cffunction>
	
	<cffunction name="getCurrentDir">
		<cfreturn getAppPath() & getCircuitDir()>
	</cffunction>
	
	<cffunction name="getCurrentCircuit">
		<cfreturn variables.ebx.thisCircuit>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfreturn variables.ebx.circuitdir>
	</cffunction>
	
	<cffunction name="getLayoutDir">
		<cfreturn variables.ebx.layoutdir>
	</cffunction>
	
	<cffunction name="getLayoutFile">
		<cfreturn variables.ebx.layoutfile>
	</cffunction>
	
	<cffunction name="updateGlobalParameter">
		<cfargument name="name" required="true"  type="string" default="" hint="coldfusion mapping to the root of the box">
		<cfargument name="value" required="true"  type="any" default="" hint="coldfusion mapping to the root of the box">
		<cfargument name="overwrite" required="false" type="boolean" default="true" hint="coldfusion mapping to the root of the box">
		<cfreturn variables.ebx.updateGlobalParameter(arguments.name, arguments.value, arguments.overwrite)>
	</cffunction>	
	
	<!--- I/O Pagecontext --->	
	<cffunction name="include">
		<cfargument name="template" required="true" hint="the parameter to lookup">
		<cfargument name="flush" type="boolean" required="false" hint="the parameter to lookup" default="false">
		<cfreturn variables.ebx.getInterface("pagecontext")._ebx_include(arguments.template, arguments.flush)>
	</cffunction>
	
	<cffunction name="print">
		<cfargument name="output" required="true" type="string" default="" hint="output to print">
		<cfset variables.ebx.getInterface("pagecontext")._ebx_print(arguments.output)>
	</cffunction>
	
	<cffunction name="flush">
		<cfset variables.ebx.getInterface("pagecontext")._ebx_flush()>
	</cffunction>
	
	<cffunction name="clearBuffer">
		<cfset variables.ebx.getInterface("pagecontext")._ebx_clearBuffer()>
	</cffunction>
	
	<cffunction name="assign">
		<cfargument name="name" required="true" hint="the parameter to lookup">
		<cfargument name="value" required="false" hint="the default value for the parameter" default="">
		<cfargument name="overwrite" required="true" hint="the parameter to lookup" default="true">
		<cfargument name="append" required="true" hint="the parameter to lookup" default="false">
			<cfset variables.ebx.getInterface("pagecontext")._ebx_assign(arguments.name, arguments.value, arguments.overwrite, arguments.append)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="fetch">
		<cfargument name="name" required="true" hint="the parameter to lookup">
		<cfargument name="value" required="false" hint="the default value for the parameter" default="">
		<cfargument name="create" required="false" hint="create the parameter" default="true">
		
		<cfreturn variables.ebx.getInterface("pagecontext")._ebx_fetch(arguments.name, arguments.value, arguments.create)>
	</cffunction>
	
	<cffunction name="getLastOuput">
		<cfreturn variables.ebx.getInterface("pagecontext")._ebx_getOutput()>
	</cffunction>
	
	<cffunction name="getAllOutput">
		<cfreturn variables.ebx.getInterface("pagecontext")._ebx_getAllOutput()>
	</cffunction>
	
	
	<cffunction name="getPC">
		<cfreturn variables.ebx.getInterface("pagecontext")._ebx_getPageContext()>
	</cffunction>
	
	<cffunction name="assignOutput">
		<cfargument name="output"     required="true" type="string" default="false" hint="wheater to append contentvars output">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfif arguments.contentvar eq "">
			<cfset variables.ebx.getInterface("pagecontext")._ebx_print(arguments.output)>
			<!--- <cfset variables.ebx.getInterface("pagecontext")._ebx_clearBuffer()> --->
		<cfelse>
			<cfset setDebug("Assigning output to '#arguments.contentvar#' with append is #arguments.append#: #arguments.output#", 0)>
			<cfset assign(arguments.contentvar, arguments.output, false, arguments.append)>
		</cfif>
	</cffunction>
	
	<!--- Request related --->
	<cffunction name="createRequest">
		<cfargument name="action"     required="true"  type="string">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#">
		<cfargument name="flush"      required="false" type="boolean" default="true">
		<cfargument name="contentvar" required="false" type="string"  default="">
		<cfargument name="append"     required="false" type="boolean" default="false">
		
		<cfset var local = StructNew()>
		<cfset local.request = createObject("component", "ebxRequest").init(variables.ebx, arguments.action, arguments.params, arguments.flush, arguments.contentvar, arguments.append)>
		<cfif local.request.isExecutable()>
			<cfset addRequest(local.request)>
			<cfset setLastCreatedRequest(local.request)>
			<cfreturn true>
		</cfif>
		<cfset setDebug("Unable to create request for: '#arguments.action#'", 0)>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="addRequest">
		<cfargument name="request" required="true" type="any">
		<cfset getInterface("reqhandler").addRequest(arguments.request)>
		<!--- <cfset setLastCreatedRequest(arguments.request)> --->
		<!--- <cfset setCurrentRequest(arguments.request)> --->
	</cffunction>
	

	<cffunction name="validateRequest">
		<cfargument name="request" required="true" type="any">
		<cfreturn arguments.request.isExecutable()>
	</cffunction>
	
	<!--- <cffunction name="setCurrentRequest">
		<cfargument name="request" required="true" type="any">
		<cfset variables.ebx.setCurrentRequest(arguments.request)>
	</cffunction> --->
	
	<cffunction name="isMainRequest">
		<cfreturn getInterface("reqhandler").isMainRequest()>
	</cffunction>
	
	<cffunction name="setMainAction">
		<cfargument name="act" required="true" default="">
		<cfif arguments.act eq "">
			<cfset arguments.act = getParameter("defaultact")>
		</cfif>
		<cfset updateGlobalParameter(getParameter("actionvar"), arguments.act, true)>
	</cffunction>
	
	<cffunction name="hasMainAction">
		<cfreturn getParameter(getParameter("actionvar")) neq "">
	</cffunction>
	
	<cffunction name="getMainAction">
		<cfreturn getParameter(getParameter("actionvar"))>
	</cffunction>
	
	<cffunction name="getCurrentRequest">
		<cfreturn getInterface("reqhandler").getCurrentRequest()>
	</cffunction>
	
	<cffunction name="hasRequests">
		<cfreturn getInterface("reqhandler").hasRequests()>
	</cffunction>
	
	<cffunction name="getCircuit" hint="get the path to the circuit">
		<cfargument name="circuit" required="true" type="string" hint="the circuit to lookup">
		<cfif hasCircuit(arguments.circuit)>
			<cfreturn variables.ebx.circuits[arguments.circuit]>
		<cfelse>
			<cfset variables.ebx.setError("Circuit not found: #arguments.circuit#")>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="hasCircuit" hint="check if circuit exists">
		<cfargument name="circuit" required="true" type="string" hint="the circuit to lookup">
		<cfreturn StructKeyExists(variables.ebx.circuits, arguments.circuit)>
	</cffunction>

	<cffunction name="parseSettings">
		<cfset var result = include(template=getParameterFile("files.settings"))>
		<cfif NOT result.error>
			<cfset setDebug("Settings parsed...")>
			<cfreturn true>
		</cfif>
		<cfreturn false>		
	</cffunction>
	
	<cffunction name="parseCircuits">
		<cfset var result = include(template=getParameterFile("files.circuits"))>
		<cfif NOT result.error>
			<cfset setDebug("Circuits parsed...")>
			<cfset variables.ebx.syncParameters("circuits")>
			<cfif NOT StructIsEmpty(getParameter("circuits"))>
				<cfreturn true>
			</cfif>
			<cfset setError("No circuits defined!")>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	
	<cffunction name="parsePlugins">
		<cfset var result = include(template=getParameterFile("files.plugins"))>
		<cfif NOT result.error>
			<cfset setDebug("Plugins parsed...")>
			<cfset variables.ebx.syncParameters("plugins")>
			<cfset variables.ebx.syncParameters("prePlugins")>
			<cfset variables.ebx.syncParameters("postPlugins")>
			<cfif NOT StructIsEmpty(getParameter("plugins"))>
				<cfreturn true>
			</cfif>
			<cfset setDebug("Warning no plugins defined!")>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="parseLayouts">
		<cfset var result = include(template=getParameterFile("files.layouts"))>
		<cfif NOT result.error>
			<cfset setDebug("Layouts parsed...")>
			<cfif NOT StructIsEmpty(getParameter("layouts"))>
				<cfreturn true>
			</cfif>
			<cfset setDebug("Warning no layouts defined!")>
		</cfif>
		<cfreturn false>
	</cffunction>
		
	<cffunction name="parseRequest">
		<cfargument name="request" required="true">
		<cfset var result = include(template=getSwitchFile(), flush="false")>
		<cfif NOT result.error>
			<cfset arguments.request.setOutput(getSwitchFile() & result.output)>
			<cfreturn true>
		<cfelse>
			<cfset arguments.request.setOutput(result.output)>
		</cfif>
		<cfreturn false>		
	</cffunction>

	<cffunction name="parseLayout">
		<cfset var local = StructNew()>
		<cfset local.inc = getAppPath() & getLayoutDir() & getLayoutFile()>
		<cfif include(template=local.inc, flush=false)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="parsePlugin">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getFormParameters">
		<cfreturn getInterface("parameters").getFormParameters()>
	</cffunction>
	
	<cffunction name="getURLParameters">
		<cfreturn getInterface("parameters").getURLParameters()>
	</cffunction>
	
	<cffunction name="copyURLParameters">
		<cfset getInterface("parameters").copyParameters(getURLParameters())>
	</cffunction>
	
	<cffunction name="copyFormParameters">
		<cfset getInterface("parameters").copyParameters(getFormParameters())>
	</cffunction>
	
	<cffunction name="getParameterFile">
		<cfargument name="paramfile" type="string">
		<cfreturn getAppPath() & getParameter(arguments.paramfile)>
	</cffunction>
	
	<cffunction name="getIncudeFile">
		<cfargument name="template" type="string">
		<cfreturn getCircuitDir() & arguments.template>
	</cffunction>
	
	<cffunction name="getSwitchFile">
		<cfreturn getIncudeFile(getParameter("files.exec"))>
	</cffunction>
	
	<cffunction name="getParameter">
		<cfargument name="param" type="string">
		<cfargument name="default" type="any" required="false" default="">
		<cfreturn getInterface("parameters").getParameter(arguments.param, arguments.default)>
	</cffunction>
	
	<cffunction name="setParameter">
		<cfargument name="param" type="string">
		<cfargument name="value" type="any">
		<cfargument name="overwrite" type="boolean" default="true">
		<cfreturn getInterface("parameters").setParameter(arguments.param, arguments.value, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="hasParameter">
		<cfargument name="param" type="string">
		<cfreturn getInterface("parameters").hasParameter(arguments.param)>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn getInterface("parameters").getParameters()>
	</cffunction>
	
	<!--- attributes --->
	<cffunction name="getAttributes">
		<cfreturn fetch("attributes", StructNew())>
	</cffunction>
	
	<cffunction name="getAttribute">
		<cfargument name="name" required="true" hint="the parameter to lookup">
		<cfargument name="value" required="false" hint="the default value for the parameter" default="">
		<cfset var local = StructNew()>
		<cfif hasAttribute(arguments.name)>
			<cfset local.attr = getAttributes()>
			<cfreturn local.attr[arguments.name]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="setAttributes">
		<cfargument name="source" required="true" hint="the parameter to lookup">
		<cfargument name="overwrite" required="true" hint="the parameter to lookup" default="true">
		<cfargument name="append" required="true" hint="the parameter to lookup" default="false">
		<cfset var local = StructNew()>
		
		<cfloop collection="#arguments.source#" item="local.i">
			<cfset setAttribute(local.i, arguments.source[local.i], arguments.overwrite, arguments.append)>
		</cfloop>
	</cffunction>
	
	<cffunction name="setAttribute">
		<cfargument name="name" required="true" hint="the parameter to lookup">
		<cfargument name="value" required="false" hint="the default value for the parameter" default="">
		<cfargument name="overwrite" required="true" hint="the parameter to lookup" default="true">
		<cfargument name="append" required="true" hint="the parameter to lookup" default="false">
		<cfset assign("attributes.#arguments.name#", arguments.value, arguments.overwrite, arguments.append)>
	</cffunction>
	
	<cffunction name="hasAttribute">
		<cfargument name="name" required="true" hint="the parameter to lookup">
		<cfreturn StructKeyExists(getAttributes(), arguments.name)>
	</cffunction>
	
	<!--- Debugging and errors --->
	<cffunction name="setDebug" hint="adds message to debugsink">
		<cfargument name="message" required="true">
		<cfargument name="level"   required="false" type="numeric" default="0">
		
		<cfset var local = StructNew()>
		<cfset local.ifdebug = getCoreInterface("debug")>
		<cfset local.ifdebug.setDebug(arguments.message, arguments.level)>
	</cffunction>
	
	<cffunction name="setError" hint="adds message to errorsink">
		<cfargument name="message" required="true">
		
		<cfset var local = StructNew()>
		<cfset setDebug(arguments.message, 1)>
		
		<cfset local.ifdebug = getInterface("debug")>
		<cfset local.ifdebug.setError(arguments.message)>
	</cffunction>
	
	<cffunction name="getErrors" hint="get the error sink">
		<cfset var local = StructNew()>
		<cfset local.ifdebug = getInterface("debug")>
		<cfreturn local.ifdebug.getErrors()>
	</cffunction>
	
	<cffunction name="hasError" hint="returns number of errors in sink">
		<cfset var local = StructNew()>
		<cfset local.ifdebug = getInterface("debug")>
		<cfreturn local.ifdebug.hasError()>
	</cffunction>
	
	<cffunction name="getDebug" hint="get all messages from debugsink">
		<cfset var local = StructNew()>
		<cfset local.ifdebug = getInterface("debug")>
		<cfreturn local.ifdebug.getDebug()>
	</cffunction>
	
	<cffunction name="caughtMessage" hint="format cfcatch message">
		<cfargument name="caught" required="true">
		<cftry>
			<cfreturn "#arguments.caught.tagname#: #arguments.caught.template# at line #arguments.caught.line# #arguments.caught.message# - #arguments.caught.detail#">
			<cfcatch type="any">
				<cfreturn "Error parsing catch">
			</cfcatch>
		</cftry>
	</cffunction>
	
</cfcomponent>