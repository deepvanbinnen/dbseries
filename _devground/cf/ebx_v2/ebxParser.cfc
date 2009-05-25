<cfcomponent extends="PropertyInterface">
	<cfset variables.ebx = "">
	<cfset variables.pi  = "">
	
	<cfset this.state = "UNINITIALISED">
	<cfset this.phase = "UNINITIALISED">
	
	<cfset this.originalAction      = "">
	<cfset this.originalCircuit     = "">
	<cfset this.originalAct         = "">
	<cfset this.originalCircuitdir  = "">
	<cfset this.originalRootpath    = "">
	<cfset this.originalExecdir     = "">
	
	<cfset this.targetAction        = "">
	<cfset this.targetCircuit       = "">
	<cfset this.targetAct           = "">
	<cfset this.targetCircuitdir    = "">
	<cfset this.targetRootpath      = "">
	<cfset this.targetExecdir       = "">
	
	<cfset this.thisAction          = "">
	<cfset this.thisCircuit         = "">
	<cfset this.act                 = "">
	<cfset this.circuitdir          = "">
	<cfset this.rootpath            = "">
	<cfset this.execdir             = "">
	
	<cffunction name="init">
		<cfargument name="ebx" type="ebx" required="true">
			<cfset var local = StructNew()>
			<cfset variables.ebx = arguments.ebx>
			<cfset variables.pi  = createObject("component", "ebxParserInterface").init(this)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="do">
		<cfargument name="action"     required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		<cfreturn variables.pi.executeDo(arguments)>
	</cffunction>

	<cffunction name="execute">
		<cfargument name="parselayoutsfile"  required="false" type="boolean" default="true" hint="parse layoutsfile?">
		<cfreturn variables.pi.executeMainRequest(arguments)>
	</cffunction>
	
	<cffunction name="getEbx">
		<cfreturn variables.ebx>
	</cffunction>
	
	<cffunction name="getParameter">
		<cfargument name="name" type="string" required="true">
		<cfargument name="default" required="true" default="">
		<cfreturn variables.ebx.getParameter(arguments.name, arguments.default)>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn variables.ebx.getParameters()>
	</cffunction>
	
	<cffunction name="initialise">
		<cfargument name="attributes"     required="false" type="struct"  default="#StructNew()#" hint="default attributes">
		<cfargument name="scopecopy"      required="false" type="string"  default="url,form" hint="list of scopes to copy to attributes">
		<cfargument name="parse_settings" required="false" type="boolean" default="true"     hint="parse settingsfile?">
		
		<cfreturn variables.pi.executeInitialise(arguments)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="include">
		<cfargument name="template"   required="true" type="string">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		<cfreturn variables.pi.executeInclude(arguments)>
	</cffunction>
	
	<cffunction name="setCurrentRequest">
		<cfargument name="request">
		<!--- <cfset this.thisRequest         = getRequest()> --->
		<cfset this.thisAction          = arguments.request.get("fullact")>
		<cfset this.thisCircuit         = arguments.request.get("circuit")>
		<cfset this.act                 = arguments.request.get("act")>
		<cfset this.circuitdir          = arguments.request.get("circuitdir")>
		<cfset this.rootpath            = arguments.request.get("rootpath")>
		<cfset this.execdir             = arguments.request.get("execdir")>
	</cffunction>
	
	<cffunction name="setOriginalRequest">
		<!--- <cfset this.originalRequest     = getOriginalRequest()> --->
		<cfargument name="request">	
		<cfset this.originalAction      = arguments.request.get("fullact")>
		<cfset this.originalCircuit     = arguments.request.get("circuit")>
		<cfset this.originalAct         = arguments.request.get("act")>
		<cfset this.originalCircuitdir  = arguments.request.get("circuitdir")>
		<cfset this.originalRootpath    = arguments.request.get("rootpath")>
		<cfset this.originalExecdir     = arguments.request.get("execdir")>
	</cffunction>
	
	<cffunction name="setTargetRequest">
		<cfargument name="request">	
		<!--- <cfset this.targetRequest       = arguments.request> --->
		<cfset this.targetAction        = arguments.request.get("fullact")>
		<cfset this.targetCircuit       = arguments.request.get("circuit")>
		<cfset this.targetAct           = arguments.request.get("act")>
		<cfset this.targetCircuitdir    = arguments.request.get("circuitdir")>
		<cfset this.targetRootpath      = arguments.request.get("rootpath")>
		<cfset this.targetExecdir       = arguments.request.get("execdir")>
	</cffunction>
	
</cfcomponent>