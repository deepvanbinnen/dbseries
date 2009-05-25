<cfcomponent>
	<cfset variables.ebx        = "">
	<cfset variables.Parser     = "">
	<cfset variables.interfaces = StructNew()>
	
	<cffunction name="init" returntype="ebxParserInterface">
		<cfargument name="ebxParser" type="ebxParser" required="true">
		<cfset variables.Parser = arguments.ebxParser>
		<cfset variables.ebx    = variables.Parser.getEbx()>
		
		<cfset initInterfaces()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="createEventInterface" returntype="boolean">
		<cfreturn createInterface("ebxEvents", true)>
	</cffunction>
	
	<cffunction name="createHandlerInterface" returntype="boolean">
		<cfreturn createInterface("ebxHandler", true)>
	</cffunction>
	
	<cffunction name="createInterface" returntype="boolean">
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
	
	<cffunction name="createPageContext" returntype="boolean">
		<cfreturn createInterface("ebxPageContext", false)>
	</cffunction>
	
	<cffunction name="createPhaseInterface" returntype="boolean">
		<cfreturn createInterface("ebxPhases", true)>
	</cffunction>
	
	<cffunction name="executeDo" returntype="boolean">
		<cfset var EventInterface = getEventInterface()>
		<cfif EventInterface.OnCreateDo(arguments)>
			<cfif EventInterface.OnExecuteDo()>
				<cfreturn true>
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="executeInclude" returntype="boolean">
		<cfset var EventInterface = getEventInterface()>
		<cfif EventInterface.OnCreateExecutionContext(arguments)>
			<cfif EventInterface.OnExecuteContext()>
				<cfreturn true>
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="executeInitialise" returntype="boolean">
		<cfset var phi = getPhaseInterface()>
		<cfset phi.setPhaseByName("init")>
		<cfif phi.execPhase()>
			<cfset phi.execPhase()>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="executeMainRequest" returntype="boolean">
		<cfset var local = StructNew()>
		<cfset var hi = getHandlerInterface()>
		<cfset var phi = getPhaseInterface()>
		
		<cfset local.req = hi.createRequest(getMainAction(), StructNew())>
		<cfif local.req.isExecutable()>
			<cfif hi.addRequest(local.req)>
				<cfset local.result = include(getParameter("switchfile"))>
				
				<cfif NOT local.result.errors>
					<!--- parse layout? --->
					<cfoutput>#local.result.output#</cfoutput>
				<cfelse>
					<cfdump var="#local.result#">
				</cfif>
				<!--- <cfdump var="#local.result#"> --->
			</cfif>
		</cfif>
	
		<cfreturn false>		
	</cffunction>
	
	<cffunction name="include" returntype="struct">
		<cfargument name="template"      type="string" required="true">
		<cfargument name="parseAppPath"  type="boolean" required="false" default="true">
		<cfargument name="parseCircPath" type="boolean" required="false" default="true">
		
		<cfif arguments.parseCircPath>
			<cfset arguments.template = variables.Parser.getProperty("circuitdir") & arguments.template>
		</cfif>
		<cfif arguments.parseAppPath>
			<cfset arguments.template = variables.Parser.getProperty("appath") & arguments.template>
		</cfif>
		<cfreturn getEbxPageContext().ebx_include(arguments.template)>
	</cffunction>
	
	<cffunction name="initInterfaces" returntype="boolean">
		<cfset createEventInterface()>
		<cfset createHandlerInterface()>
		<cfset createPageContext()>
		<cfset createPhaseInterface()>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getAppPath">
		<cfreturn variables.ebx.getAppPath()>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.getCircuitDir(arguments.name)>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.hasCircuit(arguments.name)>
	</cffunction>
	
	<cffunction name="getAttribute" returntype="any">
		<cfargument name="name"  type="string" required="true">
		<cfargument name="value" type="any"    required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfif StructKeyExists(local.attr, arguments.name)>
			<cfreturn local.attr[arguments.name]>
		</cfif>
		
		<cfreturn arguments.value>
	</cffunction>
	
	<cffunction name="getAttributes" returntype="struct">
		<cfreturn getEbxPageContext().ebx_get("attributes", StructNew())>
	</cffunction>
	
	<cffunction name="getEbxPageContext" returntype="ebxPageContext">
		<cfreturn getInterface("ebxPageContext")>
	</cffunction>
	
	<cffunction name="getEventInterface" returntype="ebxEvents">
		<cfreturn getInterface("ebxEvents")>
	</cffunction>
	
	<cffunction name="getInterface" returntype="any">
		<cfargument name="name" type="any" required="true">
		
		<cfif StructKeyExists(variables.interfaces, arguments.name)>
			<cfreturn variables.interfaces[arguments.name]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getHandlerInterface" returntype="ebxHandler">
		<cfreturn getInterface("ebxHandler")>
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
	
	<cffunction name="getPhaseInterface" returntype="ebxPhases">
		<cfreturn getInterface("ebxPhases")>
	</cffunction>
	
	<cffunction name="updateParser" returntype="boolean">
		<cfargument name="request" type="ebxRequest" required="true">
	</cffunction>
	
	<cffunction name="updateParserState" returntype="boolean">
		<cfset Parser.phase = getPhaseInterface().getPhaseName()>
		<cfset Parser.state = getPhaseInterface().getStateName()>
	</cffunction>
	
	<cffunction name="setAttributes" returntype="any">
		<cfargument name="attribs" type="struct" required="true">
		<cfreturn getEbxPageContext().ebx_put("attributes", arguments.attribs)>
	</cffunction>
</cfcomponent>
			
				