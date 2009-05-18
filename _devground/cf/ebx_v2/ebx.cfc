<cfcomponent extends="ebxSettings" output="false" displayname="ebxRequestHandler" hint="I am a ebx-request-handler and handle an ebx-request">
	<cfset super.init()>
	<cfset variables.initialised = FALSE>
	<cfset variables.EXPOSED_PARAMS = "thisRequest,originalCircuit,originalAction,originalAct,thisCircuit,thisAction,act,circuitdir,rootpath,layout,layoutdir,layoutfile,includelayout,execdir">
	<cfset variables.STATIC_PARAMS  = "circuits,plugins,layouts,prePlugins,postPlugins">
	
	<cfset variables.ebx = StructNew()>
	<cfset variables.actionvar   = "act">
	<cfset variables.defaultact  = "home.tonen">
	<cfset variables.lastrequest = "">

	<!--- declare properties and interfaces --->
	<cfset variables.context    = "">
	<cfset variables.parameters = "">
	<cfset variables.settings   = "">
	<cfset variables.events     = "">
	
	<!--- declare interfaces --->
	<cfset variables.interfaces = StructNew()>
	
	<cfset this.state = "uninitialised">
	
	<cffunction name="init">
		<cfargument name="circuitsfile" required="false" type="string"  default="ebx_circuits.cfm" hint="maps to the file that contains circuit settings">
		<cfargument name="pluginsfile"  required="false" type="string"  default="ebx_plugins.cfm" hint="maps to the file that contains plugin settings">
		<cfargument name="layoutsfile"  required="false" type="string"  default="ebx_layouts.cfm" hint="maps to the file that contains layout settings">
		<cfargument name="settingsfile" required="false" type="string"  default="ebx_settings.cfm" hint="maps to the file that contains global settings">
		<cfargument name="switchfile"   required="false" type="string"  default="ebx_switch.cfm" hint="maps to the file that contains global settings">
		<cfargument name="circuits"     required="false" type="struct"  default="#StructNew()#"    hint="ebox circuits">
		<cfargument name="plugins"      required="false" type="struct"  default="#StructNew()#"    hint="ebox circuits">
		<cfargument name="layouts"      required="false" type="struct"  default="#StructNew()#"    hint="ebox circuits">
		<cfargument name="forms2attrib" required="false" type="boolean" default="true" hint="convert formvariables to attributes">
		<cfargument name="url2attrib"   required="false" type="boolean" default="true" hint="convert urlvariables to attributes">
		<cfargument name="precedence"   required="false" type="string"  default="form" hint="if form and url variables are converted to attributes, which takes precedence?">
		<cfargument name="debuglevel"   required="false" type="numeric" default="0" hint="error level for debugmessages">
		
			<!--- The context is the only place in which cfinclude occurs --->
			<cfset variables.interfaces.pagecontext = createObject("component", "ebxPageContext")>
			<cfset variables.interfaces.parameters  = createObject("component", "ebxParameters").init(this, arguments)>
			<cfset this.state = "initialised">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setup">
		<cfargument name="appPath"          required="true"  type="string"  default="" hint="coldfusion mapping to the root of the box">
		<cfargument name="defaultact"       required="false" type="string"  default="" hint="default action to excute if non is specified">
		<cfargument name="actionvar"        required="false" type="string"  default="act" hint="variable name that has the main action to execute">
		<cfargument name="parsecircuitfile" required="false" type="boolean" default="true" hint="parse circuitsfile?">
		<cfargument name="parsepluginsfile" required="false" type="boolean" default="true" hint="parse pluginsfile?">
		
		<cfset var result = StructNew()>
		<cfset result.parser = createObject("component", "ebxParser").init(this)>
		
		<cfset setAppPath(arguments.appPath)>
		
		<cfset variables.interfaces.parameters.setParameters(arguments)>
		<cfif arguments.parsecircuitfile>
			<cfset result.output = result.parser.include(getParameter("circuitsfile"))>
			<cfif NOT result.output.errors>
				<cfif IsStruct(this.circuits) AND NOT StructIsEmpty(this.circuits)>
					<cfset setParameter("circuits", this.circuits, true)>
				</cfif>
			</cfif>
		</cfif>
		
		<cfif arguments.parsepluginsfile>
			<cfset result.output = result.parser.include(getParameter("pluginsfile"))>
			<cfif NOT result.output.errors>
				<cfif IsStruct(this.plugins) AND NOT StructIsEmpty(this.plugins)>
					<cfset setParameter("plugins", this.plugins, true)>
				</cfif>
			</cfif>
		</cfif>
		
		<cfset this.state = "ready">
	</cffunction>
	
	<cffunction name="initialise">
		<cfargument name="scopecopylist"     required="false" type="string"  default="url,form" hint="list of scopes to copy to attributes">
		<cfargument name="parsesettingsfile" required="false" type="boolean" default="true"     hint="parse settingsfile?">
		
		<cfset var result = StructNew()>
		<cfset result.parser = createObject("component", "ebxParser").init(this)>
		<cfreturn result.parser.initialise(arguments.scopecopylist, arguments.parsesettingsfile)>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfargument name="name" required="true">
		<cfreturn variables.interfaces.parameters.getParameter("circuits")[arguments.name]>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" required="true" type="string">
		<cfreturn StructKeyExists(variables.interfaces.parameters.getParameter("circuits"), arguments.name)>
	</cffunction>
	
	<cffunction name="getParameter">
		<cfargument name="name" required="true">
		<cfargument name="default" required="true" default="">
		<cfreturn variables.interfaces.parameters.getParameter(arguments.name, arguments.default)>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn variables.interfaces.parameters.getParameters()>
	</cffunction>
	
	<cffunction name="setParameter">
		<cfargument name="name"      required="true">
		<cfargument name="value"     required="true" default="">
		<cfargument name="overwrite" required="true" default="false">
		<cfset variables.interfaces.parameters.setParameter(arguments.name, arguments.value, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="setParameters">
		<cfargument name="parameters" required="true">
		<cfargument name="overwrite"  required="true" default="false">
		<cfset variables.interfaces.parameters.setParameters(arguments.parameters, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="getErrors" hint="get the error sink">
		<cfreturn getInterface("core").getErrors()>
	</cffunction>
	
	<cffunction name="getDebug" hint="get messages from debugsink based on level">
		<cfargument name="level"    required="true" type="numeric" default="0">
		<cfargument name="asstring" required="false" type="boolean" default="false">
		
		<cfset var local = StructNew()>
		<cfset local.output = ArrayNew(1)>
		<cfset local.debug  = getInterface("core").getDebug()>
		
		<cfloop from="1" to="#ArrayLen(local.debug)#" index="local.i">
			<cfset local.lvl = local.debug[local.i].level>
			<cfif local.lvl GTE arguments.level>
				<cfset local.msg = local.debug[local.i].message>
				<cfif NOT IsSimpleValue(local.msg)>
					<cfset local.msg = local.msg.toString()>
				</cfif>
				<cfset ArrayAppend(local.output, local.lvl & ": " & local.msg)>
			</cfif>
		</cfloop>
		<cfif arguments.asstring>
			<cfreturn ArrayToList(local.output, "<br />")>
		<cfelse>
			<cfreturn local.output>
		</cfif>
	</cffunction>
	
	<cffunction name="setDebug">
		<cfargument name="message">
		<cfargument name="level" default="0">
		
		<!--- <cfset variables.core.setDebug(arguments.message, arguments.level)> --->
	</cffunction>

	<cffunction name="getInterface">
		<cfargument name="name" required="true" type="string" hint="the internal interface to return">
		<cfif StructKeyExists(variables.interfaces, arguments.name)>
			<cfreturn variables.interfaces[arguments.name]>
		</cfif>
		<cfreturn FALSE>
	</cffunction>
	
</cfcomponent>