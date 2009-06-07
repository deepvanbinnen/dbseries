<cfcomponent>
	<cfset variables.phase_states = StructNew()>
	<cfset variables.phase_states["initialise"]  = "initialised">
	<cfset variables.phase_states["preprocess"]  = "preprocessing done">
	<cfset variables.phase_states["preaction"]   = "preaction executed">
	<cfset variables.phase_states["preplugin"]   = "preplugins processed">
	<cfset variables.phase_states["mainaction"]  = "mainaction set">
	<cfset variables.phase_states["parse"]       = "action parsed">
	<cfset variables.phase_states["execute"]     = "mainaction executed">
	<cfset variables.phase_states["postprocess"] = "postprocessing done">
	<cfset variables.phase_states["postplugin"]  = "postplugins processed">
	<cfset variables.phase_states["postaction"]  = "postaction executed">
	<cfset variables.phase_states["do"]          = "do executed">
	<cfset variables.phase_states["include"]     = "include executed">
	<cfset variables.phase_states["error"]       = "error occurred">
	<cfset variables.phase_states["fatal"]       = "fatal error occurred">
				
	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
			<cfset variables.pi = arguments.ParserInterface>
			<cfset variables.evt = variables.pi.getEventInterface()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="execPhase">
		<cfargument name="phase" required="true" type="string">
		
		<cfset var local = StructNew()>
		<cfset local.result = false>

		<cfset setPhase(arguments.phase)>
		
		<cfswitch expression="#arguments.phase#">
			<cfcase value="initialise">
				<cfset local.result = variables.evt.OnBoxInit()>
			</cfcase>
			
			<cfcase value="preprocess">
				<cfif NOT variables.pi.getProperty("nosettings")>
					<cfset local.result = variables.evt.OnParseSettings()>
				<cfelse>
					<cfset local.result = true>
				</cfif>
			</cfcase>
			
			<cfcase value="mainaction">
				<cfset local.result = variables.evt.OnCreateContext(type="mainrequest", action=variables.pi.getMainAction(), parse=true)>
			</cfcase>
			
			<cfcase value="parse">
				<cfset local.result = variables.evt.OnParseRequest()>
			</cfcase>
			
			<cfcase value="preaction,preplugin,postaction,postplugin">
				<cfset local.result = true>
			</cfcase>
			
			<cfcase value="postprocess">
				<cfset local.result = variables.evt.OnLayout()>
			</cfcase>
			
			<cfcase value="execute">
				<cfset local.result = variables.evt.OnExecuteStackContext()>
			</cfcase>
			
		</cfswitch>
		
		<cfif local.result>
			<cfset setState(arguments.phase)>
		</cfif>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="setPhase">
		<cfargument name="phase" required="true" type="string">
		<cfset variables.pi.setPhase(arguments.phase)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="hasPhase">
		<cfargument name="phase" required="true" type="string">
		<cfreturn StructKeyExists(variables.phase_states, arguments.phase)>
	</cffunction>
	
	<cffunction name="getPhase">
		<cfargument name="phase" required="true" type="string">
		<cfif hasPhase(arguments.phase)>
			<cfreturn variables.phase_states[arguments.phase]>
		</cfif>
		<cfreturn "no such phase: #arguments.phase#">
	</cffunction>
	
	<cffunction name="setState">
		<cfargument name="phase" required="true" type="string">
		<cfset variables.pi.setState(getPhase(arguments.phase))>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>