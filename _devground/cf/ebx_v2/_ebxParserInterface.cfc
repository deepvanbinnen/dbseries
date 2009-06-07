<cfcomponent>
	<cfset variables.ebx          = "">
	<cfset variables.Parser       = "">
	<cfset variables.thisContext  = "">
	<cfset variables.tickStart    = getTickCount()>
	<cfset variables.lastTick     = variables.tickStart>
	<cfset variables.ticks        = ArrayNew(1)>
	<cfset variables.qticks       = QueryNew("a_LASTEXEC,a_TOTAL,LABEL,RCTX,TC")>

	<cffunction name="init" returntype="ebxParserInterface">
		<cfargument name="ebxParser"  type="ebxParser" required="true">
		<cfargument name="attributes" type="struct"    required="false" default="#StructNew()#">
		
		<cfset variables.Parser = arguments.ebxParser>
		<cfset variables.ebx    = variables.Parser.getEbx()>
		
		<cfset variables.pc    = createObject("component", "ebxPageContext")>
		<cfset variables.cf    = createObject("component", "ebxContextFactory").init(this)>
		<cfset variables.stack = createObject("component", "ebxExecutionStack").init(variables.cf.getEmptyContext())>
		<!--- <cfset variables.evt   = createObject("component", "ebxEvents").init(this)>
		<cfset variables.phi   = createObject("component", "ebxPhases").init(this)> --->
		
		<cfset setAttributes(arguments.attributes)>
		
		<cfreturn this>
	</cffunction>
	
	<!--- Pagecontext --->
	<cffunction name="include" returntype="struct">
		<cfargument name="template"      type="string" required="true">
		<cfreturn getEbxPageContext().ebx_include(arguments.template)>
	</cffunction>
	
	<cffunction name="flushOutput" returntype="boolean">
		<cfargument name="output" type="string" required="true">
		<cfset getEbxPageContext().ebx_write(arguments.output)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="assignVariable" hint="assign output (mostly from an executioncontext result) to content var or else flush it to the page">
		<cfargument name="contentvar" required="true" type="string" hint="pagevariable to set">
		<cfargument name="value"        required="true" type="any"  hint="value to use">
		<cfargument name="append"       required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var local = StructNew()>
		<cfif arguments.append>
			<cfset local.currval = appendVariable(getVar(arguments.contentvar, ""), arguments.value)>
		<cfelse>
			<cfset local.currval = arguments.value>
		</cfif>
		
		<cfset getEbxPageContext().ebx_put(arguments.contentvar, local.currval)>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getVar" returntype="any">
		<cfargument name="name"  type="string" required="true">
		<cfargument name="value" type="any"    required="false" default="">
		<cfreturn getEbxPageContext().ebx_get(arguments.name, arguments.value)>
	</cffunction>
	
	<!--- Context factory --->
<!--- 	<cffunction name="createIncludeContext" returntype="any">
		<cfset variables.cf.parseContext(argumentCollection=arguments)>
		<cfset variables.cf.getIncludeContext()>
	</cffunction> --->
	
	
	<!--- Stack --->
	<!--- <cffunction name="appendStack" returntype="any">
		<cfreturn variables.stack.add(variables.thisContext)>
	</cffunction>
		
	<cffunction name="updateStack" returntype="any">
		<cfset variables.stack.remove()>
		<cfset updateContext()>
		<cfset updateParser()>
		<cfreturn true>
	</cffunction>
	 --->
	<cffunction name="maxRequestsReached" returntype="boolean">
		<cfreturn getStackInterface().maxReached()>
	</cffunction>
	
	 <cffunction name="setThisContext" returntype="boolean">
		<cfargument name="context" type="any" required="true">
		<cfset variables.thisContext = arguments.context>
		<cfreturn true>
	</cffunction>
	
	<!--- Context --->
	<!--- <cffunction name="setThisContext" returntype="boolean">
		<cfargument name="context" type="any" required="true">
		<cfset variables.thisContext = arguments.context>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="contextIsExecutable">
		<cfreturn variables.thisContext.isExecutable()>
	</cffunction>
	
	<cffunction name="createContext"  returntype="ebxExecutionContext" hint="create a executioncontext and on success set the default arguments">
		<cfargument name="type"       required="true"   type="string"  hint="the contexttype (request|include|mainrequest|empty)">
		<cfargument name="attributes" required="false"  type="struct"  default="#StructNew()#" hint="custom attributes">
		<cfargument name="contentvar" required="false"  type="string"  default=""              hint="variable to use for output">
		<cfargument name="append"     required="false"  type="boolean" default="false"         hint="append the contentvar">
		<cfargument name="template"   required="false"  type="string"  default=""              hint="full mapping-path to template">
		<cfargument name="action"     required="false"  type="string"  default=""              hint="action">
		<cfargument name="parse"      required="false"  type="boolean" default="true"          hint="depending on type, parse action or result for an template immediately">
		
		<cfset var local = StructNew()>
		<cfset local.thisContext = createObject("component", "ebxExecutionContext").init(this, arguments.type)>
		<cfset local.thisContext.setAttributes(arguments.attributes)>
		<cfset local.thisContext.setContentVar(arguments.contentvar)>
		<cfset local.thisContext.setAppend(arguments.append)>
		<cfset local.thisContext.setTemplate(arguments.template)>
		<cfset local.thisContext.setAction(arguments.action, arguments.parse)>
		<cfreturn local.thisContext>
	</cffunction> --->
	
	<cffunction name="parseContext">
		<cfargument name="action"     required="true"  type="string">
		<cfargument name="template"   required="true"  type="string">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#">
		<cfargument name="contentvar" required="false" type="string"  default="">
		<cfargument name="append"     required="false" type="boolean" default="false">
		<cftry>
			<cfreturn variables.cf.parseContext(argumentCollection=arguments)>
			<cfcatch type="any">
				<cfdump var="#cfcatch#"><cfabort>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="setContextFromFactory">
		<cfargument name="type" required="true"  type="string">
		<cfswitch expression="#arguments.type#">
			<cfcase value="include">
				<cfset setThisContext(variables.cf.getIncludeContext())>
			</cfcase>
			<cfcase value="request">
				<cfset setThisContext(variables.cf.getRequestContext())>
			</cfcase>
			<cfcase value="layout">
				<cfset setThisContext(variables.cf.getLayoutContext())>
			</cfcase>
			<cfcase value="mainrequest">
				<cfset setThisContext(variables.cf.getMainRequestContext())>
			</cfcase>
		</cfswitch>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addContextToStack">
		<cfif variables.stack.add(variables.thisContext)>
			<!--- <cfset updateParser()> --->
			<!--- yes --->
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setAttributesFromContext" returntype="any">
		<!--- <cfdump var="#variables.thisContext._dump()#"> --->
		<cfif NOT StructIsEmpty(variables.thisContext.getAttributes())>
			<cfset updateAttributes(variables.thisContext.getAttributes())>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="executeContext" returntype="any">
		<cfset var local = StructNew()>
		<cfset local.template = variables.thisContext.getExecDir() & variables.thisContext.getTemplate()>
		<cfset local.result   = include(local.template)>
		<cfset variables.thisContext.setResult(local.result)>
		<cfreturn NOT variables.thisContext.hasErrors()>
	</cffunction>
	
	<cffunction name="handleContextOutput" returntype="any">
		<cfif variables.thisContext.getContentVar() neq "">
			<cfset assignVariable(variables.thisContext.getContentVar(), variables.thisContext.getOutput(), variables.thisContext.getAppend())>
		<cfelse>
			<cfif variables.cf.isMainRequest(variables.thisContext)>
				<cfset setLayout(variables.thisContext.getOutput())> 
			<cfelse>
				<cfset flushOutput(variables.thisContext.getOutput())>
			</cfif>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="restoreContextAttributes" returntype="any">
		<cfif NOT StructIsEmpty(variables.thisContext.getOriginals())>
			<cfset updateAttributes(variables.thisContext.getOriginals())>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="removeContextFromStack" returntype="any">
		<cfset variables.stack.remove()>
		<cfset updateContext()>
		<!--- <cfset updateParser()> --->
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateParserFromContext">
		<cfargument name="types"   required="false" type="string" default="current,target">
		
		<cfset var local = StructNew()>
		<cfset local.keylist  = ListToArray("action,circuitdir,circuit,rootpath,execdir,act")>
		<cfset local.thislist = ListToArray("thisAction,circuitdir,thisCircuit,rootpath,execdir,act")>
		
		<cfloop list="#arguments.types#" index="local.type">
			<cfswitch expression="#local.type#">
				<cfcase value="current">
					<cfloop from="1" to="#ArrayLen(local.keylist)#" index="local.i">
						<cfset setProperty(local.thislist[local.i], variables.thisContext.get(local.keylist[local.i]))>
					</cfloop>
				</cfcase>
				<cfcase value="target,original">
					<cfloop from="1" to="#ArrayLen(local.keylist)#" index="local.i">
						<cfset setProperty(local.type & local.keylist[local.i], variables.thisContext.get(local.keylist[local.i]))>
					</cfloop>
				</cfcase>
			</cfswitch>
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getExecutedStack" returntype="array">
		<cfreturn variables.stack.getExecutedStack()>
	</cffunction>
	
	<cffunction name="getContextFromFactory" returntype="ebxContext">
		<cfreturn variables.cf.getContext()>
	</cffunction>
	
	<cffunction name="updateAttributes" returntype="any">
		<cfargument name="attributes" type="struct" required="true" default="#StructNew()#">
		<cfset var local  = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfset StructAppend(local.attr, arguments.attributes, TRUE)>
		<cfreturn setAttributes(local.attr)> 
		<!--- --->
	</cffunction>
	
	<!--- <cffunction name="executeInclude">
		<cfif NOT maxRequestsReached()>
			<cfif variables.cf.parseContext(
				  action="internal.circuit.include"
				, template=arguments.template
				, attributes=arguments.attributes
				, contentvar=arguments.contentvar
				, append=arguments.append
				)>
				<cfset setThisContext(variables.cf.getIncludeContext())>
				<!--- <cfreturn variables.evt.OnExecuteStackContext()> --->
			</cfif>	
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="executeRequest">
		<cfif NOT maxRequestsReached()>
			<cfif variables.cf.parseContext(
				  action=arguments.action
				, template=getParameter("switchfile")
				, attributes=arguments.attributes
				, contentvar=arguments.contentvar
				, append=arguments.append
				)>
				<cfset setThisContext(variables.cf.getIncludeContext())>
				<!--- <cfreturn variables.evt.OnExecuteStackContext()> --->
			</cfif>
		</cfif>
		<cfreturn false>
	</cffunction>
	 --->
	
	<cffunction name="getInternal" returntype="string">
		<cfargument name="action"     required="false"  type="string"  default=""              hint="action">
		<cfreturn variables.ebx.getInternal(arguments.action)>
	</cffunction>
	
	<cffunction name="getMainAction">
		<cfreturn getAttribute(getParameter("actionvar"), getParameter("defaultact"))>
	</cffunction>
	<!--- 
	<cffunction name="getContextAction" returntype="any">
		<cfreturn variables.thisContext.getAction()>
	</cffunction>
	
	<cffunction name="getContextAppend" returntype="any">
		<cfreturn variables.thisContext.getAppend()>
	</cffunction>
	
	<cffunction name="getContextAttributes">
		<cfreturn variables.thisContext.getAttributes()>
	</cffunction>

	<cffunction name="getContextCaught">
		<cfreturn  variables.thisContext.getCaught()>
	</cffunction>
	
	<cffunction name="getContextErrors">
		<cfreturn  variables.thisContext.getErrors()>
	</cffunction>
	
	<cffunction name="getContextOriginals">
		<cfreturn variables.thisContext.getOriginals()>
	</cffunction>
	
	<cffunction name="getContextOutput" returntype="any">
		<cfreturn variables.thisContext.getOutput()>
	</cffunction>
	
	<cffunction name="getContextRequest" returntype="any">
		<cfreturn variables.thisContext.getRequest()>
	</cffunction>

	<cffunction name="getContextResult">
		<cfreturn  variables.thisContext.getResult()>
	</cffunction>
	
	<cffunction name="getContextTemplate" returntype="any">
		<cfreturn variables.thisContext.getTemplate()>
	</cffunction>
	
	<cffunction name="getContextType" returntype="any">
		<cfreturn variables.thisContext.getType()>
	</cffunction>
	
	<cffunction name="getContextString">
		<cfreturn "#getContextType()# / #getContextTemplate()# / #getContextAction()#">
	</cffunction>
	
	<cffunction name="getContextVar" returntype="any">
		<cfreturn variables.thisContext.getContentVar()>
	</cffunction>
	
	<cffunction name="getCurrentContext" returntype="any">
		<cfreturn variables.thisContext>
	</cffunction>
	
	<cffunction name="isEmptyContext">
		<cfreturn variables.thisContext.isEmptyContext()>
	</cffunction>
	
	<cffunction name="isContextInclude">
		<cfreturn variables.thisContext.isInclude()>
	</cffunction>
	
	<cffunction name="isContextRequest">
		<cfreturn variables.thisContext.isRequest()>
	</cffunction>
	
	<cffunction name="isLayoutRequest">
		<cfreturn variables.thisContext.isLayoutRequest()>
	</cffunction>

	<cffunction name="isMainContextRequest">
		<cfreturn variables.thisContext.isMainRequest()>
	</cffunction> --->
	
	<!--- <cffunction name="setContextTemplate" returntype="any">
		<cfargument name="template" type="string" required="true">
		<cfreturn variables.thisContext.setTemplate(arguments.template)>
	</cffunction>
	
	<cffunction name="setEmptyContext" returntype="boolean">
		<cfreturn setThisContext(getEmptyContext())>
	</cffunction>
	
	<cffunction name="setContextResult" returntype="any">
		<cfreturn variables.thisContext.setResult(include(getContextTemplate()))>
	</cffunction> --->
	
	<cffunction name="updateContext" returntype="boolean">
		<cfset variables.thisContext = variables.stack.getCurrent()>
		<cfreturn true>
	</cffunction>
	
	<!--- <cffunction name="hasContextErrors">
		<cfreturn  variables.thisContext.hasErrors()>
	</cffunction> --->
	
	<!--- Interfaces --->
	<cffunction name="getParser" returntype="ebxParser">
		<cfreturn variables.Parser>
	</cffunction>
	
	<cffunction name="getEbxPageContext" returntype="ebxPageContext">
		<cfreturn variables.pc>
	</cffunction>
	
	<cffunction name="getEventInterface" returntype="ebxEvents">
		<cfreturn variables.evt>
	</cffunction>
	
	<cffunction name="getStackInterface" returntype="ebxExecutionStack">
		<cfreturn variables.stack>
	</cffunction>
	
	<cffunction name="getEmptyContext" returntype="ebxExecutionContext">
		<cfreturn variables.emptyContext>
	</cffunction>
	
	<!--- Path related --->
	<cffunction name="getAppPath">
		<cfreturn variables.ebx.getAppPath()>
	</cffunction>
	
	<cffunction name="getFilePath">
		<cfargument name="name" type="string" required="true">
		<cfargument name="parseAppPath"  type="boolean" required="false" default="true">
		<cfargument name="parseCircPath" type="boolean" required="false" default="true">
		
		<cfif arguments.parseCircPath>
			<cfset arguments.name = variables.Parser.getProperty("circuitdir") & arguments.name>
		</cfif>
		<cfif arguments.parseAppPath>
			<cfset arguments.name = getAppPath() & arguments.name>
		</cfif>
		<cfreturn arguments.name>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.hasCircuit(arguments.name)>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.getCircuitDir(arguments.name)>
	</cffunction>
	
	<cffunction name="setLayout" returntype="boolean">
		<cfargument name="layout" type="string" required="true">
		<cfreturn variables.Parser.setLayout(arguments.layout)>
	</cffunction>
	
	<!--- <cffunction name="getLayoutPath">
		<cfif variables.Parser.hasLayoutPath()>
			<cfreturn getFilePath(variables.Parser.getProperty("layoutpath"), true, false)>
		<cfelse>
			<cfreturn "">		
		</cfif>
	</cffunction>
	
	<cffunction name="getSettingsFile">
		<cfreturn getFilePath(getParameter("settingsfile"))>
	</cffunction>
	
	<cffunction name="getSwitchFile">
		<cfreturn getFilePath(getParameter("switchfile"))>
	</cffunction>
	
	<cffunction name="getLayoutsFile">
		<cfreturn getFilePath(getParameter("layoutsfile"), true, false)>
	</cffunction>
	
	<cffunction name="setLayout" returntype="boolean">
		<cfargument name="layout" type="string" required="true">
		<cfreturn variables.Parser.setLayout(arguments.layout)>
	</cffunction>
	
	<cffunction name="setLayoutPath">
		<cfreturn variables.Parser.setLayoutPath()>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.hasCircuit(arguments.name)>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.getCircuitDir(arguments.name)>
	</cffunction>
	
	<cffunction name="hasLayoutPath">
		<cfreturn variables.Parser.hasLayoutPath()>
	</cffunction>
	
	<cffunction name="parseLayout" returntype="boolean">
		<cfreturn NOT variables.Parser.getProperty("nolayout")>
	</cffunction> --->
	
	<cffunction name="getParameter" returntype="any">
		<cfargument name="name"  type="string" required="true">
		<cfreturn variables.Parser.getParameter(arguments.name)>
	</cffunction>
	
	<cffunction name="getProperty" returntype="any">
		<cfargument name="key"     type="string" required="true">
		<cfargument name="default" type="any"    required="false" default="">
		<cfreturn variables.Parser.getProperty(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="setProperty" returntype="boolean" access="public" hint="returns true on success otherwise false">
		<cfargument name="key"       required="true"  type="string"  hint="key to update">
		<cfargument name="value"     required="false" type="any"     default="" hint="value for the key">
		<cfreturn variables.Parser.setProperty(arguments.key, arguments.value)>
	</cffunction>
	
	<!--- Parser I/O
	<cffunction name="updateParser" returntype="boolean">
		<cfif isContextRequest()>
			<cfset variables.Parser.setCurrentRequest(getContextRequest())>
			<cfset variables.Parser.setTargetRequest(getContextRequest())>
			<cfif isMainContextRequest()>
				<cfset variables.Parser.setOriginalRequest(getContextRequest())>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getTicks" returntype="any">
		<cfreturn variables.qticks>
	</cffunction> --->
		
	<!--- Attributes --->
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
	
	<cffunction name="getAttributes" returntype="struct">
		<cfreturn getVar("attributes", StructNew())>
	</cffunction>
	
	<cffunction name="setAttributes" returntype="any">
		<cfargument name="attribs" type="struct" required="true">
		<cfreturn getEbxPageContext().ebx_put("attributes", arguments.attribs)>
	</cffunction>
	
	<cffunction name="hasAttribute" returntype="any">
		<cfargument name="name"       type="string" required="true">
		<cfargument name="attributes" type="struct" required="false" default="#getAttributes()#">
		
		<cfreturn StructKeyExists(arguments.attributes, arguments.name)>
	</cffunction>

	<!--- 
	<cffunction name="restoreAttributes" returntype="any">
		<cfif NOT StructIsEmpty(getContextOriginals())>
			<cfset updateAttributes(getContextOriginals())>
			<cfset tick("ATTRIBUTES RESTORED")>
		</cfif>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="updateAttributes" returntype="any">
		<cfargument name="attributes" type="struct" required="true" default="#StructNew()#">
		<cfset var local  = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfset StructAppend(local.attr, arguments.attributes, TRUE)>
		<cfreturn setAttributes(local.attr)> 
		<!--- --->
	</cffunction>
	
	<cffunction name="customizeAttributes" returntype="any">
		<cfif NOT StructIsEmpty(getContextAttributes())>
			<cfset updateAttributes(getContextAttributes())>
			<cfset tick("ATTRIBUTES CUSTOMIZED")>
		</cfif>
		<cfreturn true>
	</cffunction> --->
	
	
	
	<!--- Phases
	<cffunction name="execPhaseList" returntype="boolean">
		<cfargument name="phaselist" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.result = false>
		
		<cfloop list="#arguments.phaselist#" index="local.phase">
			<cfset local.result = variables.phi.execPhase(local.phase)>
			<cfif NOT local.result>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="setPhase" returntype="boolean">
		<cfargument name="phase" type="string" required="true">
		<cfset variables.Parser.setPhase(phase)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setState" returntype="boolean">
		<cfargument name="state" type="string" required="true">
		<cfset variables.Parser.setState(state)>
		<cfreturn true>
	</cffunction> --->
	
	
	<!--- <cffunction name="tick" returntype="any">
		<cfargument name="label" type="string" required="false" default="">
		<cfset var local = StructNew()>
		
		<!--- <cfset local.currtick = getTickCount()>
		
		<cfset QueryAddRow(variables.qticks)>
		<cfset QuerySetCell(variables.qticks,"a_LASTEXEC",local.currtick-variables.lastTick)>
		<cfset QuerySetCell(variables.qticks,"a_TOTAL",local.currtick-variables.tickStart)>
		<cfset QuerySetCell(variables.qticks,"LABEL",arguments.label)>
		<cfset QuerySetCell(variables.qticks,"RCTX",getContextString())>
		
		<cfsavecontent variable="local.tickmsg">
			<cfoutput><cfif arguments.label neq "">#arguments.label#:</cfif>#local.currtick-variables.lastTick#ms | #local.currtick-variables.tickStart#ms</cfoutput>
		</cfsavecontent>
		<cfset ArrayAppend(variables.ticks, local.tickmsg)>
		<cfset variables.lastTick = local.currtick>
		<cfset QuerySetCell(variables.qticks,"TC",getTickCount()-local.currtick)> --->
		<cfreturn true>
	</cffunction> --->
	
	
	<cffunction name="appendVariable">
		<cfargument name="orginal" required="true" type="any" hint="pagevariable to set">
		<cfargument name="value"   required="true" type="any"  hint="value to use">
		
		<cfset var local     = StructNew()>
		<cfset local.currval = arguments.orginal>
		
		<cfif IsSimpleValue(local.currval) AND local.currval eq "">
			<!--- bail out immediately if append isn't needed --->
			<cfset local.currval = arguments.value>
		<cfelseif IsSimpleValue(local.currval) AND IsSimpleValue(arguments.value)>
			<!--- string concatenation if both are string --->
			<cfset local.currval = local.currval & 	arguments.value>
		<cfelseif IsArray(local.currval)>
			<!--- ArrayAppend on array --->
			<!--- TODO: 
					Add [[AND NOT IsArray(arguments.value)]] so that we can concat both arrays; 
					But is this actually nice behaviour? 
			--->
			<cfset ArrayAppend(local.currval, arguments.value)>
		<cfelseif IsStruct(local.currval) AND IsStruct(arguments.value)>
			<!--- Merge structs if both are structs --->
			<cfset StructAppend(local.currval, arguments.value, true)>
		<cfelseif IsQuery(local.currval) AND IsStruct(arguments.value)>
			<!--- Add query row based on struct; this is a bit experimental --->
			<cfset local.cols  = local.currval.columnlist>
			<cfset local.recs  = local.currval.recordcount>
			<cfset local.valid = false>
			<cfset QueryAddRow(local.currval)>
			<cfloop list="#StructKeyList(arguments.value)#" index="local.item">
				<cfset local.testval = arguments.value[local.item]>
				<cfif ListFind(local.cols, local.item)>
					<cfset QuerySetCell(local.currval, local.item, local.testval)>
					<cfset local.valid = true>
				<cfelseif IsArray(local.testval) AND ArrayLen(local.testval) eq local.recs>
					<cfset QueryAddColumn(local.currval, local.item, local.testval)>
					<cfset local.valid = true>
				</cfif>
			</cfloop>
			<cfif NOT local.valid>
				<cfset local.currval.removeRows(JavaCast( "int", local.recs ),JavaCast( "int", 1 ))>
			</cfif>
		</cfif>
		<cfreturn local.currval>
	</cffunction>
	
</cfcomponent>