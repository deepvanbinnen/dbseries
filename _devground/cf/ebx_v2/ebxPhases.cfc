<cfcomponent displayname="ebxPhase" hint="I represent the phases for a request">
	<cfset variables.pi  = "">
	<cfset variables.evt = "">
	
	<cfset variables.states = ArrayNew(1)>
	<cfset ArrayAppend(variables.states, "UNINITIALISED")>  <!--- 1 --->
	<cfset ArrayAppend(variables.states, "INITIALISED")>    <!--- 2 --->
	<cfset ArrayAppend(variables.states, "READY")>          <!--- 3 --->
	<cfset ArrayAppend(variables.states, "ERROR")>          <!--- 4 --->
	<cfset ArrayAppend(variables.states, "FATALERROR")>     <!--- 5 --->
	<cfset ArrayAppend(variables.states, "PARSING")>        <!--- 6 --->
	
	<cfset variables.phases = ArrayNew(1)>
	<cfset ArrayAppend(variables.phases, "init")>        <!--- 1 --->
	<cfset ArrayAppend(variables.phases, "preprocess")>  <!--- 2 --->
	<cfset ArrayAppend(variables.phases, "preaction")>   <!--- 3 --->
	<cfset ArrayAppend(variables.phases, "preplugin")>   <!--- 4 --->
	<cfset ArrayAppend(variables.phases, "action")>      <!--- 5 --->
	<cfset ArrayAppend(variables.phases, "postaction")>  <!--- 6 --->
	<cfset ArrayAppend(variables.phases, "postplugin")>  <!--- 7 --->
	<cfset ArrayAppend(variables.phases, "postprocess")> <!--- 8 --->
	<cfset ArrayAppend(variables.phases, "error")>       <!--- 9 --->

	<cfset variables.phase = "1">
	<cfset variables.state = "1">
	
	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
			<cfset variables.pi  = arguments.ParserInterface>
			<cfset variables.evt = variables.pi.getEventInterface()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPhase">
		<cfreturn variables.phase>
	</cffunction>
	
	<cffunction name="getPhaseName">
		<cfreturn variables.phases[getPhase()]>
	</cffunction>
	
	<cffunction name="getPhaseByName">
		<cfargument name="name" type="string">
		<cfreturn _indexOf(variables.phases, arguments.name)>
	</cffunction>
	
	<cffunction name="getState">
		<cfreturn variables.state>
	</cffunction>
	
	<cffunction name="getStateName">
		<cfreturn variables.states[getState()]>
	</cffunction>
	
	<cffunction name="setPhase">
		<cfargument name="phase" required="true" type="numeric">
		<cfset variables.phase = arguments.phase>
	</cffunction>
	
	<cffunction name="setPhaseByName">
		<cfargument name="name" required="true" type="string">
		<cfset variables.phase = getPhaseByName(arguments.name)>
		<cfreturn getPhase()>
	</cffunction>

	<cffunction name="execPhase">
		<cfset var local = StructNew()>
		<cfswitch expression="#getPhaseName()#">
			<cfcase value="appinit">
				<cfreturn true>
			</cfcase>
			<cfcase value="init">
				<cfif variables.evt.OnBoxInit()>
					<cfset variables.phase = variables.phase+1>
					<cfset variables.state = variables.state+1>
				</cfif>
			</cfcase>
			<cfcase value="preprocess">
				<cfif variables.evt.OnBoxPreprocess()>
					<cfset variables.phase = setPhaseByName("action")>
					<cfset variables.state = variables.state+1>
				</cfif>
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
			<cfcase value="action">
				START EXECUTION
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
		<cfset variables.pi.updateParserState()>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="_indexOf">
		<cfargument name="array" required="true" type="array">
		<cfargument name="value" required="true" type="any">
		
		<cfset var local = StructNew()>
		<cfloop from="1" to="#ArrayLen(arguments.array)#" index="local.i">
			<cfif arguments.value eq arguments.array[local.i]>
				<cfreturn local.i>
			</cfif>
		</cfloop>
		<cfreturn -1>
	</cffunction>
</cfcomponent>