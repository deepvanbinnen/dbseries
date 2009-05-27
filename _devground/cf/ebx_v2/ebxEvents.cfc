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
		<cfset var hi = variables.pi.getHandlerInterface()>
		<cfif arguments.request.isExecutable()>
			<cfif hi.addRequest(arguments.request)>
				<cfset variables.pi.updateParser(arguments.request)>
				<cfreturn true>
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnRemoveRequest" hint="Call on application init">
		<cfset var hi = variables.pi.getHandlerInterface()>
		<cfif hi.removeRequest()>
			<cfset variables.pi.updateParser(hi.getRequest())>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnCreateRequest" hint="get all messages from debugsink">
		<cfargument name="action"     required="true"  type="string" hint="full qualified action">
		<cfargument name="parameters" required="false" type="struct"  hint="custom attributes for the fuseaction">
		
		<cfset var hi = variables.pi.getHandlerInterface()>
		<cfif NOT hi.maxRequestsReached()>
			<cfset variables.pi.setLastRequest(hi.createRequest(arguments.action, arguments.parameters))>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="OnSetAttributes" hint="get all messages from debugsink">
		<cfargument name="attributes" required="true" type="struct"   hint="the action to execute">
		
		<cfset var local = StructNew()>
		<cfset local.attr     = variables.pi.getAttributes()>
		<cfset local.original = StructNew()>
		
		<cfloop collection="#arguments.attributes#" item="local.param">
			<cfif variables.pi.hasAttribute(local.param)>
				<cfset StructInsert(local.original, local.param, variables.pi.getAttribute(local.param), TRUE)>
			</cfif>
		</cfloop>
		<cfset variables.pi.storeAttributes(local.original)>
		<cfset variables.pi.updateAttributes(arguments.attributes)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnReleaseAttributes" hint="get all messages from debugsink">
		<cfset variables.pi.releaseAttributes()>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnInclude" hint="A call to the do-method starts here">
		<cfargument name="template" required="false">
		
		<cfset var pc = variables.pi.getEbxPageContext()>
		<cfset variables.pi.setLastResult(pc.ebx_include(arguments.template))>
		<cfreturn NOT variables.pi.resultHasErrors()>
	</cffunction>
	
	<cffunction name="OnBoxPreprocess" hint="preprocess request, set original action">
		<cfreturn OnInclude(variables.pi.getSettingsFile())>
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