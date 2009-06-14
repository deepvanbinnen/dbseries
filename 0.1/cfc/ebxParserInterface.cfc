<!--- 
Copyright 2009 Bharat Deepak Bhikharie

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

<!--- 
Filename: ebxParserInterface.cfc
Date: Mon Jun 15 00:10:04 CEST 2009
Author: Bharat Deepak Bhikharie
Project info: http://code.google.com/p/dbseries/wiki/ebx
--->

<cfcomponent>
	<cfset variables.ebx          = "">
	<cfset variables.Parser       = "">
	<cfset variables.thisContext  = "">


	<cffunction name="init" returntype="ebxParserInterface" hint="initialise controller">
		<cfargument name="ebxParser"  type="ebxParser" required="true" hint="parser instance">
		<cfargument name="attributes" type="struct"    required="false" default="#StructNew()#" hint="parser initial attributes">
		
		<cfset variables.Parser = arguments.ebxParser>
		<cfset variables.ebx    = variables.Parser.getEbx()>
		
		<cfset variables.pc    = createObject("component", "ebxPageContext")>
		<cfset variables.cf    = createObject("component", "ebxContextFactory").init(this)>
		<cfset variables.stack = createObject("component", "ebxExecutionStack").init(variables.cf.getEmptyContext())>
		<cfset setAttributes(arguments.attributes)>
		
		<cfreturn this>
	</cffunction>
	
	<!--- Pagecontext --->
	<cffunction name="include" returntype="struct" hint="include template in the page en return result">
		<cfargument name="template"      type="string" required="true" hint="full mapping path to include template">
		<cfreturn getEbxPageContext().ebx_include(arguments.template)>
	</cffunction>
	
	<cffunction name="flushOutput" returntype="boolean" hint="write output to the page. Always return true">
		<cfargument name="output" type="string" required="true" hint="string to write">
		<cfset getEbxPageContext().ebx_write(arguments.output)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="assignVariable" returntype="boolean" hint="handles append and assigns value to content var">
		<cfargument name="contentvar" required="true" type="string" hint="pagevariable to set">
		<cfargument name="value"      required="true" type="any"  hint="value to use">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="append contentvar value or overwrite">
		
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
		<cfargument name="name"  type="string" required="true" hint="variable name">
		<cfargument name="value" type="any"    required="false" default="" hint="default value to return if variable does not exist">
		<cfreturn getEbxPageContext().ebx_get(arguments.name, arguments.value)>
	</cffunction>
	
	<cffunction name="maxRequestsReached" returntype="boolean" hint="check if maximum requests in the stack is reached.">
		<cfreturn getStackInterface().maxReached()>
	</cffunction>
	
	 <cffunction name="setThisContext" returntype="boolean" hint="set active context">
		<cfargument name="context" type="any" required="true" hint="context instance to set active context to">
		<cfset variables.thisContext = arguments.context>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getCurrentContext" returntype="ebxContext" hint="get active context">
		<cfreturn variables.thisContext>
	</cffunction>

	<cffunction name="createContext" returntype="boolean" hint="create context from arguments and update stack and parser on success. Return true on successfull context creation">
		<cfargument name="type"       required="true"  type="string" hint="context type">
		<cfargument name="action"     required="true"  type="string" hint="action to be parsed">
		<cfargument name="template"   required="true"  type="string" hint="context-template">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="custom attributes">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="contentvariable to store result output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="append contentvar or overwrite">
		
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
	
	<cffunction name="getParsedAction" returntype="struct" hint="return parsed fuseaction as struct with action and circuitdir">
		<cfargument name="action"  required="true"  type="string" hint="action to be parsed">
		
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
	
	<cffunction name="setContextFromFactory" returntype="any" hint="set active context based on type??">
		<cfargument name="type" required="true"  type="string" hint="type to create">
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
	
	<cffunction name="addContextToStack" hint="add active context to stack">
		<cfif variables.stack.add(variables.thisContext)>
			<!--- <cfset updateParser()> --->
			<!--- yes --->
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setAttributesFromContext" returntype="any" hint="update page attributes with active context">
		<cfif NOT StructIsEmpty(variables.thisContext.getAttributes())>
			<cfset updateAttributes(variables.thisContext.getAttributes())>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="executeContext" returntype="boolean" hint="include context-template and set result in context. Return true if result does not contain errors">
		<cfset var local = StructNew()>
		<cfset local.template = variables.thisContext.getExecDir() & variables.thisContext.getTemplate()>
		<cfset local.result   = include(local.template)>
		<cfset variables.thisContext.setResult(local.result)>
		<cfreturn NOT variables.thisContext.hasErrors()>
	</cffunction>
	
	<cffunction name="handleContextOutput" returntype="any" hint="process result: assign content-variable or parser-layout otherwise write result output">
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
	
	<cffunction name="restoreContextAttributes" returntype="any" hint="restore page-attributes from active-context">
		<cfif NOT StructIsEmpty(variables.thisContext.getOriginals())>
			<cfset updateAttributes(variables.thisContext.getOriginals())>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="removeContextFromStack" returntype="any" hint="remove context from stack and update active context">
		<cfset variables.stack.remove()>
		<cfset updateContext()>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateParserFromContext" returntype="any" hint="update parser settings from active context">
		<cfargument name="types"   required="false" type="string" default="current,target" hint="parser context scopes can be current target or original">
		
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
	
	<cffunction name="getExecutedStack" returntype="array" hint="return array with executed contexts from stack">
		<cfreturn variables.stack.getExecutedStack()>
	</cffunction>
	
	<cffunction name="getContextFromFactory" returntype="ebxContext" hint="return current-context from factory">
		<cfreturn variables.cf.getContext()>
	</cffunction>
	
	<cffunction name="updateAttributes" returntype="any" hint="merge page-attributes with given attributes, always overwrites existing attributes">
		<cfargument name="attributes" type="struct" required="true" default="#StructNew()#" hint="struct with new attributes values">
		<cfset var local  = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfset StructAppend(local.attr, arguments.attributes, TRUE)>
		<cfreturn setAttributes(local.attr)> 
		<!--- --->
	</cffunction>
	
	<cffunction name="getInternal" returntype="string" hint="return internal circuit from ebx">
		<cfargument name="action" required="false"  type="string"  default="" hint="internal action">
		<cfreturn variables.ebx.getInternal(arguments.action)>
	</cffunction>
	
	<cffunction name="hasInternal" returntype="boolean" hint="return check for internal circuit from ebx">
		<cfargument name="action"  required="false"  type="string"  default="" hint="action">
		<cfreturn variables.ebx.hasInternal(ListLast(arguments.action, '.'))>
	</cffunction>
	
	<cffunction name="getMainAction" returntype="string" hint="if page-attribute action exists return it, otherwise return default act">
		<cfreturn getAttribute(getParameter("actionvar"), getParameter("defaultact"))>
	</cffunction>
	
	<cffunction name="updateContext" returntype="boolean" hint="set active-context from stack">
		<cfset variables.thisContext = variables.stack.getCurrent()>
		<cfreturn true>
	</cffunction>
	
	<!--- Interfaces --->
	<cffunction name="getParser" returntype="ebxParser" hint="return the parser">
		<cfreturn variables.Parser>
	</cffunction>
	
	<cffunction name="getEbxPageContext" returntype="ebxPageContext" hint="return the pagecontext">
		<cfreturn variables.pc>
	</cffunction>
	
	<cffunction name="getStackInterface" returntype="ebxExecutionStack" hint="return the stack">
		<cfreturn variables.stack>
	</cffunction>
	
	<!--- Path related --->
	<cffunction name="getInternalExecDir" returntype="string" hint="get (path)value from parser-property for a property read from the internal circuit definition">
		<cfargument name="action" type="string" required="true" hint="full qualified internal action">
		<cfset var local = StructNew()>
		
		<cfset local.pathvar = getInternal(ListLast(arguments.action, "."))>
		<cfif local.pathvar neq "">
			<cfreturn getProperty(local.pathvar)>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getCircuitExecDir" returntype="string" hint="return circuitpath for circuit from ebx">
		<cfargument name="circuit" type="string" required="true" hint="circuit name">
		<cfreturn variables.ebx.getCircuit(arguments.circuit)>
	</cffunction>
	
	
	<cffunction name="getAppPath" returntype="string" hint="return application path from ebx">
		<cfreturn variables.ebx.getAppPath()>
	</cffunction>
	
	<cffunction name="getFilePath" returntype="string" hint="return mapping path for template based on application and current circuit, which can be disbled">
		<cfargument name="name" type="string" required="true" hint="template name">
		<cfargument name="parseAppPath"  type="boolean" required="false" default="true" hint="prepend template with application path">
		<cfargument name="parseCircPath" type="boolean" required="false" default="true" hint="prepend template with current circuit path">
		
		<cfif arguments.parseCircPath>
			<cfset arguments.name = variables.Parser.getProperty("circuitdir") & arguments.name>
		</cfif>
		<cfif arguments.parseAppPath>
			<cfset arguments.name = getAppPath() & arguments.name>
		</cfif>
		<cfreturn arguments.name>
	</cffunction>
	
	<cffunction name="hasCircuit" returntype="boolean" hint="validate circuit in ebx">
		<cfargument name="name" type="string" required="true" hint="circuit name">
		<cfreturn variables.ebx.hasCircuit(arguments.name)>
	</cffunction>
	
	<cffunction name="setLayout" returntype="boolean" hint="set parser's layout property">
		<cfargument name="layout" type="string" required="true" hint="main context result output">
		<cfreturn variables.Parser.setLayout(arguments.layout)>
	</cffunction>
	
	<cffunction name="getParameter" returntype="any" hint="get ebx parameter from parser">
		<cfargument name="name"  type="string" required="true" hint="parameter name">
		<cfreturn variables.Parser.getParameter(arguments.name)>
	</cffunction>
	
	<cffunction name="getProperty" returntype="any" hint="get parser property">
		<cfargument name="key"     type="string" required="true" hint="property name">
		<cfargument name="default" type="any"    required="false" default="" hint="value if unexistant">
		<cfreturn variables.Parser.getProperty(argumentCollection=arguments)>
	</cffunction>
	
	<cffunction name="setProperty" returntype="boolean" access="public" hint="set parser property. Return true on success.">
		<cfargument name="key"       required="true"  type="string"  hint="key to update">
		<cfargument name="value"     required="false" type="any"     default="" hint="value for the key">
		<cfreturn variables.Parser.setProperty(arguments.key, arguments.value)>
	</cffunction>
	
	<!--- Attributes --->
	<cffunction name="getAttribute" returntype="any" hint="get page-attribute">
		<cfargument name="name"  type="string" required="true" hint="attribute name">
		<cfargument name="value" type="any"    required="false" default="" hint="value if unexistant">
		
		<cfset var local = StructNew()>
		<cfset local.attr = getAttributes()>
		<cfif hasAttribute(arguments.name, local.attr)>
			<cfreturn local.attr[arguments.name]>
		</cfif>
		
		<cfreturn arguments.value>
	</cffunction>
	
	<cffunction name="getAttributes" returntype="struct" hint="get page-attributes">
		<cfreturn getVar("attributes", StructNew())>
	</cffunction>
	
	<cffunction name="setAttributes" returntype="any" hint="set page-attributes">
		<cfargument name="attribs" type="struct" required="true" hint="attribute struct">
		<cfreturn getEbxPageContext().ebx_put("attributes", arguments.attribs)>
	</cffunction>
	
	<cffunction name="hasAttribute" returntype="boolean" hint="check if key exists in attributes.">
		<cfargument name="name"       type="string" required="true" hint="attributes name">
		<cfargument name="attributes" type="struct" required="false" default="#getAttributes()#" hint="scope to search in defaults to page-attributes">
		
		<cfreturn StructKeyExists(arguments.attributes, arguments.name)>
	</cffunction>
	
	<cffunction name="appendVariable" returntype="any" hint="appends value to a variable, append-behaviour differences are based on original's datatype!">
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