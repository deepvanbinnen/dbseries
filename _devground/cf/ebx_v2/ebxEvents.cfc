<cfcomponent displayname="ebxEvents" hint="I handle ebxEvents">
	<cfset variables.pi = "">
	
	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
			<cfset variables.pi     = arguments.ParserInterface>
			
			<cfset variables.parser = variables.pi.getParser()>
			<cfset variables.stack  = variables.pi.getStackInterface()>
			<cfset variables.page   = variables.pi.getEbxPageContext()>
			
			<cfset variables.ebx    = variables.parser.getEbx()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="OnAppendStack">
		<cfreturn variables.pi.appendStack()>
	</cffunction>
	
	<cffunction name="OnAssignOutput">
		<cfif variables.pi.getContextVar() neq "">
			<cfset variables.pi.assignVariable(variables.pi.getContextVar(), variables.pi.getContextOutput(), variables.pi.getContextAppend())>
		<cfelse>
			<cfif variables.pi.isMainContextRequest()>
				<cfset variables.pi.setLayout(variables.pi.getContextOutput())>
			<cfelse>
				<cfset variables.pi.flushOutput(variables.pi.getContextOutput())>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnUpdateStack">
		<cfreturn variables.pi.updateStack()>
	</cffunction>
	
	<cffunction name="OnBoxAppInit" hint="Call on application init">
		<cfargument name="ebx" required="false">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxInit" hint="Initialise Parser">
		<cfset var local = StructNew()>
		
		<cfset local.scopes = variables.pi.getProperty("scopecopy")>
		<cfloop list="#local.scopes#" index="local.scope">
			<cfset variables.pi.updateAttributes(variables.pi.getVar(local.scope, StructNew()))>
		</cfloop>
		<cfset OnParseSettings()>
		<cfreturn true>		
	</cffunction>
	
	<cffunction name="OnBoxPreprocess" hint="preprocess request, set original action">
		<cfreturn OnInclude(variables.pi.getSettingsFile())>
	</cffunction>
	
	<cffunction name="OnCreateContext" hint="create a context">
		<cfargument name="type"       required="true"   type="string"  hint="the contexttype (request|include|mainrequest|empty)">
		<cfargument name="attributes" required="false"  type="struct"  default="#StructNew()#" hint="custom attributes">
		<cfargument name="contentvar" required="false"  type="string"  default=""              hint="variable to use for output">
		<cfargument name="append"     required="false"  type="boolean" default="false"         hint="append the contentvar">
		<cfargument name="template"   required="false"  type="string"  default=""              hint="full mapping-path to template">
		<cfargument name="action"     required="false"  type="string"  default=""              hint="action">
		<cfargument name="parse"      required="false"  type="boolean" default="true"          hint="depending on type, parse action or result for an template immediately">
		
		<cfif NOT variables.pi.maxRequestsReached()>
			<cfset variables.pi.setThisContext(variables.pi.createContext(argumentCollection = arguments))>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnExecuteContext" hint="create a context">
		<cfset var ctx = variables.pi.getCurrentContext()>
		<cfset variables.pi.updateAttributes(ctx.getAttributes())>
		<cfset ctx.setResult(variables.pi.include(ctx.getTemplate()))>
		<cfset variables.pi.updateAttributes(ctx.getOriginals())>
		<cfreturn NOT ctx.hasErrors()>
	</cffunction>
	
	<cffunction name="OnExecuteDo" hint="create a context">
		<cfif OnCreateContext(argumentCollection=arguments)>
			<cfif OnParseRequest()>
				<cfreturn OnExecuteStackContext()>
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnExecuteInclude" hint="create a context">
		<cfif OnCreateContext(argumentCollection=arguments)>
			<cfreturn OnExecuteStackContext()>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnExecuteMainRequest" hint="create a context">
		<cfif OnCreateContext(type="mainrequest", action=variables.pi.getMainAction(), parse=true)>
			<cfif OnParseRequest()>
				<cfset OnAppendStack()>
				<cfset OnExecuteContext()>
				<cfset OnAssignOutput()>
				<cfset OnUpdateStack()>
				<cfset OnLayout()>
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>

	<cffunction name="OnExecuteStackContext" hint="create a context">
		<cfset OnAppendStack()>
		<cfset OnExecuteContext()>
		<cfset OnAssignOutput()>
		<cfset OnUpdateStack()>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnLayout" hint="create a context">
		<cfset variables.pi.flushOutput(variables.pi.getProperty("layout"))>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnParseRequest" hint="create a context">
		<cfif variables.pi.contextIsExecutable()>
			<cfset variables.pi.updateParser()>
			<cfset variables.pi.setContextTemplate(variables.pi.getSwitchFile())>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnParseLayouts" hint="create a context">
		<cfif NOT variables.pi.getProperty("nolayout")>
			<cfreturn OnExecuteInclude(type="include", template=variables.pi.getLayoutsFile())>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnParseSettings" hint="create a context">
		<cfif NOT variables.pi.getProperty("nosettings")>
			<cfreturn OnExecuteInclude(type="include", template=variables.pi.getSettingsFile())>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	
	<cffunction name="OnBoxPreAction" hint="returns number of errors in sink">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxMainRequest" hint="get all messages from debugsink">
		<cfreturn true>
	</cffunction>

	<cffunction name="OnBoxPostAction" hint="get all messages from debugsink">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxPostprocess" hint="get all messages from debugsink">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxPlugin" hint="get all messages from debugsink">
		<cfreturn true>
	</cffunction>
</cfcomponent>