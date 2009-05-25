<cfcomponent displayname="ebxEvents" hint="I handle ebxEvents">
	<cfset variables.pi = "">
	
	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
			<cfset variables.pi = arguments.ParserInterface>
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
		<cfset result.attr = variables.pi.getAttributes(arguments.attributes)>
		<cfloop list="#arguments.scopecopy#" index="result.item">
			<cfset StructAppend(result.attr, variables.pi.getAttribute(result.item, StructNew()))>
		</cfloop>
		<cfset variables.pi.setAttributes(result.attr)>
		
		<!--- <cfif arguments.parse_settings>
			<cfset result.settings = variables.parser.include(variables.parser.getParameter("settingsfile"))>
		</cfif> --->
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction name="OnAddRequest" hint="Call on application init">
		<cfargument name="request" required="false">
			<cfset createContextForRequest(arguments.request)>
			<cfset updateParser(arguments.request)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnRemoveRequest" hint="Call on application init">
		<cfset updateParser(removeRequest())>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnCreateRequest" hint="get all messages from debugsink">
		<cfargument name="action"  required="true" type="string" hint="full qualified action">
		
		<cfset var local = StructNew()>
		<cfset local.hand = variables.parser.getHandlerInterface()>
		<cfset local.request = local.hand.createRequest(arguments.action)>
		<cfif local.request.isExecutable()>
			<cfset OnAddRequest(local.request)>
		
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnExecuteDo" hint="get all messages from debugsink">
		<cfargument name="action"     required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfif OnCreateRequest(arguments.action)>
			<cfreturn OnExecuteRequest()>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnExecuteRequest" hint="get all messages from debugsink">
		<cfset var local = StructNew()>
		<cfset OnExecuteContext(getContextForRequest())>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnExecuteContext" hint="A call to the do-method starts here">
		<cfargument name="context"   required="false">
		
		<cfset setContextParameters(context)>
		<cfset OnInclude(context)>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnInclude" hint="A call to the do-method starts here">
		<cfargument name="stack"   required="false">
		
		<cfset var output = "">
	</cffunction>
	
	<cffunction name="OnBoxPreprocess" hint="preprocess request, set original action">
		<cfset var local = StructNew()>
		<cfset local.result = variables.pi.include(variables.pi.getParameter("settingsfile"), true, false)>
		<!--- <cfdump var="#local.result#"> --->
		
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