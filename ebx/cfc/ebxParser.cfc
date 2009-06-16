<cfcomponent extends="PropertyInterface">
	<cfset variables.ebx = "">
	<cfset variables.pi  = "">
	<cfset variables.initialised  = false>
	
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
	
	<cfset this.layout     = "">
	<cfset this.layoutdir  = "">
	<cfset this.layoutfile = "">
	<cfset this.layoutpath = "">
	
	<cfset this.configdir  = "">
		
	<cffunction name="init" returntype="ebxParser" hint="initialise parser">
		<cfargument name="ebx"        required="true"  type="ebx" hint="eBox instance">
		<cfargument name="attributes" required="false" type="struct"  default="#StructNew()#" hint="attributes to use in the parser">
		<cfargument name="scopecopy"  required="false" type="string"  default="url,form"      hint="list of scopes to copy to attributes">
		<cfargument name="nosettings" required="false" type="boolean" default="false"         hint="do not parse settingsfile">
		<cfargument name="nolayout"   required="false" type="boolean" default="false"         hint="do not parse layout">
		
			<cfset var local = StructNew()>
			
			<cfset variables.ebx = arguments.ebx>
			<cfset variables.pi  = createObject("component", "ebxParserInterface").init(this, arguments.attributes)>
			<!--- <cfset variables.evt = variables.pi.getEventInterface()> --->
			<cfset setExecParameters(arguments.scopecopy, arguments.nosettings, arguments.nolayout)>
		<cfreturn this>
	</cffunction>

	<!--- EXECUTION METHODS --->
	<cffunction name="do" returntype="boolean" hint="Include context-template and set the context-result. Return true on successfull execution">
		<cfargument name="action"     required="true"  type="string" hint="the full qualified action">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="append contentvar value or overwrite">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="template"   required="false" type="string"  default="#getParameter('switchfile')#" hint="context template">
		<cfargument name="type"       required="false" type="string"  default="request" hint="context type">
		
		<cfset var local = StructNew()>
		<cfif NOT variables.pi.maxRequestsReached()>
			<!--- convert named arguments to params --->
			<cfset _setParamsFromArgs(arguments, "action,contentvar,append,template,type")>
			<cfif getContext(argumentCollection=arguments)>
				<cfset executeContext()>
				<cfset postContext()>
				<cfreturn true>
			<cfelse>
				<!--- Throw context parse error --->
				<p>Error on: #arguments.action#</p>
			</cfif>
		<cfelse>
			<!--- Throw max reached error --->
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="include" returntype="boolean" hint="Create include-context and execute do. Return true on successfull execution">
		<cfargument name="template"   required="true" type="string" hint="context template">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="append contentvar value or overwrite">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		
		<cfset _setParamsFromArgs(arguments, "contentvar,append,template")>
		<cfset arguments.action = "internal.circuit.include">
		<cfset arguments.type   = "include">
		<!--- <cfreturn testRequest(argumentCollection=arguments)> --->
		<cfreturn do(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="execute" returntype="boolean" hint="Create main-context and execute it. Return true on successfull execution">
		<!--- Executes several stages(?) in order:
		- preprocess - parse settings file (happens only for maincontext)
		- prefuse - customise attributes (happens for all contexts) and execute prefuse-context (happens only for maincontext)
		- preplugin - get preplugins and execute them (happens only for maincontext)
		- context - include template and set result (happens for all contexts) 
		- postfuse
		- postplugin
		- postprocess
		 --->
		<cfset var local = StructNew()>
		<cfset local.req = StructNew()>
		<!--- FORM / URL conversion --->
		<cfloop list="form,url" index="local.scope">
			<cfset variables.pi.updateAttributes(variables.pi.getVar(local.scope, StructNew()))>
		</cfloop>
		<!--- Parse settingsfile --->
		<cfif parseSettings()>
			<!--- Execute main request --->
			<cfif executeMain()>
				<!--- Parse ebx_layouts --->
				<cfif parseLayouts()>
					<!--- Execute layout file --->
					<cfset executeLayout()>
				</cfif>
			</cfif>
		<cfelse>
		</cfif>
	</cffunction>
	
	<cffunction name="executeMain" returntype="boolean" hint="create main context and execute it. Return true on successfull execution. Setting layout is handled in executeContext??">
		<cfset var local = StructNew()>
		<cfset local.req.action   = variables.pi.getMainAction()>
		<cfset local.req.template = getParameter("switchfile")>
		<cfset local.req.type     = "mainrequest">
		
		<cfif getContext(argumentCollection=local.req)>
			<cfset variables.pi.updateParserFromContext("original")>
			<cfset executeContext()>
			<cfset postPlugins()>
			<cfset postContext()>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="executeLayout" returntype="boolean" hint="create layout context and execute it. Return true on successfull execution">
		<cfset var local = StructNew()>
		<cfset local.req.action   = "internal.pathto.layout">
		<cfset local.req.template = getProperty("layoutfile")>
		<cfset local.req.type     = "layout">
		<cfreturn do(argumentCollection=local.req)>
	</cffunction>
	
	<cffunction name="executePlugin" returntype="boolean" hint="create plugin context and execute it. Return true on successfull execution">
		<cfargument name="template"   required="true" type="string">
		<cfset var local = StructNew()>
		<cfset local.req.action   = "internal.pathto.plugins">
		<cfset local.req.template = arguments.template>
		<cfset local.req.type     = "plugin">
		
		<cfreturn do(argumentCollection=local.req)>
	</cffunction>
	
	<cffunction name="preContext" returntype="boolean" hint="prepend the stack with context, update the parser and customise attributes. Always return true.">
		<!--- <cfset variables.pi.addContextToStack()>
		<cfset variables.pi.updateParserFromContext()>
		<cfset variables.pi.setAttributesFromContext()> --->
		<cfreturn true>
	</cffunction>
	
	<cffunction name="postContext" returntype="boolean" hint="remove context from stack, update the parser and restore attributes. Always return true.">
		<cfset variables.pi.restoreContextAttributes()>
		<cfset variables.pi.removeContextFromStack()> 
		<cfset variables.pi.updateParserFromContext()>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="executeContext" returntype="boolean" hint="include context-template and process context-result. Return true on successfull include.">
		<cfif variables.pi.executeContext()>
			<cfset variables.pi.handleContextOutput()>
			<cfreturn true>
		<cfelse>
			<cfdump var="#variables.pi.getCurrentContext()._dump()#">
			<cfdump var="#variables.pi.getCurrentContext().getCaught()#">
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="postPlugins" returntype="boolean" hint="loop parsers current postplugin property, validate against defined plugins and execute plugin. Return true on successfull execution.">
		<cfset var local = StructNew()>
		<cfset local.known_plugins = variables.ebx.getProperty('plugins')>
		<cfset local.plugins = getProperty('postPlugins')>
		<cfloop from="1" to="#ArrayLen(local.plugins)#" index="local.i">
			<cfif StructKeyExists(local.known_plugins, local.plugins[local.i])>
				<cfset executePlugin(local.known_plugins[local.plugins[local.i]])>
			</cfif>
		</cfloop>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="parseSettings" returntype="boolean" hint="create settings context and execute it. Return true on successfull execution">
		<cfset var local = StructNew()>
		<cfset local.req.action   = "internal.pathto.settings">
		<cfset local.req.template = getParameter("settingsfile")>
		<cfset local.req.type     = "include">
		
		<cfreturn do(argumentCollection=local.req)>
	</cffunction>
	
	<cffunction name="parseLayouts" returntype="boolean" hint="create layouts context and execute it. Return true on successfull execution">
		<cfset var local = StructNew()>
		<cfset local.req.action   = "internal.pathto.layouts">
		<cfset local.req.template = getParameter("layoutsfile")>
		<cfset local.req.type     = "include">
		
		<cfreturn do(argumentCollection=local.req)>
	</cffunction>
	
	<!--- GETTERS / SETTERS --->
	<cffunction name="getVar" returntype="any" hint="get variable value from pagecontext">
		<cfargument name="name"  type="string" required="true" hint="variable name">
		<cfargument name="value" type="any"    required="false" default="" hint="default value to return if variable does not exist">
		<cfreturn variables.pi.ebx_get(arguments.name, arguments.value)>
	</cffunction>
	
	<cffunction name="getEbx" returntype="ebx" hint="return composite ebx instance">
		<cfreturn variables.ebx>
	</cffunction>
	
	<cffunction name="getParameter" returntype="any" hint="get ebx parameter">
		<cfargument name="name"    type="string" required="true"  hint="parameter name">
		<cfargument name="default" type="any"    required="false" default="" hint="the default value to return if the parameter does not exist">
		<cfreturn variables.ebx.getParameter(arguments.name, arguments.default)>
	</cffunction>
	
	<cffunction name="getParameters" returntype="struct" hint="get all ebx parameters">
		<cfreturn variables.ebx.getParameters()>
	</cffunction>
	
	<cffunction name="getInterface" returntype="ebxParserInterface" hint="return parsers main controller instance">
		<cfreturn variables.pi>
	</cffunction>
	
	<cffunction name="getContext" returntype="boolean" hint="return true on succesfull creation from arguments">
		<cfargument name="type"       required="true" type="string" hint="context-type">
		<cfargument name="template"   required="true" type="string" hint="context-template">
		<cfargument name="action"     required="true" type="string" hint="context-action">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params for the context">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="content-variable to use for catching output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="append content-variable instead of overwrite">
		
		<cfreturn variables.pi.createContext(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="isOriginalAction" returntype="boolean" hint="return true if current action is original">
		<cfreturn this.originalAction neq "" AND this.originalAction eq this.thisAction>
	</cffunction>
	
	<cffunction name="setExecParameters" returntype="boolean" hint="initialise parser settings always return true">
		<cfargument name="scopecopy"  required="false" type="string"  default="url,form" hint="list of scopes to copy to attributes">
		<cfargument name="nosettings" required="false" type="boolean" default="false"    hint="do not parse settingsfile">
		<cfargument name="nolayout"   required="false" type="boolean" default="false"    hint="do not parse layout">
		
			<cfset setProperty("scopecopy", arguments.scopecopy, true)>
			<cfset setProperty("nosettings", arguments.nosettings, true)>
			<cfset setProperty("nolayout", arguments.nolayout, true)>
		
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="setLayout" returntype="boolean" hint="update parser's layout property. always return true">
		<cfargument name="output" type="string" required="true" hint="output to assign">
		<cfset setProperty("layout", arguments.output)>
		<cfreturn true>
	</cffunction>
	
	<!--- <cffunction name="setPhase">
		<cfargument name="phase">
		<cfset setProperty("phase", arguments.phase)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setState">
		<cfargument name="state">
		<cfset setProperty("state", arguments.state)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="hasLayoutPath">
		<cfreturn getProperty("layoutpath") neq "">
	</cffunction>
	
	<cffunction name="setLayoutPath">
		<cfset setProperty("layoutpath", getProperty("layoutdir") & getProperty("layoutfile"), true, true)>
		<cfreturn hasLayoutPath()>
	</cffunction>
	
	<cffunction name="getTicks">
		<cfreturn variables.pi.getTicks()>
	</cffunction>
	 --->
	
	<cffunction name="_setParamsFromArgs" returntype="ebxParser" hint="extract named arguments and set params from a call to 'do'">
		<cfargument name="argcollection" type="struct" required="true" hint="original argumentcollection">
		<cfargument name="excludekeys"   type="string" required="true" hint="keys to exclude">

		<cfset var local  = StructNew()>
		
		<cfif NOT StructKeyExists(arguments.argcollection, "params")>
			<cfset arguments.argcollection.params = StructNew()>
		</cfif>
		
		<cfloop collection="#arguments.argcollection#" item="local.key">
			<cfif local.key neq "params" AND NOT ListFindNoCase(arguments.excludekeys, local.key)>
				<!--- Insert named argument to parameter --->
				<cfset StructInsert(arguments.argcollection.params, local.key, arguments.argcollection[local.key])>
				<cfset StructDelete(arguments.argcollection, local.key)>
			</cfif>
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	
</cfcomponent>