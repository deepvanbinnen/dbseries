<cfcomponent name="CFCGenerator">
	<cfset this.name = "">
	
	<cfset variables.utils = createObject("component", "cfc.db.HTML").init()>
	<cfset variables.LDELIM  = CHR(13) & CHR(10)> 
	<cfset variables.LTABDELIM  = variables.LDELIM & CHR(9)> 
	<cfset variables.COLON = 58>
	<cfset variables.templatedir = ExpandPath('.') & "/templates/">
	
	<cfset variables.output = StructNew()>
	<cfset variables.output.scopes  = StructNew()>
	<cfset variables.methods = ArrayNew(1)>
	<cfset variables.output.methods = ArrayNew(1)>
	
	<cffile action="read" file="#variables.templatedir#scoped_var.tpl" variable="variables.tpl_set">
	<cffile action="read" file="#variables.templatedir#local_arg_var.tpl" variable="variables.tpl_local_arg">
	<cffile action="read" file="#variables.templatedir#getter_setter_public.tpl" variable="variables.tpl_getset_public">
	<cffile action="read" file="#variables.templatedir#getter_setter_private.tpl" variable="variables.tpl_getset_private">
	<cffile action="read" file="#variables.templatedir#req_arg.tpl" variable="variables.tpl_req_arg">
	<cffile action="read" file="#variables.templatedir#opt_arg.tpl" variable="variables.tpl_opt_arg">
	<cffile action="read" file="#variables.templatedir#method_public.tpl" variable="variables.tpl_method">
	<cffile action="read" file="#variables.templatedir#component.tpl" variable="variables.tpl_component">
	<cffile action="read" file="#variables.templatedir#exec_setter_public.tpl" variable="variables.tpl_init_setter_public">
	<cffile action="read" file="#variables.templatedir#exec_setter_private.tpl" variable="variables.tpl_init_setter_private">
	<cffile action="read" file="#variables.templatedir#comment_block.tpl" variable="variables.tpl_comment_block">
	<cffile action="read" file="#variables.templatedir#comment_line.tpl" variable="variables.tpl_comment_line">
		
	<cffunction name="init" output="No" returntype="any">
		<cfargument name="name" type="string" required="true">
		<cfset var local = StructNew()>
		<cfset this.name = arguments.name>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getOutput">
		<cfreturn variables.output>
	</cffunction>
	
	<cffunction name="getComponentOutput" output="No">
		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		<cfset local.result.name = getName()>
		<cfset local.result.body = ArrayNew(1)>
		
		<cfset local.thisscope = getScopeOutput("this")>
		<cfset local.variables = getScopeOutput("variables")>
		
		<cfset ArrayAppend(local.result.body, getCommentBlockHeader("CFCGenerator"))>
		<cfset ArrayAppend(local.result.body, emptyLine())>
		<cfset ArrayAppend(local.result.body, getCommentBlockHeader("PUBLIC VARIABLES", "Getters and setters are created at the bottom of the file!"))>
		<cfset ArrayAppend(local.result.body, emptyLine())>
		<cfset ArrayAppend(local.result.body, outputArr(local.thisscope.component_sets))>
		<cfset ArrayAppend(local.result.body, emptyLine())>
		<cfset ArrayAppend(local.result.body, getCommentBlockHeader("PRIVATE VARIABLES", "Getters and setters are created at the bottom of the file!"))>
		<cfset ArrayAppend(local.result.body, outputArr(local.variables.component_sets))>
		<cfset ArrayAppend(local.result.body, emptyLine())>
		<cfset ArrayAppend(local.result.body, getCommentBlockHeader("INIT METHOD"))>
		<cfset ArrayAppend(local.result.body, getInit())>
		<cfset ArrayAppend(local.result.body, emptyLine())>
		<cfset ArrayAppend(local.result.body, getCommentBlockHeader("METHODS"))>
		<cfset ArrayAppend(local.result.body, outputArr(getMethodsOutput(),2))>
		<cfset ArrayAppend(local.result.body, emptyLine())>
		<cfset ArrayAppend(local.result.body, getCommentBlockHeader("PUBLIC GETTER-/SETTERS", "Getters and setters for public variables!"))>
		<cfset ArrayAppend(local.result.body, outputArr(local.thisscope.getter_setter_bodies))>
		<cfset ArrayAppend(local.result.body, emptyLine())>
		<cfset ArrayAppend(local.result.body, getCommentBlockHeader("PRIVATE GETTER-/SETTERS", "Getters and setters for private variables!"))>
		<cfset ArrayAppend(local.result.body, outputArr(local.variables.getter_setter_bodies))>
		
		<cfset local.result.body = variables.strHelp.indent(outputArr(local.result.body), 1).get()>
		<cfset local.result.body = variables.utils.render(local.result, Trim(variables.tpl_component), "name,body")>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getOutputScope" output="no" returntype="struct">
		<cfargument name="scope" type="string" required="true">
		
		<cfset var local   = StructNew()>
		<cfset local.scope = arguments.scope>
		
		<cfif NOT StructKeyExists(variables.output.scopes, local.scope)>
			<cfset variables.output.scopes[local.scope]         = StructNew()>
			<cfset variables.output.scopes[local.scope].keys    = "">
			<cfset variables.output.scopes[local.scope].vars    = ArrayNew(1)>
			<cfset variables.output.scopes[local.scope].getset  = ArrayNew(1)>
			<cfset variables.output.scopes[local.scope].setvars = ArrayNew(1)>
		</cfif>
		
		<cfreturn variables.output.scopes[local.scope]>
	</cffunction>
	
	<cffunction name="setOutputScope" output="no" returntype="void">
		<cfargument name="scope" type="string" required="true">
		<cfargument name="value" type="struct" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.scope = arguments.scope>
		<cfset local.value = arguments.value>
		
		<cfif StructKeyExists(variables.output.scopes, local.scope)>
			<cfset variables.output.scopes[local.scope] = local.value>
		</cfif>
	</cffunction>
	
	<cffunction name="parseScope" output="no" returntype="void">
		<cfargument name="scope"     type="string" required="true">
		<cfargument name="varstring" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.scope     = arguments.scope>
		<cfset local.gscope    = getOutputScope(local.scope)>
		<cfset local.varstring = TRIM(arguments.varstring)>
		<cfset local.scopevars = ArrayNew(1)>
		<cfset local.varit     = variables.utils.iterator(variables.utils.d2a(local.varstring))>
		
		<cfloop condition="#local.varit.whileHasNext()#">
			<cfset local.out_var       = parseParamString(local.varit.current)>
			<cfset local.out_var.uname = variables.utils.firstCap(local.out_var.name).get()>
			<cfset local.out_var.scope = local.scope>
			<cfif ListLen(local.out_var.name, ".") EQ 1>
				<cfswitch expression="#local.scope#">
					<cfcase value="this">
						<cfset ArrayAppend(local.gscope.getset, variables.utils.render(local.out_var, variables.tpl_getset_public, "uname,name,scope,datatype,required"))>
					</cfcase>
					<cfcase value="variables">
						<cfset ArrayAppend(local.gscope.getset, variables.utils.render(local.out_var, variables.tpl_getset_private, "uname,name,scope,datatype,required"))>
					</cfcase>
				</cfswitch>
			</cfif>
			<cfset ArrayAppend(local.gscope.setvars, variables.utils.render(local.out_var, variables.tpl_set, "scope,name,default"))>
			<cfset ArrayAppend(local.gscope.vars, local.out_var)>
			<cfset local.gscope.keys = ListAppend(local.gscope.keys, local.out_var.name)>
		</cfloop>
		
		<cfset setOutputScope(local.scope, local.gscope)>
	</cffunction>
	
	<cffunction name="parseParamString">
		<cfargument name="paramString" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.var_decl = variables.utils.p2s(arguments.paramString, true)>
		<cfset local.out_var  = variables.utils.a2s(variables.utils.d2a(instring=local.var_decl.name, delimiter=CHR(variables.COLON)),"name,datatype")>
		
		<cfset local.out_var["default"]  = local.var_decl.value>
		<cfset local.out_var["required"] = NOT(local.var_decl.ispair)>
		<cfset local.out_var["scope"]    = "">
		
		<cfif ListLen(local.out_var.name,".") gt 1>
			<cfset local.out_var["scope"] = ListDeleteAt(local.out_var.name, ListLen(local.out_var.name, "."), ".")>
		</cfif>
		
		<cfif NOT StructKeyExists(local.out_var, "datatype")>
			<cfset local.out_var["datatype"] = "">
		</cfif>
		
		<cfreturn local.out_var>
	</cffunction>
	
	<cffunction name="getParamString">
		<cfargument name="argVar" required="true" type="struct">
		<cfargument name="parsesetters" required="false" type="boolean" default="true">
		
		<cfset var local = StructNew()>
		<cfset local.argVar       = arguments.argVar>
		<cfset local.parsesetters = arguments.parsesetters>
		
		<cfset local.temp         = StructNew()>
		<cfset local.temp.params  = "">
		<cfset local.temp.private = "">
		<cfset local.temp.public  = "">
		<cfset local.temp.locals  = "">
		
		<cfif local.argvar.required>
			<cfset local.temp.params = variables.utils.render(local.argvar, variables.tpl_req_arg, "name,datatype")>
		<cfelse>
			<cfset local.temp.params = variables.utils.render(local.argvar, variables.tpl_opt_arg, "name,datatype,default")>
		</cfif>
		<cfset local.temp.locals = variables.utils.render(local.argvar, variables.tpl_local_arg, "name")>
		
		<cfif local.parsesetters>
			<cfset local.varstruct = StructNew()>
			<cfset local.varstruct.name = variables.utils.firstCap(local.argvar.name).get()>
			<cfif ListFindNoCase(variables.output.scopes["variables"].keys, local.argvar.name)>
				<cfset local.varstruct.value = "arguments." & local.argvar.name>
				<cfset local.temp.private = variables.utils.render(local.varstruct, variables.tpl_init_setter_private, "name,value")>
			</cfif>
			<cfif ListFindNoCase(variables.output.scopes["this"].keys, local.argvar.name)>
				<cfset local.varstruct.value = "arguments." & local.argvar.name>
				<cfset local.temp.public = variables.utils.render(local.varstruct, variables.tpl_init_setter_public, "name,value")>
			</cfif>	
		</cfif>
		
		<cfreturn local.temp>
	</cffunction>
	
	<cffunction name="parseMethodString">
		<cfargument name="methodString" type="string" required="true">
		<cfset var local = StructNew()>
		<cfset local.method  =  variables.utils.a2s(variables.utils.d2a(TRIM(arguments.methodString)),"name,params,retval")>
		<cfset local.out_var = variables.utils.a2s(variables.utils.d2a(instring=TRIM(local.method.name),delimiter=CHR(COLON)),"name,rettype")>
		<cfset local.out_var["params"] = ArrayNew(1)>
		<cfset local.out_var["args"]   = ArrayNew(1)>
		<cfset local.out_var["locals"] = ArrayNew(1)>
		<cfset local.out_var["private"] = ArrayNew(1)>
		<cfset local.out_var["public"] = ArrayNew(1)>
		<cfset local.paramit = variables.utils.iterator(variables.utils.d2a(TRIM(local.method.params)))>
		<cftry>
			<cfloop condition="#local.paramit.whileHasNext()#">
				<cfset local.param = parseParamString(local.paramit.current)>
				<cfif local.param.datatype eq "">
					<cfset local.param = setParamFromScope(local.param)>
					<cfif local.param.datatype eq "">
						<cfset local.param.datatype = "any">
					</cfif>
				</cfif>
				
				<cfset local.temp = getParamString(local.param)>
				<cfif local.temp.params neq "">
					<cfset ArrayAppend(local.out_var["args"], local.temp.params)>
				</cfif>
				<cfif local.temp.locals neq "">
					<cfset ArrayAppend(local.out_var["locals"], local.temp.locals)>
				</cfif>
				<cfif local.temp.public neq "">
					<cfset ArrayAppend(local.out_var["public"], local.temp.public)>
				</cfif>
				<cfif local.temp.private neq "">
					<cfset ArrayAppend(local.out_var["private"], local.temp.private)>
				</cfif>
				<cfset ArrayAppend(local.out_var["params"], local.param)>
			</cfloop>
			<cfset local.out_var["locals"].addAll(local.out_var["private"])>
			<cfset local.out_var["locals"].addAll(local.out_var["public"])>
			<cfcatch type="any">
				<cfdump var="#cfcatch#">
			
			</cfcatch>
		</cftry>
		
		<cfif NOT StructKeyExists(local.method,"retval")>
			<cfset local.out_var["retval"] = "">
		<cfelse>
			<cfset local.out_var["retval"] = local.method["retval"]>
		</cfif>
		
		<cfreturn local.out_var>
	</cffunction>
	
	<cffunction name="parseConstructorMethod">
		<cfargument name="params" type="string" required="true">
		<cfset var local = StructNew()>
		<cfset local.methodString = "init:#this.name#">
		<cfset local.methodString = ListAppend(local.methodString,arguments.params,CHR(10))>
		<cfset local.methodString = ListAppend(local.methodString,"this",CHR(10))>
		<cfset local.method        = variables.utils.a2s(variables.utils.d2a(TRIM(local.methodString)),"name,params,retval")>
		<cfset local.method        = parseMethodString(local.methodString)>
		<cfset local.method.locals = ArrayToList(local.method.locals, CHR(10))>
		<cfset local.method.args   = ArrayToList(local.method.args, CHR(10))>
		<cfset ArrayPrepend(variables.methods, local.method)>
		<cfset ArrayPrepend(variables.output.methods, utils.render(local.method, variables.tpl_method, "name,args,returntype,returnvalue,locals"))>
		
	</cffunction>
	
	<cffunction name="parseMethods">
		<cfargument name="methodString" type="string" required="true">
		<cfset var local = StructNew()>
		<cfset local.methodString = arguments.methodString>
		<cfset local.methods = utils.d2a(instring=local.methodString, delimiter="@")>
		<cfset local.methodit = utils.iterator(local.methods)>
		<cfloop condition="#local.methodit.whileHasNext()#">
			<cfset local.method        = parseMethodString(local.methodit.current)>
			<cfset local.method.locals = ArrayToList(local.method.locals, CHR(10))>
			<cfset local.method.args   = ArrayToList(local.method.args, CHR(10))>
			<cfset ArrayAppend(variables.methods,  local.method)>
			<cfset ArrayAppend(variables.output.methods, utils.render(local.method, variables.tpl_method, "name,args,returntype,returnvalue,locals"))>
		</cfloop>
	</cffunction>
	
	<cffunction name="getScopedVar">
		<cfargument name="name">
		<cfif ListFindNoCase(variables.output.scopes["variables"]["keys"],arguments.name)>
			<cfreturn variables.output.scopes["variables"]["vars"][ListFindNoCase(variables.output.scopes["variables"]["keys"],arguments.name)]>
		<cfelseif ListFindNoCase(variables.output.scopes["this"]["keys"],arguments.name)>
			<cfreturn variables.output.scopes["this"]["vars"][ListFindNoCase(variables.output.scopes["this"]["keys"],arguments.name)]>
		</cfif>
		<cfreturn StructNew()>
	</cffunction>
	
	<cffunction name="setParamFromScope">
		<cfargument name="param">
		<cfset var local = StructNew()>
		<cfset local.param = arguments.param>
		<cfset local.scoped = getScopedVar(local.param.name)>
		<cfif NOT StructIsEmpty(local.scoped)>
			<cfset local.param.datatype = local.scoped.datatype>
			<cfset local.param.scope    = local.scoped.scope>
			<cfif local.param.default eq "">
				<cfset local.param.default = "#local.scoped.name#">
				<cfif local.scoped.scope neq "">
					<cfset local.param.default = local.scoped.scope & "." & local.param.default>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn local.param>
	</cffunction>
	
	<cffunction name="emptyLine" output="No">
		<cfargument name="repeat" type="numeric" required="false" default="1">
		<cfargument name="tabbed" type="boolean" required="false" default="false">
		
		<cfset var local = StructNew()>
		<cfset local.repeat = arguments.repeat>
		<cfset local.tabbed = arguments.tabbed>
		
		<cfset local.delim  = variables.LDELIM>
		<cfif local.tabbed>
			<cfset local.delim  = variables.LTABDELIM>
		</cfif>
		<cfreturn RepeatString(local.delim, local.repeat)>
	</cffunction>
	
	<cffunction name="getCommentBlockHeader" output="No">
		<cfargument name="header" type="string" required="false" default="">
		<cfargument name="body" type="string" required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.body   = arguments.body>
		<cfset local.header = arguments.header>
		<cfset local.result = variables.utils.render(local,Trim(variables.tpl_comment_block),"header")>
		
		<cfif local.body neq "">
			<cfset local.result = local.result & emptyLine() & getCommentLine(local.body)>
		</cfif>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getCommentLine" output="No">
		<cfargument name="body" type="string" required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.body   = arguments.body>
		<cfset local.result = variables.utils.render(local,Trim(variables.tpl_comment_line),"body")>
		
		<cfreturn local.result>
	</cffunction>
	

<!--- -------------------------------------------------------------------- --->
<!--- PUBLIC GETTER SETTERS --->
<!--- -------------------------------------------------------------------- --->
	
</cfcomponent>
