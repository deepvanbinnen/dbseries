<cfcomponent displayname="ebxPhase" hint="I represent the phases for a request">
	<cfset variables.ebx      = "">
	
	<cfset variables.phases    = ListToArray("appinit,init,preprocess,preplugin,preaction,mainrequest,postaction,postplugin,postprocess")>
	<cfset variables.currphase = 1>
	
	<cffunction name="init">
		<cfargument name="ebx" required="true" type="ebx">
		
		<cfset variables.ebx = arguments.ebx>
		<cfset super.init(variables.ebx)>
		<cfset variables.ebx.setDebug("Initialising... Phase Component", 0)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPhase">
		<cfreturn variables.currphase>
	</cffunction>
	
	<cffunction name="getPhaseName">
		<cfreturn variables.phases[getPhase()]>
	</cffunction>
	
	<cffunction name="setPhase">
		<cfargument name="phaseindex" required="true" type="numeric">
		<cfset variables.currphase = arguments.phaseindex>
	</cffunction>

	<cffunction name="execPhase">
		<cfif variables.currphase lte ArrayLen(variables.phases)>
			<cfswitch expression="#variables.phases[variables.currphase]#">
				<cfcase value="appinit">
					<cfreturn true>
				</cfcase>
				<cfcase value="init">
					<!--- convert form/url to attributes and parameters and parse ebx_settings --->
					<cfset setDebug("Initialise 'static' box...")>
					<cfif OnBoxRequestInit(variables.ebx)>
						<cfset setDebug("Initialise 'static' box...")>
						<cfset variables.ebx.setInitialised()>
						<cfreturn true>
					</cfif>
					<cfreturn false>
				</cfcase>
				<cfcase value="preprocess">
					<!--- validation of mainrequest --->
					<cfset OnBoxPreprocess(variables.ebx)>
					<cfset copyFormParameters()>
					<cfset copyURLParameters()>
					<cfset parseSettings()>
				</cfcase>
				
				<cfcase value="preaction">
					<!--- 
					/***
					  *  Only for the main-request!
					  *  Flush the current output and set custom parameters 
					  */ 
					--->
					<cfset OnBoxPreAction(variables.ebx)>
				</cfcase>
				<cfcase value="preplugin">
					<!--- execute preplugins --->
					<cfset OnBoxPlugin(variables.ebx)>
				</cfcase>
				<cfcase value="mainrequest">
					<!--- execute request --->
					<cfset OnBoxRequest(variables.ebx)>
				</cfcase>
				<cfcase value="postaction">
					<!--- flush the current output and set custom parameters --->
					<cfset OnBoxPostAction(variables.ebx)>
				</cfcase>
				<cfcase value="postplugin">
					<cfset OnBoxPlugin(variables.ebx)>
				</cfcase>
				<cfcase value="postprocess">
					<!--- flush the output and parse layout --->
					<cfset OnBoxPostprocess(variables.ebx)>
				</cfcase>
			</cfswitch>
		
			<cfif variables.currphase lt ArrayLen(variables.phases)>
				<cfset setPhase(variables.currphase+1)>
			</cfif>
		</cfif>
	
	</cffunction>
	
	

</cfcomponent>