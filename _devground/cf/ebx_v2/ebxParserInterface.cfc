<cfcomponent>
	<cfset variables.ebx         = "">
	<cfset variables.Parser      = "">
	<cfset variables.LastRequest = "">
	<cfset variables.LastResult  = "">
	<cfset variables.CustomAttr  = Arraynew(1)>

	<cfset variables.interfaces  = StructNew()>
	
	<cffunction name="init" returntype="ebxParserInterface">
		<cfargument name="ebxParser" type="ebxParser" required="true">
		
		<cfset variables.Parser = arguments.ebxParser>
		<cfset variables.ebx    = variables.Parser.getEbx()>
		
		<cfset initInterfaces()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="assignOutput">
		<cfargument name="output"     required="true" type="string" default="false" hint="wheater to append contentvars output">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var pc = getEbxPageContext()>
		<cfset var out = arguments.output>
		
		<cfif arguments.contentvar eq "">
			<cfset pc.ebx_write(out)>
		<cfelse>
			<cfif arguments.append>
				<cfset out = getVar(arguments.contentvar) & out>
			</cfif>
			<cfset pc.ebx_put(arguments.contentvar, out)>
		</cfif>
		<cfreturn true>
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
		<cfargument name="action"     required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var evt = getEventInterface()>
		
		<cfif evt.onCreateRequest(arguments.action, arguments.params)>
			<cfif evt.onAddRequest(getLastRequest())>
				<cfset evt.OnSetAttributes(arguments.params)>
				<cfif evt.OnInclude(getSwitchFile())>
					<cfset assignOutput(variables.LastResult.output, arguments.contentvar, arguments.append)>
				</cfif>
				<cfset evt.OnReleaseAttributes(arguments.params)>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="executeInclude" returntype="boolean">
		<cfargument name="template"   required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var evt = getEventInterface()>
		<cfset evt.OnSetAttributes(arguments.params)>
		<cfif evt.OnInclude(getFilePath(arguments.template))>
			<cfset assignOutput(variables.LastResult.output, arguments.contentvar, arguments.append)>
		</cfif>
		<cfset evt.OnReleaseAttributes(arguments.params)>
		
		<cfreturn true>
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
		<cfset var evt = getEventInterface()>
		
		<cfif evt.onCreateRequest(getMainAction(), StructNew())>
			<cfif evt.onAddRequest(getLastRequest())>
				<cfif evt.OnInclude(getSwitchFile())>
					<!--- 
					* Output must go to layout
					* Parse layout
					--->
					<cfset variables.Parser.layout = variables.LastResult.output>
					<!--- <cfif getParameter("parselayout")> --->
						<cfif evt.OnInclude(getLayoutFile())>
							<cfif evt.OnInclude(getLayout())>
							
							</cfif>
						</cfif>
					<!--- </cfif> --->
					
					<cfset assignOutput(variables.LastResult.output)>
				<cfelse>
					<cfdump var="#variables.LastResult#">
				</cfif>
				<!--- <cfdump var="#local.result#"> --->
			</cfif>
		</cfif>
	
		<cfreturn false>		
	</cffunction>
	
	<cffunction name="include" returntype="struct">
		<cfargument name="template"      type="string" required="true">
		<cfset var pc = getEbxPageContext()>
		<cfreturn pc.ebx_include(arguments.template)>
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
	
	<cffunction name="getFilePath">
		<cfargument name="name" type="string" required="true">
		<cfargument name="parseAppPath"  type="boolean" required="false" default="true">
		<cfargument name="parseCircPath" type="boolean" required="false" default="true">
		
		<cfif arguments.parseCircPath>
			<cfset arguments.name = variables.Parser.getProperty("circuitdir") & arguments.name>
		</cfif>
		<cfif arguments.parseAppPath>
			<cfset arguments.name = variables.Parser.getProperty("appath") & arguments.name>
		</cfif>
		<cfreturn arguments.name>
	</cffunction>
	
	<cffunction name="getLayout">
		<cfreturn getFilePath(variables.Parser.getProperty("layoutdir") & variables.Parser.getProperty("layoutfile"), true, false)>
	</cffunction>
	
	<cffunction name="getLayoutFile">
		<cfreturn getFilePath(getParameter("layoutsfile"), true, false)>
	</cffunction>
	
	<cffunction name="getSwitchFile">
		<cfreturn getFilePath(getParameter("switchfile"))>
	</cffunction>
	
	<cffunction name="getSettingsFile">
		<cfreturn getFilePath(getParameter("settingsfile"))>
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
		<cfif hasAttribute(arguments.name, local.attr)>
			<cfreturn local.attr[arguments.name]>
		</cfif>
		
		<cfreturn arguments.value>
	</cffunction>
	
	<cffunction name="hasAttribute" returntype="any">
		<cfargument name="name"       type="string" required="true">
		<cfargument name="attributes" type="struct" required="false" default="#getAttributes()#">
		
		<cfreturn StructKeyExists(arguments.attributes, arguments.name)>
	</cffunction>
	
	<cffunction name="storeAttributes" returntype="boolean">
		<cfargument name="attributes" type="struct" required="false" default="#StructNew()#">
		<cfset ArrayPrepend(variables.CustomAttr, arguments.attributes)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="releaseAttributes" returntype="boolean">
		<cfset var local = StructNew()>
		<cfif ArrayLen(variables.CustomAttr)>
			<cfset updateAttributes(variables.CustomAttr[1])>
			<cfset ArrayDeleteAt(variables.CustomAttr,1)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getAttributes" returntype="struct">
		<cfreturn getVar("attributes", StructNew())>
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
	
	<cffunction name="getLastRequest">
		<cfreturn variables.LastRequest>
	</cffunction>
	
	<cffunction name="getLastResult">
		<cfreturn variables.LastResult>
	</cffunction>
	
	<cffunction name="resultHasErrors">
		<cfreturn NOT IsStruct(variables.LastResult) OR variables.LastResult.errors>
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
	
	<cffunction name="getVar" returntype="any">
		<cfargument name="name"  type="string" required="true">
		<cfargument name="value" type="any"    required="false" default="">
		<cfreturn getEbxPageContext().ebx_get(arguments.name, arguments.value)>
	</cffunction>
	
	<cffunction name="setLastRequest">
		<cfargument name="request"  type="any" required="true">
		<cfset variables.LastRequest = arguments.request>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setLastResult">
		<cfargument name="result"  type="any" required="true">
		<cfset variables.LastResult = arguments.result>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateParser" returntype="boolean">
		<cfargument name="request" type="ebxRequest" required="true">
		
		<cfset var hi = getHandlerInterface()>
		<cfset variables.Parser.setCurrentRequest(arguments.request)>
		<cfset variables.Parser.setTargetRequest(arguments.request)>
		
		<cfif hi.isOriginalRequest()>
			<cfset variables.Parser.setOriginalRequest(arguments.request)>
		</cfif>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateParserState" returntype="boolean">
		<cfset Parser.phase = getPhaseInterface().getPhaseName()>
		<cfset Parser.state = getPhaseInterface().getStateName()>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setAttributes" returntype="any">
		<cfargument name="attribs" type="struct" required="true">
		<cfreturn getEbxPageContext().ebx_put("attributes", arguments.attribs)>
	</cffunction>
	
	<cffunction name="updateAttributes" returntype="any">
		<cfargument name="attributes" type="struct" required="true" default="#StructNew()#">
		
		<cfset var local  = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfset StructAppend(local.attr, arguments.attributes, TRUE)>
		<cfreturn setAttributes(local.attr)>
	</cffunction>
</cfcomponent>