<cfcomponent extends="PropertyInterface" output="false" displayname="ebxRequestHandler" hint="I am ebx and designed to function as a IO-bus for a request. I am highly inspired by Fusebox3 and Fusebox5.5">
	<!--- global flag --->
	<cfset variables.initialised = FALSE>
	<!--- declare parameters --->
	<cfset variables.parameters       = createObject("component", "ebxParameters").init(this)>
	<!--- Used when action has 3 dots
	Define a map of "internal circuit" to "public parser variable" (e.g request.ebx.appPath,..) 
	that contain the current execution directory.
	--->
	<cfset variables.internal = StructNew()>
	<cfset variables.internal.settings = "configdir">
	<cfset variables.internal.layouts  = "configdir">
	<cfset variables.internal.plugins  = "configdir">
	
	<cfset variables.internal.include  = "circuitdir">
	<cfset variables.internal.layout   = "layoutdir">
	
	<cffunction name="init">
		<cfargument name="appPath"      required="true"  type="string"  default="" hint="coldfusion mapping to the root of the box">
		<cfargument name="defaultact"   required="false" type="string"  default="" hint="default action to excute if non is specified">
		<cfargument name="actionvar"    required="false" type="string"  default="act" hint="variable name that has the main action to execute">
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
		
			<cfset setParameters(arguments, true)>
			<!--- If you have an 'old' version of ebx, you should call setup from the requesting page 
			to finalise the setup --->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAppPath">
		<cfreturn getProperty("appPath")>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfargument name="circuit" required="true">
		<cfreturn getCircuit(arguments.circuit)>
	</cffunction>
	
	<cffunction name="getCircuit">
		<cfargument name="circuit" required="true">
		<cfset var local = StructNew()>
		
		<cfif hasCircuit(arguments.circuit)>
			<cfset local.circuits = getCircuits()>
			<cfreturn local.circuits[arguments.circuit]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getCircuits">
		<cfreturn getParameter("circuits", StructNew())>
	</cffunction>
	
	<cffunction name="getInternal" returntype="string">
		<cfargument name="internal" type="string" required="true">
		<cfif hasInternal(arguments.internal)>
			<cfreturn variables.internal[arguments.internal]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="hasInternal" returntype="string">
		<cfargument name="internal" type="string" required="true">
		<cfreturn StructKeyExists(variables.internal, arguments.internal)>
	</cffunction>
	
	<cffunction name="getParameter">
		<cfargument name="name" required="true">
		<cfargument name="default" required="true" default="">
		<cfreturn variables.parameters.getParameter(arguments.name, arguments.default)>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn variables.parameters.getParameters()>
	</cffunction>
	
	<cffunction name="getParser">
		<cfargument name="attributes" required="false" type="struct"  default="#StructNew()#" hint="attributes to use in the parser">
		<cfargument name="scopecopy"  required="false" type="string"  default="url,form"      hint="list of scopes to copy to attributes">
		<cfargument name="nosettings" required="false" type="boolean" default="false"         hint="do not parse settingsfile">
		<cfargument name="nolayout"   required="false" type="boolean" default="false"         hint="do not parse layout">
		
		<cfreturn createObject("component", "ebxParser").init(this, arguments.attributes, arguments.scopecopy, arguments.nosettings, arguments.nolayout)>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" required="true" type="string">
		<cfreturn StructKeyExists(getParameter("circuits"), arguments.name)>
	</cffunction>
	
	<cffunction name="setAppPath" access="public">
		<cfargument name="appPath" required="true"  type="string" default="" hint="coldfusion mapping to the root of the box">
		<cfset this.appPath = arguments.appPath>
	</cffunction>
	
	<cffunction name="setParameter">
		<cfargument name="name"      required="true">
		<cfargument name="value"     required="true" default="">
		<cfargument name="overwrite" required="true" default="false">
		<cfset variables.parameters.setParameter(arguments.name, arguments.value, arguments.overwrite)>
		<cfset setProperty(arguments.name, arguments.value, true, arguments.overwrite)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setParameters">
		<cfargument name="parameters" required="true">
		<cfargument name="overwrite"  required="true" default="false">
		
		<cfset variables.parameters.setParameters(arguments.parameters, arguments.overwrite)>
		<cfset setProperties(arguments.parameters, true, arguments.overwrite)>
		
	</cffunction>
	
	<cffunction name="setup">
		<cfargument name="parsecircuitfile" required="false" type="boolean" default="true" hint="parse circuitsfile?">
		<cfargument name="parsepluginsfile" required="false" type="boolean" default="true" hint="parse pluginsfile?">
		
		<cfset var result = StructNew()>
		<cfset result.pagecontext = createObject("component", "ebxPageContext")>
		
		<cfif arguments.parsecircuitfile>
			<cfset result.output = result.pagecontext.ebx_include(getAppPath() & getParameter("circuitsfile"))>
			<cfif NOT result.output.errors>
				<cfset setParameter("circuits", this.circuits, true)>
			</cfif>
		</cfif>
		
		<cfif arguments.parsepluginsfile>
			<cfset result.output = result.pagecontext.ebx_include(getAppPath() & getParameter("pluginsfile"))>
			<cfif NOT result.output.errors>
				<cfset setParameter("plugins", this.plugins, true)>
			</cfif>
		</cfif>
		
		<cfset this.state = "ready">
	</cffunction>
	
</cfcomponent>