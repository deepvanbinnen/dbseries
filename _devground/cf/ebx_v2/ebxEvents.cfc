<cfcomponent extends="ebxCore" displayname="ebxEvents" hint="I handle ebxEvents">
	<cfset variables.ebx = "">
	
	<cfset variables.errors = StructNew()>
	<cfset variables.errors.UNKNOWN_ERROR = "Unknown error!">
	<cfset variables.errors.NO_CIRCUITS   = "No circuits defined!">
	<cfset variables.errors.NO_REQUEST    = "No action to be executed!">
	
	<cffunction name="init">
		<cfargument name="ebx" required="true">
		
		<cfset variables.ebx = arguments.ebx>
		<cfset super.init(variables.ebx)>
		
		<cfreturn this>
	</cffunction>	
	
	<cffunction name="OnBoxAppInit" hint="Call on application init">
		<cfargument name="ebx" required="false">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxInit" hint="Initialize eBox">
		<cfargument name="ebx" required="true">
		
		<cfset setDebug("Initialise 'static' box...")>
		<cfset setDebug("Get requesthandler...")>
		<!--- <cfif NOT getCoreInterface("reqhandler").hasRequests()>
			
		</cfif> --->
		
		<!--- <cfset init(arguments.ebx)>
		<cfset variables.ebx.syncParameters(getParameter("EXPOSED_PARAMS"))> --->
		
		<cfif parseCircuits()>
			<cfset parseLayouts()>
			<cfset parsePlugins()>
			
			<cfreturn true>
		<cfelse>
			<cfreturn variables.ebx.setFatalError(variables.errors.NO_CIRCUITS)>
		</cfif>
		
	</cffunction>
	
	<cffunction name="OnBoxRequestInit" hint="A call to the do-method starts here">
		<cfargument name="ebx"        required="false">
		<cfargument name="ebxRequest" required="false">
			<!--- validate main request --->
			<cfset var local = StructNew()>
			
			<cfset setDebug("New box request...")>
			<cfif NOT hasRequests()>
				<!--- START OF PREPROCESS --->
				<cfset setDebug("There is no main request, so we set one up...")>
				<cfset setDebug("Is this a custom tag call?")>
				<cfif NOT IsBoolean(fetch("caller", FALSE))>
					<cfset setDebug("It is. What now? Store it somewhere perhaps...")>
				<cfelse>
					<cfset setDebug("Doesn't look like it. Is this actually possible?")>
				</cfif>
				<cfset setDebug("Is this a do()? Why do I need this?!!")>
				<cfset setDebug("Converting URL and FORM..")>
				<cfset setAttributes(fetch("url"))>
				<cfset setAttributes(fetch("form"))>
				<!--- cfset copyFormParameters()>
				<cfset copyURLParameters()> --->
				<!--- <cfset setDebug("Convert attributes to parameters used in the request")> --->
				<!--- <cfset setDebug("new way to store and pass through variables")> --->
				<cfset setDebug("Parse settings")>
				<cfset parseSettings()>
				<cfset setDebug("Setup the main request so that the output is stored in the layout variable")>
				<cfset local.req = createObject("component", "ebxRequest").init(variables.ebx, getAttribute(variables.ebx.getActionVar(), variables.ebx.getDefaultAct()), StructNew())>
				<cfset setDebug("Setup the main request so that the output is stored in the layout variable")>
				<cfif NOT local.req.isExecutable()>
					<cfset setDebug("Request is not executable, spit out the request error!")>
				</cfif>
				<cfset variables.ebx.setOriginalRequest(local.req)>
				<!---  --->
				<!--- <cfset setDebug("Set initial parameters()")> --->
				<!--- END OF PREPROCESS --->
				
				<!--- START OF BOXREQUEST --->
				<cfset local.req = OnBoxRequest(local.req)>
				<!--- END OF BOXREQUEST --->
				
				<!--- START OF POSTPROCESS --->
				<cfset setDebug("Walk the request stack and finalise request")>
				
				<cfdump var="#variables.ebx.getInterface("reqhandler").getRequests()#">
				
				<cfset setDebug("Release custom attributes")>
				<cfset setDebug("Assign the output of the switch file")>
				<!--- END OF POSTPROCESS --->

				
				
				<cfset setDebug("The layout variable now contains the output of the switch-file")>
				<cfset setDebug("Parse the layout and output it to the caller")>

				<!--- <cfset setDebug("Execute preaction")> --->
				
				
				
				<!--- <cfif NOT IsDefined("arguments.ebxRequest")>
					<cfif NOT OnBoxMainRequestInit(variables.ebx)>
						<cfreturn variables.ebx.setFatalError(variables.errors.UNKNOWN_ERROR)>
					</cfif>
					<cfif createRequest(ebx=variables.ebx, action=getMainAction(), flush=false)>
						<cfset addRequest(getLastCreatedRequest())>
					<cfelse>
						<cfreturn variables.ebx.setFatalError(variables.errors.NO_REQUEST)>
					</cfif>
				<cfelse>
					<cfset addRequest(arguments.ebxRequest)>
				</cfif>
				<cfset OnBoxPreprocess(getCurrentRequest())>
				<cfset OnBoxPreAction(getCurrentRequest())>
				<cfset OnBoxRequest(getCurrentRequest())>
				<cfset OnBoxPostAction(getCurrentRequest())>
				<cfset OnBoxPostprocess(getCurrentRequest())> --->
			</cfif>
			
	</cffunction>
	
	<cffunction name="OnBoxMainRequestInit" hint="A call to the main do-method starts here">
		<cfargument name="ebx" required="false">
		<!--- validate main request --->
		<cfset var local = StructNew()>
		
		<cfset setDebug("Main request init...")>
		
		<cfset init(arguments.ebx)>
		<cfset copyFormParameters()>
		<cfset copyURLParameters()>
		<cfset parseSettings()>
		
		<cfif NOT hasMainAction()>
			<cfset setMainAction()>
		</cfif>

		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxPreprocess" hint="preprocess request, set original action">
		<cfargument name="ebxRequest" required="true" type="ebxRequest">
		
		<cfset var local = StructNew()>
		<cfset setDebug("In preprocess setting originalCircuit and action...")>
		<cfset updateGlobalParameter("originalCircuit", arguments.ebxRequest.getCircuit())>
		<cfset updateGlobalParameter("originalAction", arguments.ebxRequest.getAction())>
		<cfset updateGlobalParameter("originalAct", arguments.ebxRequest.getAct())>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxPreAction" hint="returns number of errors in sink">
		<cfargument name="ebxRequest" required="true" type="ebxRequest">
		
		<cfset var local = StructNew()>
		<cfset setDebug("Preaction...")>
		<cfif isMainRequest()>
			<cfset setDebug("Is main action start preaction process...")>
		</cfif>
		<cfset setDebug("Set custom parameters...")>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxRequest" hint="get all messages from debugsink">
		<cfargument name="ebxRequest" required="true" type="ebxRequest">
		
		<cfset setDebug("The following occurs for any box request, whether it's done or ... just the main request :)")>
		<cfset variables.ebx.setCurrentRequest(arguments.ebxRequest)>
		<cfset setDebug("Ebx properties updated")>
		<cfset addRequest(arguments.ebxRequest)>
		<cfset setDebug("Added request to stack")>
		<cfset arguments.ebxRequest.initParameters()>
		<cfset setDebug("Custom attributes set")>
		
		<cfset setDebug("Get validated fuseaction")>
		<cfset setDebug("Execute preaction")>
		<cfset setDebug("Validate switch")>
		<cfset parseRequest(arguments.ebxRequest)>
		
		<cfset setDebug("Include the switch file")>
		<cfset setDebug("Execute postaction")>
		
		<cfreturn arguments.ebxRequest>
	</cffunction>

	<cffunction name="OnBoxPostAction" hint="get all messages from debugsink">
		<cfargument name="ebxRequest" required="true" type="ebxRequest">
		
		<cfset setDebug("Postaction...")>
		
		<cfif arguments.ebxRequest.getFlush()>
			<cfset setDebug("Output request...")>
			<cfset print(arguments.ebxRequest.getOutput())>
		<cfelseif arguments.ebxRequest.getContentVar() neq "">
			<cfset setDebug("Assign output to variable...")>
		<cfelse>
			<cfif NOT IsMainRequest()>
				<cfset setDebug("WARNING: No output specified... output suppressed...")>
			</cfif>
		</cfif>
		
		<cfset setDebug("Release custom parameters...")>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxPostprocess" hint="get all messages from debugsink">
		<cfargument name="ebx" required="false">
			<cfif NOT IsMainRequest()>
				<cfset setDebug("Walk handler stack and call OnBoxPostAction for request")>
			</cfif>
			<cfset updateGlobalParameter("layout", getCurrentRequest().getOutput())>
			<cfset print(getParameter("layout"))>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OnBoxPlugin" hint="get all messages from debugsink">
		<cfargument name="ebx" required="false">
		<cfreturn true>
	</cffunction>
	
</cfcomponent>