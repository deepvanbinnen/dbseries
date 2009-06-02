<cfcomponent>
	<cfset variables.ebx          = "">
	<cfset variables.Parser       = "">
	<cfset variables.thisContext  = "">

	<cffunction name="init" returntype="ebxParserInterface">
		<cfargument name="ebxParser"  type="ebxParser" required="true">
		<cfargument name="attributes" type="struct"    required="false" default="#StructNew()#">
		
		<cfset variables.Parser = arguments.ebxParser>
		<cfset variables.ebx    = variables.Parser.getEbx()>
		
		<cfset variables.pc    = createObject("component", "ebxPageContext")>
		<cfset variables.stack = createObject("component", "ebxExecutionStack").init(createContext("empty"))>
		<cfset variables.evt   = createObject("component", "ebxEvents").init(this)>
		
		<cfset setAttributes(arguments.attributes)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="appendStack" returntype="any">
		<cfreturn variables.stack.add(variables.thisContext)>
	</cffunction>
	
	<cffunction name="assignVariable" hint="assign output (mostly from an executioncontext result) to content var or else flush it to the page">
		<cfargument name="contentvar" required="true" type="string" hint="pagevariable to set">
		<cfargument name="value"        required="true" type="any"  hint="value to use">
		<cfargument name="append"       required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var local = StructNew()>
		<cfif arguments.append>
			<cfset local.currval = getVar(arguments.contentvar)>
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
		<cfelse>
			<cfset local.currval = arguments.value>
		</cfif>
		
		<cfset getEbxPageContext().ebx_put(arguments.contentvar, local.currval)>
		
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
	</cffunction>
	
	<cffunction name="flushOutput" returntype="boolean">
		<cfargument name="output" type="string" required="true">
		<cfset getEbxPageContext().ebx_write(arguments.output)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getAppPath">
		<cfreturn variables.ebx.getAppPath()>
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
	
	<cffunction name="getAttributes" returntype="struct">
		<cfreturn getVar("attributes", StructNew())>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.getCircuitDir(arguments.name)>
	</cffunction>
	
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
	
	<cffunction name="getContextVar" returntype="any">
		<cfreturn variables.thisContext.getContentVar()>
	</cffunction>
	
	<cffunction name="getCurrentContext" returntype="ebxExecutionContext">
		<cfreturn variables.thisContext>
	</cffunction>
	
	<cffunction name="getEbxPageContext" returntype="ebxPageContext">
		<cfreturn variables.pc>
	</cffunction>
	
	<cffunction name="getEmptyContext" returntype="ebxExecutionContext">
		<cfreturn variables.emptyContext>
	</cffunction>
	
	<cffunction name="getEventInterface" returntype="ebxEvents">
		<cfreturn variables.evt>
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
	
	<cffunction name="getLayout">
		<cfreturn getFilePath(variables.Parser.getProperty("layoutdir") & variables.Parser.getProperty("layoutfile"), true, false)>
	</cffunction>
	
	<cffunction name="getLayoutsFile">
		<cfreturn getFilePath(getParameter("layoutsfile"), true, false)>
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
	
	<cffunction name="getProperty" returntype="any">
		<cfargument name="key"     type="string" required="true">
		<cfargument name="default" type="any"    required="false" default="">
		<cfreturn variables.Parser.getProperty(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="getSettingsFile">
		<cfreturn getFilePath(getParameter("settingsfile"))>
	</cffunction>
	
	<cffunction name="getStackInterface" returntype="ebxExecutionStack">
		<cfreturn variables.stack>
	</cffunction>
	
	<cffunction name="getSwitchFile">
		<cfreturn getFilePath(getParameter("switchfile"))>
	</cffunction>
		
	<cffunction name="getVar" returntype="any">
		<cfargument name="name"  type="string" required="true">
		<cfargument name="value" type="any"    required="false" default="">
		<cfreturn getEbxPageContext().ebx_get(arguments.name, arguments.value)>
	</cffunction>
	
	<cffunction name="hasAttribute" returntype="any">
		<cfargument name="name"       type="string" required="true">
		<cfargument name="attributes" type="struct" required="false" default="#getAttributes()#">
		
		<cfreturn StructKeyExists(arguments.attributes, arguments.name)>
	</cffunction>

	<cffunction name="hasContextErrors">
		<cfreturn  variables.thisContext.hasErrors()>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" type="string" required="true">
		<cfreturn variables.ebx.hasCircuit(arguments.name)>
	</cffunction>

	<cffunction name="include" returntype="struct">
		<cfargument name="template"      type="string" required="true">
		<cfreturn getEbxPageContext().ebx_include(arguments.template)>
	</cffunction>
	
	<cffunction name="isContextInclude">
		<cfreturn variables.thisContext.isInclude()>
	</cffunction>
	
	<cffunction name="isContextRequest">
		<cfreturn variables.thisContext.isRequest()>
	</cffunction>

	<cffunction name="isMainContextRequest">
		<cfreturn variables.thisContext.isMainRequest()>
	</cffunction>
	
	<cffunction name="maxRequestsReached" returntype="boolean">
		<cfreturn getStackInterface().maxReached()>
	</cffunction>
	
	<cffunction name="parseLayout" returntype="boolean">
		<cfreturn NOT variables.Parser.getProperty("nolayout")>
	</cffunction>
	
	<cffunction name="setAttributes" returntype="any">
		<cfargument name="attribs" type="struct" required="true">
		<cfreturn getEbxPageContext().ebx_put("attributes", arguments.attribs)>
	</cffunction>
	
	<cffunction name="setContextTemplate" returntype="any">
		<cfargument name="template" type="string" required="true">
		<cfreturn variables.thisContext.setTemplate(arguments.template)>
	</cffunction>
	
	<cffunction name="setEmptyContext" returntype="boolean">
		<cfreturn setThisContext(getEmptyContext())>
	</cffunction>
	
	<cffunction name="setLayout" returntype="boolean">
		<cfargument name="layout" type="string" required="true">
		<cfreturn variables.Parser.setLayout(arguments.layout)>
	</cffunction>
	
	<cffunction name="setThisContext" returntype="boolean">
		<cfargument name="context" type="ebxExecutionContext" required="true">
		<cfset variables.thisContext = arguments.context>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateAttributes" returntype="any">
		<cfargument name="attributes" type="struct" required="true" default="#StructNew()#">
		
		<cfset var local  = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfset StructAppend(local.attr, arguments.attributes, TRUE)>
		<cfreturn setAttributes(local.attr)>
	</cffunction>	
	
	<cffunction name="updateContext" returntype="boolean">
		<cfset setThisContext(variables.stack.getCurrent())>
		<cfreturn true>
	</cffunction>
				
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
	
	<cffunction name="updateStack" returntype="any">
		<cfset variables.stack.remove()>
		<cfset updateContext()>
		<cfset updateParser()>
		<cfreturn true>
	</cffunction>
	
</cfcomponent>