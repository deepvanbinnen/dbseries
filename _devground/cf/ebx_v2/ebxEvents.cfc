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
	
	<cffunction name="OnBoxInit" hint="Initialise Parser">
		<cfset var local = StructNew()>
		
		<cfset local.attr   = variables.pi.getAttributes()>
		<cfset local.scopes = variables.pi.getProperty("scopecopy")>
		<cfloop list="#local.scopes#" index="local.scope">
			<cfset StructAppend(local.attr, variables.pi.getVar(local.scope, StructNew()))>
		</cfloop>
		<cfset variables.pi.setAttributes(local.attr)>
				
		<cfif variables.pi.parseSettings()>
			<cfif variables.pi.createInclude(variables.pi.getSettingsFile())>
				<cfset variables.pi.executeContext()>
				<cfset variables.pi.finaliseExecution()>
			</cfif>
		</cfif>
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction name="OnCreateContext" hint="creates a context for an execution">
		<cfset var si = variables.pi.getStackInterface()>
		<cfreturn >
	</cffunction>
	
	<cffunction name="OnExecuteContext" hint="creates a context for an execution">
		<cfset var si = variables.pi.getStackInterface()>
		<cfset var ctx = si.get()>
		
		<cfreturn si.get()>
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
		
		<cfif NOT variables.pi.maxRequestsReached()>
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