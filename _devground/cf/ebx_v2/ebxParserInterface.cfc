<cfcomponent>
	<cfset variables.ebx            = "">
	<cfset variables.Parser         = "">
	<cfset variables.CurrentContext = "">
	
	<cfset variables.interfaces  = StructNew()>
	
	<cffunction name="init" returntype="ebxParserInterface">
		<cfargument name="ebxParser" type="ebxParser" required="true">
		
		<cfset variables.Parser = arguments.ebxParser>
		<cfset variables.ebx    = variables.Parser.getEbx()>
		
		<cfset createEventInterface()>
		<cfset createStackInterface()>
		<cfset createPageContext()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="assignOutput" hint="assign output (mostly from an executioncontext result) to content var or else flush it to the page">
		<cfargument name="output"     required="true" type="string" default="false" hint="wheater to append contentvars output">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var pc = getEbxPageContext()>
		<cfset var out = arguments.output>
		
		<cfif arguments.contentvar eq "">
			<cfset pc.ebx_write(out)>
		<cfelse>
			<cfif arguments.append>
				<cfset out = getVar(arguments.contentvar) & out>
			</cfif>
			<cfset pc.ebx_put(arguments.contentvar, out)>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="createContext" returntype="boolean" hint="create a executioncontext and on success set the default arguments">
		<cfargument name="attributes" required="false"  type="struct" default="#StructNew()#"  hint="the action to execute">
		<cfargument name="contentvar" required="false"  type="string" default=""  hint="the action to execute">
		<cfargument name="append"     required="false"  type="boolean" default="false"  hint="the action to execute">
		
		<cfif createExecutionContext()>
			<cfset variables.CurrentContext.setAttributes(arguments.attributes)>
			<cfset variables.CurrentContext.setContentVar(arguments.contentvar)>
			<cfset variables.CurrentContext.setAppend(arguments.append)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="createEventInterface" returntype="boolean" hint="create the eventinterface">
		<cfreturn createInterface("ebxEvents", true)>
	</cffunction>
	
	<cffunction name="createExecutionContext" returntype="boolean" hint="create a new empty context in the stack and set it to the current">
		<cfif NOT maxRequestsReached()>
			<cfset getStackInterface().add(createObject("component", "ebxExecutionContext").init(this))>
			<cfset setCurrentContext()>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="createInclude" returntype="boolean" hint="create a executioncontext for an include">
		<cfargument name="template"     required="true"  type="string"   hint="the action to execute">
		<cfargument name="attributes" required="false"  type="struct" default="#StructNew()#"  hint="the action to execute">
		<cfargument name="contentvar" required="false"  type="string" default=""  hint="the action to execute">
		<cfargument name="append"     required="false"  type="boolean" default="false"  hint="the action to execute">
		
		<cfif createContext(arguments.attributes, arguments.contentvar, arguments.append)>
			<cfset variables.CurrentContext.setTemplate(getFilePath(arguments.template))>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="createInterface" returntype="boolean" hint="create a interface">
		<cfargument name="name" type="any"     required="true">
		<cfargument name="init" type="boolean" required="false" default="true">
		
		<cfif NOT StructKeyExists(variables.interfaces, arguments.name)>
			<cfset StructInsert(variables.interfaces, arguments.name, createObject("component", arguments.name))>
			<cfif arguments.init>
				<cfset getInterface(arguments.name).init(this)>
			</cfif>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="createPageContext" returntype="boolean" hint="create the pagecontext">
		<cfreturn createInterface("ebxPageContext", false)>
	</cffunction>
	
	<cffunction name="createRequest" returntype="boolean"  hint="create a executioncontext for a request">
		<cfargument name="action"     required="true"  type="string"   hint="the action to execute">
		<cfargument name="attributes" required="false"  type="struct" default="#StructNew()#"  hint="the action to execute">
		<cfargument name="contentvar" required="false"  type="string" default=""  hint="the action to execute">
		<cfargument name="append"     required="false"  type="boolean" default="false"  hint="the action to execute">
		
		<cfset var local = StructNew()>
		
		<cfif createContext(arguments.attributes, arguments.contentvar, arguments.append)>
			<cfset variables.CurrentContext.setAction(arguments.action)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
		
	
	<cffunction name="createStackInterface" returntype="boolean" hint="create the stackinterface">
		<cfreturn createInterface("ebxExecutionStack", false)>
	</cffunction>
	
	<cffunction name="executeContext" returntype="boolean" hint="execute the context by including the (switch)file and assign its result variable. sets custom attributes and restores them afterwards.">
		<cfset updateAttributes(variables.CurrentContext.getAttributes())>
		<cfset variables.CurrentContext.execute()>
		<cfset updateAttributes(variables.CurrentContext.getOriginals())>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="executeDo" returntype="boolean" hint="create and execute a subrequest. may assign its output to custom appendable variable">
		<cfargument name="action"     required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfif createRequest(arguments.action, arguments.params, arguments.contentvar, arguments.append)>
			<cfif variables.CurrentContext.isExecutable()>
				<cfset updateParser(variables.CurrentContext.getRequest())>
				<cfset variables.CurrentContext.setTemplate(getSwitchFile())>
				<cfset executeContext()>
			</cfif>
			<cfset finaliseExecution()>
			<cfset updateParser(variables.CurrentContext.getRequest())>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="executeInclude" returntype="boolean" hint="include a template with custom attributes. may assign its output to custom appendable variable">
		<cfargument name="template"   required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfif createInclude(arguments.template, arguments.params, arguments.contentvar, arguments.append)>
			<cfset executeContext()>
			<cfset finaliseExecution()>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="executeInitialise" returntype="boolean" hint="initialise parser / parse settings / convert formurl scopes to attributes">
		<cfset var evt = getEventInterface()>
		<cfreturn evt.OnBoxInit()>
	</cffunction>
	
	<cffunction name="executeMainRequest" returntype="boolean" hint="create the original request">
		<cfif createRequest(getMainAction())>
			<cfset updateParser(variables.CurrentContext.getRequest())>
			<cfset variables.Parser.setOriginalRequest(variables.CurrentContext.getRequest())>
			<cfset variables.CurrentContext.setTemplate(getSwitchFile())>
			<cfset executeContext()>
			<cfset assignOutput(variables.CurrentContext.getOutput())>
		</cfif>
	
		<cfreturn false>		
	</cffunction>
	
	<cffunction name="finaliseExecution" returntype="boolean" hint="assign contextresult output, cleanup from stack">
		<cfset assignOutput(variables.CurrentContext.getOutput(), variables.CurrentContext.getContentVar(), variables.CurrentContext.getAppend())>
		<cfset getStackInterface().remove()>
		<cfif getStackInterface().getLength()>
			<cfset setCurrentContext()>
		</cfif>
	</cffunction>

	<cffunction name="getAppPath">
		<cfreturn variables.ebx.getAppPath()>
	</cffunction>
	
	<cffunction name="getAttribute" returntype="any">
		<cfargument name="name"  type="string" required="true">
		<cfargument name="value" type="any"    required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfif hasAttribute(arguments.name, local.attr)>
			<cfreturn local.attr[arguments.name]>
		</cfif>
		
		<cfreturn arguments.value>
	</cffunction>
	
	<cffunction name="getAttributes" returntype="struct">
		<cfreturn getVar("attributes", StructNew())>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.getCircuitDir(arguments.name)>
	</cffunction>
	
	<cffunction name="getCurrentContext" returntype="ebxExecutionContext">
		<cfreturn variables.CurrentContext>
	</cffunction>
	
	<cffunction name="getEbxPageContext" returntype="ebxPageContext">
		<cfreturn getInterface("ebxPageContext")>
	</cffunction>
	
	<cffunction name="getEventInterface" returntype="ebxEvents">
		<cfreturn getInterface("ebxEvents")>
	</cffunction>
	
	<cffunction name="getFilePath">
		<cfargument name="name" type="string" required="true">
		<cfargument name="parseAppPath"  type="boolean" required="false" default="true">
		<cfargument name="parseCircPath" type="boolean" required="false" default="true">
		
		<cfif arguments.parseCircPath>
			<cfset arguments.name = variables.Parser.getProperty("circuitdir") & arguments.name>
		</cfif>
		<cfif arguments.parseAppPath>
			<cfset arguments.name = variables.Parser.getProperty("appath") & arguments.name>
		</cfif>
		<cfreturn arguments.name>
	</cffunction>
	
	<cffunction name="getInterface" returntype="any">
		<cfargument name="name" type="any" required="true">
		
		<cfif StructKeyExists(variables.interfaces, arguments.name)>
			<cfreturn variables.interfaces[arguments.name]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getLayout">
		<cfreturn getFilePath(variables.Parser.getProperty("layoutdir") & variables.Parser.getProperty("layoutfile"), true, false)>
	</cffunction>
	
	<cffunction name="getLayoutFile">
		<cfreturn getFilePath(getParameter("layoutsfile"), true, false)>
	</cffunction>
	
	<cffunction name="getMainAction">
		<cfreturn getAttribute(getParameter("actionvar"), getParameter("defaultact"))>
	</cffunction>
	
	<cffunction name="getParameter" returntype="any">
		<cfargument name="name"  type="string" required="true">
		<cfreturn variables.Parser.getParameter(arguments.name)>
	</cffunction>
	
	<cffunction name="getParser" returntype="ebxParser">
		<cfreturn variables.Parser>
	</cffunction>
	
	<cffunction name="getProperty" returntype="any">
		<cfargument name="key"     type="string" required="true">
		<cfargument name="default" type="any"    required="false" default="">
		<cfreturn variables.Parser.getProperty(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="getSettingsFile">
		<cfreturn getFilePath(getParameter("settingsfile"))>
	</cffunction>
	
	<cffunction name="getSwitchFile">
		<cfreturn getFilePath(getParameter("switchfile"))>
	</cffunction>
	
	
	<cffunction name="getStackInterface" returntype="ebxExecutionStack">
		<cfreturn getInterface("ebxExecutionStack")>
	</cffunction>
	
	<cffunction name="getVar" returntype="any">
		<cfargument name="name"  type="string" required="true">
		<cfargument name="value" type="any"    required="false" default="">
		<cfreturn getEbxPageContext().ebx_get(arguments.name, arguments.value)>
	</cffunction>
	
	<cffunction name="hasAttribute" returntype="any">
		<cfargument name="name"       type="string" required="true">
		<cfargument name="attributes" type="struct" required="false" default="#getAttributes()#">
		
		<cfreturn StructKeyExists(arguments.attributes, arguments.name)>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.hasCircuit(arguments.name)>
	</cffunction>
	
	<cffunction name="include" returntype="struct">
		<cfargument name="template"      type="string" required="true">
		<cfreturn getEbxPageContext().ebx_include(arguments.template)>
	</cffunction>
	
	
	<cffunction name="maxRequestsReached" returntype="boolean">
		<cfreturn getStackInterface().maxReached()>
	</cffunction>
	
	<cffunction name="setCurrentContext" returntype="ebxExecutionContext">
		<cfset variables.CurrentContext = getStackInterface().get()>
		<cfreturn getCurrentContext()>
	</cffunction>
	
	<cffunction name="releaseAttributes" returntype="boolean">
		<cfset var local = StructNew()>
		<cfif ArrayLen(variables.CustomAttr)>
			<cfset updateAttributes(variables.CustomAttr[1])>
			<cfset ArrayDeleteAt(variables.CustomAttr,1)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	
	
	<cffunction name="storeAttributes" returntype="boolean">
		<cfargument name="attributes" type="struct" required="false" default="#StructNew()#">
		<cfset ArrayPrepend(variables.CustomAttr, arguments.attributes)>
		<cfreturn true>
	</cffunction>
	
	
	
	
	<cffunction name="updateParser" returntype="boolean">
		<cfargument name="request" type="ebxRequest" required="true">
		
		<cfset variables.Parser.setCurrentRequest(arguments.request)>
		<cfset variables.Parser.setTargetRequest(arguments.request)>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="parseSettings" returntype="boolean">
		<cfreturn NOT variables.Parser.getProperty("nosettings")>
	</cffunction>
	
	<cffunction name="setAttributes" returntype="any">
		<cfargument name="attribs" type="struct" required="true">
		<cfreturn getEbxPageContext().ebx_put("attributes", arguments.attribs)>
	</cffunction>
	
	<cffunction name="updateAttributes" returntype="any">
		<cfargument name="attributes" type="struct" required="true" default="#StructNew()#">
		
		<cfset var local  = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfset StructAppend(local.attr, arguments.attributes, TRUE)>
		<cfreturn setAttributes(local.attr)>
	</cffunction>
</cfcomponent>