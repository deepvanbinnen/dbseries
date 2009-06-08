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
	
	<cffunction name="maxRequestsReached" returntype="boolean">
		<cfreturn getStackInterface().maxReached()>
	</cffunction>
	
	 <cffunction name="setThisContext" returntype="boolean">
		<cfargument name="context" type="any" required="true">
		<cfset variables.thisContext = arguments.context>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getCurrentContext" returntype="ebxContext">
		<cfreturn variables.thisContext>
	</cffunction>
	
<!--- 	<cffunction name="parseContext">
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
	</cffunction> --->
	
	<cffunction name="createContext">
		<cfargument name="type"     required="true"  type="string">
		<cfargument name="action"     required="true"  type="string">
		<cfargument name="template"   required="true"  type="string">
		<!--- <cfargument name="circuitdir" required="false" type="string" default=""> --->
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#">
		<cfargument name="contentvar" required="false" type="string"  default="">
		<cfargument name="append"     required="false" type="boolean" default="false">
		
		<cfset var local = StructNew()>
		<cfset local.req = getParsedAction(arguments.action)>
		<cfif NOT StructIsEmpty(local.req)>
			<cfset StructDelete(arguments, "action")>
			<cfset StructAppend(local.req, arguments)>
			<cfset variables.cf.createContext(argumentCollection=local.req)>
			<cfset setContextFromFactory(arguments.type)>
			<cfset addContextToStack()>
			<cfset updateParserFromContext()>
			<cfset setAttributesFromContext()>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getParsedAction">
		<cfargument name="action"     required="true"  type="string">
		
		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		
		<cfif ListLen(arguments.action, ".") eq 3 AND hasInternal(arguments.action)>
			<cfset local.result.action  = arguments.action>
			<cfset local.result.circuitdir = getInternalExecDir(arguments.action)>
		<cfelseif ListLen(arguments.action, ".") eq 2 AND hasCircuit(ListFirst(arguments.action, "."))>
			<cfset local.result.action  = arguments.action>
			<cfset local.result.circuitdir = getCircuitExecDir(ListFirst(arguments.action, "."))>
		<cfelseif ListLen(arguments.action, ".") eq 1 AND getProperty("thisCircuit") neq "">
			<cfset local.result.action    = getProperty("thisCircuit") & "." & arguments.action>
			<cfset local.result.circuitdir = getProperty("circuitdir")>
		</cfif>
		
		<cfreturn local.result>
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
			<cfcase value="plugin">
				<cfset setThisContext(variables.cf.getPluginContext())>
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
	
	<cffunction name="getInternal" returntype="string">
		<cfargument name="action"     required="false"  type="string"  default=""              hint="action">
		<cfreturn variables.ebx.getInternal(arguments.action)>
	</cffunction>
	
	<cffunction name="hasInternal" returntype="string">
		<cfargument name="action"     required="false"  type="string"  default=""              hint="action">
		<cfreturn variables.ebx.hasInternal(ListLast(arguments.action, '.'))>
	</cffunction>
	
	<cffunction name="getMainAction">
		<cfreturn getAttribute(getParameter("actionvar"), getParameter("defaultact"))>
	</cffunction>
	
	<cffunction name="updateContext" returntype="boolean">
		<cfset variables.thisContext = variables.stack.getCurrent()>
		<cfreturn true>
	</cffunction>
	
	<!--- Interfaces --->
	<cffunction name="getParser" returntype="ebxParser">
		<cfreturn variables.Parser>
	</cffunction>
	
	<cffunction name="getEbxPageContext" returntype="ebxPageContext">
		<cfreturn variables.pc>
	</cffunction>
	
	<cffunction name="getStackInterface" returntype="ebxExecutionStack">
		<cfreturn variables.stack>
	</cffunction>
	
	<!--- Path related --->
	<cffunction name="getInternalExecDir">
		<cfargument name="action" type="string" required="true">
		<cfset var local = StructNew()>
		
		<cfset local.pathvar = getInternal(ListLast(arguments.action, "."))>
		<cfif local.pathvar neq "">
			<cfreturn getProperty(local.pathvar)>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getCircuitExecDir">
		<cfargument name="circuit" type="string" required="true">
		<cfreturn variables.ebx.getCircuitDir(arguments.circuit)>
	</cffunction>
	
	
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