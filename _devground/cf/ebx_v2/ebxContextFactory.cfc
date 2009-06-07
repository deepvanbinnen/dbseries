<cfcomponent>
	<cfset variables.INCLUDE     = "include">
	<cfset variables.NEW         = "newrequest">
	<cfset variables.EMPTY       = "empty">
	<cfset variables.REQUEST     = "request">
	<cfset variables.MAINREQUEST = "mainrequest">
	<cfset variables.LAYOUT      = "layout">
	<cfset variables.PLUGIN      = "plugin">
	
	<cfset variables.empty_context   = createObject("component", "ebxContext").init(variables.EMPTY)>
	<cfset variables.current         = variables.empty_context>
	<cfset variables.context_flushed = FALSE>
	
	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
			<cfset variables.pi = arguments.ParserInterface>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getEmptyContext"  returntype="ebxContext" hint="create an empty executioncontext">
		<cfreturn variables.empty_context>
	</cffunction>	
	
	<cffunction name="getContext"  returntype="ebxContext">
		<cfargument name="reset" required="false" type="boolean" default="false">
		<cfset var local = StructNew()>
		<cfif arguments.reset>
			<cfset local.current = variables.current>
			<cfset emptyCurrentContext()>
			<cfreturn local.current>
		</cfif>
		<cfreturn variables.current>
	</cffunction>
	
	<cffunction name="createContext">
		<cfargument name="action"     required="true"  type="string">
		<cfargument name="circuitdir" required="false" type="string" default="">
		<cfargument name="template"   required="true"  type="string">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#">
		<cfargument name="contentvar" required="false" type="string"  default="">
		<cfargument name="append"     required="false" type="boolean" default="false">
		
		<cfset variables.current = createObject("component", "ebxContext").init(variables.NEW)>
		
		<cfset variables.current.setAction(arguments.action)>
		<cfset variables.current.setCircuit(ListDeleteAt(arguments.action, ListLen(arguments.action, "."), "."))>
		<cfset variables.current.setAct(ListLast(arguments.action, "."))>
		
		<cfset variables.current.setCircuitDir(arguments.circuitdir)>
		<cfset variables.current.setAppPath(variables.pi.getAppPath())>
		<cfset variables.current.setExecDir()>
		
		<cfset variables.current.setTemplate(arguments.template)>

		<cfif NOT StructIsEmpty(arguments.params)>
			<cfset variables.current.setAttributes(arguments.params)>
			<cfset local.attr = variables.pi.getAttributes()>
			<cfset local.copy = StructNew()>
			<cfloop collection="#arguments.params#" item="local.item">
				<cfif StructKeyExists(local.attr, local.item)>
					<cfset StructInsert(local.copy, local.item, local.attr[local.item])>
				</cfif>
			</cfloop>
			<cfset variables.current.setOriginals(local.copy)>
		</cfif>
		
		<cfif arguments.contentvar neq "">
			<cfset variables.current.setContentVar(arguments.contentvar)>
			<cfset variables.current.setAppend(arguments.append)>
		</cfif>
		
		<cfreturn getContext()>
	</cffunction>
	
	<cffunction name="newContext">
		<cfargument name="action"     required="true"  type="string">
		<cfargument name="circuitdir" required="false" type="string" default="">
		
		<cfset variables.current = createObject("component", "ebxContext").init(variables.NEW)>
		
		<cfset variables.current.setAction(arguments.action)>
		<cfset variables.current.setCircuit(ListDeleteAt(arguments.action, ListLen(arguments.action, "."), "."))>
		<cfset variables.current.setAct(ListLast(arguments.action, "."))>
		
		<cfset variables.current.setCircuitDir(arguments.circuitdir)>
		<cfset variables.current.setAppPath(variables.pi.getAppPath())>
		<cfset variables.current.setExecDir()>
			
		<cfset variables.context_flushed = FALSE>
		<cfreturn getContext()>
	</cffunction>	
	
	<cffunction name="getMainRequestContext">
		<cfset variables.current.setType(variables.MAINREQUEST)>
		<cfset variables.context_flushed = TRUE>
		<cfreturn getContext(true)>
	</cffunction>
	
	<cffunction name="getPluginContext">
		<cfset variables.current.setType(variables.PLUGIN)>
		<cfset variables.context_flushed = TRUE>
		<cfreturn getContext(true)>
	</cffunction>
	
	<cffunction name="getRequestContext">
		<cfset variables.current.setType(variables.REQUEST)>
		<cfset variables.context_flushed = TRUE>
		<cfreturn getContext(true)>
	</cffunction>
	
	<cffunction name="getIncludeContext">
		<cfset variables.current.setType(variables.INCLUDE)>
		<cfset variables.context_flushed = TRUE>
		<cfreturn getContext(true)>
	</cffunction>
	
	<cffunction name="getLayoutContext">
		<cfset variables.current.setType(variables.LAYOUT)>
		<cfset variables.context_flushed = TRUE>
		<cfreturn getContext(true)>
	</cffunction>
	
	<cffunction name="parseContext" returntype="any" hint="create an empty executioncontext">
		<cfargument name="action"     required="true"  type="string">
		<cfargument name="template"   required="true"  type="string">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#">
		<cfargument name="contentvar" required="false" type="string"  default="">
		<cfargument name="append"     required="false" type="boolean" default="false">
		
		<cfset var local = StructNew()>
		<cfif parseAction(arguments.action)>
			<cfset variables.current.setTemplate(arguments.template)>
			
			<cfif NOT StructIsEmpty(arguments.params)>
				<cfset variables.current.setAttributes(arguments.params)>
				<cfset local.attr = variables.pi.getAttributes()>
				<cfset local.copy = StructNew()>
				<cfloop collection="#arguments.params#" item="local.item">
					<cfif StructKeyExists(local.attr, local.item)>
						<cfset StructInsert(local.copy, local.item, local.attr[local.item])>
					</cfif>
				</cfloop>
				<cfset variables.current.setOriginals(local.copy)>
			</cfif>
			
			<cfif arguments.contentvar neq "">
				<cfset variables.current.setContentVar(arguments.contentvar)>
				<cfset variables.current.setAppend(arguments.append)>
			</cfif>
			
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="parseInternalAction" returntype="boolean">
		<cfargument name="action" required="true" type="string" hint="action">
		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		
		<cfif ListLen(arguments.action, ".") eq 3>
			<cfset local.pathvar = variables.pi.getInternal(ListLast(arguments.action, "."))>
			<cfif local.pathvar neq "">
				<cfset newContext(arguments.action, variables.pi.getProperty(local.pathvar))>
				<cfreturn true>
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="parseRequestAction" returntype="boolean">
		<cfargument name="action" required="true" type="string" hint="action">
		
		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		<cfif ListLen(arguments.action, ".") eq 2 AND variables.pi.hasCircuit(ListFirst(arguments.action, "."))>
			<cfset newContext(arguments.action, variables.pi.getCircuitDir(ListFirst(arguments.action, ".")))>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="parseAction" returntype="boolean">
		<cfargument name="action" required="true" type="string" hint="action">
		
		<cfif ListLen(arguments.action, ".") eq 3>
			<cfreturn parseInternalAction(arguments.action)>
		<cfelseif ListLen(arguments.action, ".") eq 2>
			<cfreturn parseRequestAction(arguments.action)>
		<cfelseif ListLen(arguments.action, ".") eq 1 AND stackHasRequests()>
			<cfreturn parseRequestAction(variables.pi.getProperty("thisCircuit") & "." & arguments.action)>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="emptyCurrentContext" returntype="any" hint="create an empty executioncontext">
		<cfset variables.current = variables.empty_context>
		<cfreturn true>
	</cffunction>			
	
	<cffunction name="isEmptyContext">
		<cfargument name="context" required="true"  type="ebxContext">
		<cfreturn NOT arguments.context.hasType("") OR arguments.context.checkType(variables.EMPTY)>
	</cffunction>
	
	<cffunction name="isInclude">
		<cfargument name="context" required="true"  type="ebxContext">
		<cfreturn arguments.context.checkType(variables.INCLUDE)>
	</cffunction>
	
	<cffunction name="isLayoutRequest">
		<cfargument name="context" required="true"  type="ebxContext">
		<cfreturn arguments.context.checkType(variables.LAYOUT)>
	</cffunction>
	
	<cffunction name="isMainRequest">
		<cfargument name="context" required="true"  type="ebxContext">
		<cfreturn arguments.context.checkType(variables.MAINREQUEST)>
	</cffunction>
	
	<cffunction name="isRequest">
		<cfargument name="context" required="true"  type="ebxContext">
		<cfreturn arguments.context.checkType(variables.REQUEST) OR isMainRequest(arguments.context)>
	</cffunction>
	
	<cffunction name="isNewRequest">
		<cfargument name="context" required="true"  type="ebxContext">
		<cfreturn arguments.context.checkType(variables.NEW)>
	</cffunction>
	
</cfcomponent>