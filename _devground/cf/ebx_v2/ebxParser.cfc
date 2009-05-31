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
	
	<cfset this.prePlugins          = ArrayNew(1)>
	<cfset this.postPlugins         = ArrayNew(1)>
	
	<cffunction name="init">
		<cfargument name="ebx"        required="true"  type="ebx" hint="eBox instance">
		<cfargument name="attributes" required="false" type="struct"  default="#StructNew()#" hint="attributes to use in the parser">
		<cfargument name="scopecopy"  required="false" type="string"  default="url,form"      hint="list of scopes to copy to attributes">
		<cfargument name="nosettings" required="false" type="boolean" default="false"         hint="do not parse settingsfile">
		<cfargument name="nolayout"   required="false" type="boolean" default="false"         hint="do not parse layout">
		
			<cfset var local = StructNew()>
			<cfset variables.ebx = arguments.ebx>
			
			<cfset variables.pi  = createObject("component", "ebxParserInterface").init(this)>
			<cfset variables.pi.setAttributes(arguments.attributes)>
			
			<cfset setProperty("scopecopy", arguments.scopecopy, true)>
			<cfset setProperty("nosettings", arguments.nosettings, true)>
			<cfset setProperty("nolayout", arguments.nolayout, true)>
			<cfset setProperty("stack", variables.pi.getStackInterface(), true)>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="do">
		<cfargument name="action"     required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		<cfreturn variables.pi.executeDo(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="execute">
		<!--- <cfargument name="attributes" required="false" type="struct"  default="#getProperty('attributes', StructNew())#" hint="attributes to use in the parser">
		<cfargument name="scopecopy"  required="false" type="string"  default="#getProperty('scopecopy', 'url,form')#"   hint="list of scopes to copy to attributes">
		<cfargument name="nosettings" required="false" type="boolean" default="#getProperty('nosettings', false)#"       hint="do not parse settingsfile">
		<cfargument name="nolayout"   required="false" type="boolean" default="#getProperty('nolayout', false)#"         hint="do not parse layout">
		
		<cfset setProperties(arguments)> --->
		<cfreturn variables.pi.executeMainRequest()>
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
		<cfset variables.pi.executeInitialise()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="include">
		<cfargument name="template"   required="true" type="string">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		<cfreturn variables.pi.executeInclude(argumentCollection=arguments)>
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