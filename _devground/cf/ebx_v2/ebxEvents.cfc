<cfcomponent displayname="ebxEvents" hint="I handle ebxEvents">
	<cfset variables.pc  = createObject("component", "ebxPageContext")>
	
	<cfset variables.errors = StructNew()>
	<cfset variables.errors.UNKNOWN_ERROR = "Unknown error!">
	<cfset variables.errors.NO_CIRCUITS   = "No circuits defined!">
	<cfset variables.errors.NO_REQUEST    = "No action to be executed!">
	
	<cffunction name="init">
		<cfargument name="parser" required="true">
			<cfset variables.parser = arguments.parser>
		<cfreturn this>
	</cffunction>	
	
	<cffunction name="OnBoxAppInit" hint="Call on application init">
		<cfargument name="ebx" required="false">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxInit" hint="Initialize eBox">
		<cfargument name="attributes"     required="false" type="struct"  default="#StructNew()#" hint="default attributes">
		<cfargument name="scopecopy"      required="false" type="string"  default="url,form" hint="list of scopes to copy to attributes">
		<cfargument name="parse_settings" required="false" type="boolean" default="true"     hint="parse settingsfile?">
		
		<cfset var result = StructNew()>
		<cfset result.attr = variables.parser.getAttributes(arguments.attributes)>
		<cfloop list="#arguments.scopecopy#" index="result.item">
			<cfset StructAppend(result.attr, variables.parser.getAttribute(result.item, StructNew()))>
		</cfloop>
		<cfset variables.parser.setAttributes(result.attr)>
		
		<cfif arguments.parse_settings>
			<cfset result.settings = variables.parser.include(variables.parser.getParameter("settingsfile"))>
		</cfif>
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction name="OnBoxCreateRequest" hint="get all messages from debugsink">
		<cfargument name="action"  required="true" type="string" hint="full qualified action">
		
		<cfset var local = StructNew()>
		<cfset local.hand = variables.parser.getHandlerInterface()>
		<cfset local.request = local.hand.createRequest(arguments.action)>
		<cfif local.request.isExecutable()>
			<cfset local.hand.addRequest(local.request)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnExecute" hint="get all messages from debugsink">
		<cfargument name="action"  required="true" type="string" hint="full qualified action">
		
		<cfset var local = StructNew()>
		<cfset local.output = "">
		<cfif OnBoxCreateRequest(arguments.action)>
			<cfif variables.parser.getHandlerInterface().isOriginalRequest()>
				<cfset OnBoxPreAction()>
				<cfset OnBoxPlugin()>
			</cfif>
			<cfset OnBoxInclude(variables.parser.getIncludeSwitch())>
			<cfif variables.parser.getHandlerInterface().isOriginalRequest()>
				<cfset OnBoxPostAction()>
				<cfset OnBoxPlugin()>
			</cfif>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnExecuteDo" hint="get all messages from debugsink">
		<cfargument name="action"     required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfif OnBoxCreateRequest(arguments.action)>
			<cfif variables.parser.getHandlerInterface().isOriginalRequest()>
				<cfset OnBoxPreAction()>
				<cfset OnBoxPlugin()>
			</cfif>
			<cfset OnBoxInclude(variables.parser.getIncludeSwitch())>
			<cfif variables.parser.getHandlerInterface().isOriginalRequest()>
				<cfset OnBoxPostAction()>
				<cfset OnBoxPlugin()>
			</cfif>
			<cfset variables.parser.layout = variables.parser.getLastResult().output>
			<cfreturn true>
		</cfif>
		<cfreturn false>
		
	</cffunction>
	
	<cffunction name="OnBoxInclude" hint="A call to the do-method starts here">
		<cfargument name="template"   required="false">
		<cfargument name="parameters" required="false" type="struct" default="#StructNew()#">
		
		<cfset var local = StructNew()>
		<cfset local.original = variables.parser.getAttributes()>
		<!--- <cfset variables.parser.setAttributes(arguments.parameters, true)> --->
		<cfset variables.parser.setLastResult(variables.parser._include(arguments.template))>
		<!--- <cfset variables.parser.setAttributes(local.original, true)> --->
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxPreprocess" hint="preprocess request, set original action">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxPreAction" hint="returns number of errors in sink">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxRequest" hint="get all messages from debugsink">
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