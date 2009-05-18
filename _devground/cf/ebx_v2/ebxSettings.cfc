<cfcomponent displayname="ebxSettings" hint="I set the global properties for the ebx">
	<!--- Constants --->
	<cfset variables.MAXREQUESTS = 10>
	
	<!--- Private vars --->
	<cfset variables.actionvar   = "">
	<cfset variables.defaultact  = "">
	<cfset variables.initialised = FALSE>
	
	<!--- Annotation --->
	<cfset this.VERSION = "2.0">
	<cfset this.AUTHOR = "Bharat Deepak Bhikharie - Leiden 2009">
	<cfset this.DESCRIPTION = "This component is designed to mimic fusebox5 functionality in a non-fusebox environment.">
	
	<!--- Request vars as used in version 1.0 --->
	<cfset this.appPath     = "">
	<cfset this.circuits    = StructNew()>
	<cfset this.plugins     = StructNew()>
	<cfset this.layouts     = StructNew()>
	<cfset this.prePlugins  = ArrayNew(1)>
	<cfset this.postPlugins = ArrayNew(1)>
	
	<cfset this.thisRequest     = "">
	<cfset this.thisCircuit     = "">
	<cfset this.thisAction      = "">
	<cfset this.act             = "">
	<cfset this.circuitdir      = "">
	<cfset this.rootpath        = "">
	<cfset this.execdir         = "">
	<!--- <cfset this.parameters      = StructNew()> --->
	<cfset this.layout          = "">
	<cfset this.layoutdir       = "">
	<cfset this.layoutfile      = "">
	<cfset this.includelayout   = "">
	
	<!--- Basic error notification --->
	<cfset this.fatalError = FALSE>
	<cfset this.fatalErrorException = "">
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMaxRequests" access="package">
		<cfreturn variables.MAXREQUESTS>
	</cffunction>
	
	<cffunction name="getAppPath">
		<cfreturn this.appPath>
	</cffunction>
	
	<cffunction name="setAppPath" access="public">
		<cfargument name="appPath" required="true"  type="string" default="" hint="coldfusion mapping to the root of the box">
		<cfset this.appPath = arguments.appPath>
	</cffunction>
	
	<cffunction name="setActionVar" access="public">
		<cfargument name="actionvar" required="true"  type="string" default="" hint="name of the attributes variable that will hold the action to execute">
		<cfset variables.actionvar = arguments.actionvar>
	</cffunction>
	
	<cffunction name="getActionVar" access="public">
		<cfreturn variables.actionvar>
	</cffunction>
	
	<cffunction name="setDefaultAct" access="public">
		<cfargument name="defaultact" required="true"  type="string" default="" hint="name of the action to execute if none is specified">
		<cfset variables.defaultact = arguments.defaultact>
	</cffunction>
	
	<cffunction name="getDefaultAct" access="public">
		<cfreturn variables.defaultact>
	</cffunction>
	
	<cffunction name="setOriginalRequest" access="package">
		<cfargument name="request" hint="the current request">
		
		<cfset this.originalRequest     = arguments.request>
		<cfset this.originalCircuit     = arguments.request.getCircuit()>
		<cfset this.originalAction      = arguments.request.getAction()>
		<cfset this.originalAct         = arguments.request.getAct()>
		<cfset this.originalCircuitdir  = arguments.request.getCircuitDir()>
		<cfset this.originalRootpath    = arguments.request.getRootPath()>
		<cfset this.originalParameters  = arguments.request.getParameters()>
		
		<cfset this.originalExecdir     = getAppPath() & this.originalCircuitdir>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setCurrentRequest" access="package">
		<cfargument name="request" hint="the current request">
		
		<cfset this.thisRequest     = arguments.request>
		<cfset this.thisCircuit     = arguments.request.getCircuit()>
		<cfset this.thisAction      = arguments.request.getAction()>
		<cfset this.act             = arguments.request.getAct()>
		<cfset this.circuitdir      = arguments.request.getCircuitDir()>
		<cfset this.rootpath        = arguments.request.getRootPath()>
		<cfset this.parameters      = arguments.request.getParameters()>
		
		<cfset this.execdir         = getAppPath() & this.circuitdir>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setCurrentLayout" access="package">
		<cfargument name="layout" hint="the current request">
		
		<cfset this.layoutdir       = "">
		<cfset this.layoutfile      = "">
		<cfset this.layout          = "">
		<cfset this.includelayout   = "">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="hasFatalError">
		<cfreturn this.fatalError>
	</cffunction>
	
	<cffunction name="setFatalError" hint="adds the fatal cfcatch">
		<cfargument name="fatalError" type="any" required="true">
		<cfset this.fatalError = TRUE>
		<cfset this.fatalErrorException = arguments.fatalError>
		<cfreturn false>
	</cffunction>
</cfcomponent>