<cfcomponent name="CFCGenerator">
	<cfset this.KNOWN_DELIMITERS = "10,32,44,124,43,64">
	<cfset this.name = "">
	<cfset this.extends = "">
	<cfset this.knownvars = "#StructNew()#">
	<cfset this.public_gsv = "">
	<cfset this.private_gsv = "">
	<cfset this.other_methods = "">
	<cfset this.create_init = "true">
	<cfset this.auto_set_init = "true">
	<cfset this.init_argv = "">
	
	<cfset variables.LDELIM  = CHR(13) & CHR(10)> 
	<cfset variables.LTABDELIM  = variables.LDELIM & CHR(9)> 
	<cfset variables.output  = createObject("component", "cfc.db.HTML").init()>
	<cfset variables.strHelp = createObject("component", "cfc.pf").init()>
	<cfset variables.templatedir = ExpandPath('.') & "/templates/">
	
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
		
	<cffunction name="init" output="No" returntype="CFCGenerator">
		<cfargument name="name" type="string" required="true">
		<cfargument name="public_gsv" type="string" required="false" default="#this.public_gsv#">
		<cfargument name="private_gsv" type="string" required="false" default="#this.private_gsv#">
		<cfargument name="other_methods" type="string" required="false" default="#this.other_methods#">
		<cfargument name="create_init" type="boolean" required="false" default="#this.create_init#">
		<cfargument name="auto_set_init" type="boolean" required="false" default="#this.auto_set_init#">
		<cfargument name="init_argv" type="string" required="false" default="#this.init_argv#">
		
		<cfset var local = StructNew()>
		<cfset local.name = arguments.name>
		<cfset local.public_gsv = arguments.public_gsv>
		<cfset local.private_gsv = arguments.private_gsv>
		<cfset local.other_methods = arguments.other_methods>
		<cfset local.create_init = arguments.create_init>
		<cfset local.auto_set_init = arguments.auto_set_init>
		<cfset local.init_argv = arguments.init_argv>
	
		<cfset setName(arguments.name)>
		<cfset setPublic_gsv(arguments.public_gsv)>
		<cfset setPrivate_gsv(arguments.private_gsv)>
		<cfset setOther_methods(arguments.other_methods)>
		<cfset setCreate_init(arguments.create_init)>
		<cfset setAuto_set_init(arguments.auto_set_init)>
		<cfset setInit_argv(arguments.init_argv)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="encaps">
		<cfargument name="instring" type="string" required="false" default="">
		<cfargument name="quoter" required="false" default="34" type="numeric">
		
		<cfif ASC(LEFT(instring,1)) eq arguments.quoter AND ASC(RIGHT(instring,1)) eq arguments.quoter>
			<cfreturn arguments.instring>	
		<cfelse>
			<cfreturn CHR(arguments.quoter) & arguments.instring & CHR(arguments.quoter)>
		</cfif>
	</cffunction>
	
	<cffunction name="strip">
		<cfargument name="instring" type="string" required="false" default="">
		
		<cfif arguments.instring eq "''" OR arguments.instring eq '""'>	
			<cfreturn "">
		</cfif>
		<cfreturn arguments.instring>
	</cffunction>
	
	<cffunction name="outputArr">
		<cfargument name="inarray" type="array" required="true">
		<cfargument name="repeat" type="numeric" required="false" default="1">
		<cfargument name="delimiter" type="string" required="false" default="#variables.LDELIM#">
		
		<cfif ArrayLen(arguments.inarray)>
			<cfreturn ArrayToList(arguments.inarray, RepeatString(arguments.delimiter,arguments.repeat))>
		<cfelse>	
			<cfreturn "">
		</cfif>
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
	
	<cffunction name="parseDelimitedString" output="No" returntype="array">
		<cfargument name="instring" type="string" required="true">
		<cfargument name="delimiter" type="string" required="false" default="#guessDelimiter(arguments.instring)#">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		<cfset local.delimiter = arguments.delimiter>
		
		<cfreturn ListToArray(local.instring,local.delimiter)>
	</cffunction>
	
	<cffunction name="guessDelimiter" output="No" returntype="string">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		<cfloop list="#getKNOWN_DELIMITERS()#" index="local.ascdelim">
			<cfif Find(CHR(local.ascdelim), TRIM(local.instring))>
				<cfreturn CHR(local.ascdelim)>
			</cfif>
		</cfloop>
		
		<cfreturn "">
	</cffunction>
	
	<cffunction name="setScopeVars" output="yes" returntype="string">
		<cfargument name="inarray" type="array" required="true">
		<cfargument name="scope" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.inarray = arguments.inarray>
		<cfset local.scope = arguments.scope>
		
		<cfloop from="1" to="#ArrayLen(local.inarray)#" index="local.i">
			<cfset local.invar = parseDelimitedString(local.inarray[local.i])>
			<cfset addScopeVar(createVar(local.invar),local.scope)>
		</cfloop>
		
		<cfreturn "">
	</cffunction>
	
	<cffunction name="parseMethods" output="yes" returntype="any">
		<cfargument name="inarray" type="array" required="true">
		<cfset var local = StructNew()>
		<cfset local.inarray = arguments.inarray>
		<cfloop from="1" to="#ArrayLen(local.inarray)#" index="local.i">
			<cfset addScopeVar(parseMethod(parseDelimitedString(TRIM(local.inarray[local.i]))), "methods")>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="emptyMethod" output="no" returntype="struct">
		<cfset var local = StructNew()>
		<cfset local.method         = StructNew()>
		<cfset local.method.name    = "init">
		<cfset local.method.rettype = getName()>
		<cfset local.method.retval  = "">
		<cfset local.method.params  = "">
		<cfset local.method.locals  = "">
		<cfreturn local.method>
	</cffunction>
	 
	<cffunction name="parseMethod" output="yes" returntype="struct">
		<cfargument name="inarray" type="array" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.inarray = arguments.inarray>
		<cfset local.params  = ArrayNew(1)>
		<cfset local.keys    = ListToArray("name,params,rettype,retval")>
		<cfset local.vals    = ListToArray("'','',any,''")>
		<cfset local.arrlen  = ArrayLen(local.inarray)>
		<cfset local.result  = StructNew()>
		
		<cfloop from="1" to="#ArrayLen(local.keys)#" index="local.i">
			<cfif local.i lte local.arrlen>
				<cfset local.curval = local.inarray[local.i]>
			<cfelse>
				<cfset local.curval = local.vals[local.i]>
			</cfif>
			<cfif local.keys[local.i] neq "params">
				<cfset local.curval = TRIM(local.curval)>
			<cfelse>
				<cfset local.curval = parseParams(local.curval)>
			</cfif>
			<cfset StructInsert(local.result,local.keys[local.i],local.curval)>
		</cfloop>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="parseParams" output="yes" returntype="array">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		<cfset local.params = parseDelimitedString(TRIM(local.instring))>
		<cfset local.result = ArrayNew(1)>
		
		<cfloop from="1" to="#ArrayLen(local.params)#" index="local.i">
			<cfset ArrayAppend(local.result, parseParam(local.params[local.i]))>
		</cfloop>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="parseParam" output="yes" returntype="struct">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		<cfset local.param    = parsePair(local.instring)>
		<cfset local.result   = getFromScope(local.param)>
		
		<cfif StructIsEmpty(local.result)>
			<cfset local.result          = createVar(ListToArray(local.param.name))>
			<cfset local.result.required = local.param.required>
			<cfset local.result.default  = local.param.value>
		</cfif>
		<cfif ListLen(local.result.default,".") gt 1>
			<cfset local.result.default = encaps(local.result.default, 35)>
		</cfif>
		<cfset local.result.default = strip(local.result.default)>
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="parsePair" output="yes" returntype="struct">
		<cfargument name="instring" type="any" required="true">
		<cfset var local = StructNew()>
		<cfset local.param = StructNew()>
		<cfset local.instring    = parseDelimitedString(TRIM(arguments.instring),"=")>
		<cfset local.param.name  = local.instring[1]>
		<cfset local.param.value = "">
		<cfset local.param.required  = true>
		<cfset local.param.emptyflag = true>
		
		<cfif ArrayLen(local.instring) gt 1>
			<cfset local.param.value = TRIM(local.instring[2])>
			<cfset local.param.required = false>
			<cfset local.param.emptyflag = false>
		<cfelseif Find("=", arguments.instring) AND ArrayLen(local.instring) eq 1>
			<cfset local.param.required = false>
		</cfif>
		<cfreturn local.param>
	</cffunction>
	
	<cffunction name="getFromScope" output="No" returntype="struct">
		<cfargument name="param" type="struct" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.param = arguments.param>
		<cfset local.result = StructNew()>
		
		<cfset local.scopes = "variables,this">
		<cfloop list="#local.scopes#" index="local.scope">
			<cfset local.result = getScopeVar(local.scope,local.param.name)>
			<cfif NOT StructIsEmpty(local.result)>
				<cfset local.result = Duplicate(local.result)>
				<cfset local.result.required = local.param.required> 
				<cfset local.result.default  = local.param.value>
				<cfif NOT local.result.required OR local.param.emptyflag>
					<cfset local.result.default = local.scope & "." & local.param.name>
				</cfif>
				<cfbreak>		
			</cfif>
		</cfloop>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="createVar" output="No" returntype="struct">
		<cfargument name="inarray" type="array" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.inarray = arguments.inarray>
		<cfset local.result  = StructNew()>
		<cfset local.arrlen  = ArrayLen(local.inarray)>
		<cfset local.keys    = ListToArray("name,datatype,required,default")>
		<cfset local.vals    = ListToArray("'',any,true,''")>
		<cfloop from="1" to="#ArrayLen(local.keys)#" index="local.i">
			<cfif local.i lte local.arrlen>
				<cfset local.curval = local.inarray[local.i]>
			<cfelse>
				<cfset local.curval = local.vals[local.i]>
			</cfif>
			<cfset local.curval = strip(local.curval)>
			<cfset StructInsert(local.result,local.keys[local.i],TRIM(local.curval))>
		</cfloop>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="addScopeVar" output="No" returntype="any">
		<cfargument name="varstruct" type="struct" required="true">
		<cfargument name="scopename" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.varstruct = arguments.varstruct>
		<cfset local.scopename = arguments.scopename>
		<cfif StructIsEmpty(getScopeVar(local.scopename, local.varstruct.name))>
			<cfset addKnownVar(local.scopename, local.varstruct)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getScopeVar" output="No" returntype="struct">
		<cfargument name="scopename" type="any" required="true">
		<cfargument name="varname" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.scopename = arguments.scopename>
		<cfset local.varname   = arguments.varname>
		<cfset local.scopevars = getScopeVars(local.scopename)>
		<cfset local.result = StructNew()>
		
		<cfif ArrayLen(local.scopevars)>
			<cfloop from="1" to="#ArrayLen(local.scopevars)#" index="local.i">
				<cfif local.scopevars[local.i].name eq local.varname>
					<cfset local.result = local.scopevars[local.i]>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getScopeVars" output="No" returntype="array">
		<cfargument name="scopename" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.scopename = arguments.scopename>
		<cfset local.knownvars = getKnownVars()>
		<cfset local.result = ArrayNew(1)>
		<cfif StructKeyExists(local.knownvars,local.scopename)>
			<cfset local.result = local.knownvars[local.scopename]>
		</cfif>
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="addKnownVar" output="No">
		<cfargument name="scopename" type="any" required="true">
		<cfargument name="varstruct" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.scopename = arguments.scopename>
		<cfset local.varstruct = arguments.varstruct>
		<cfset local.knownvars = getKnownVars()>
		<cfif NOT StructKeyExists(local.knownvars,local.scopename)>
			<cfset StructInsert(local.knownvars,local.scopename,ArrayNew(1))>
		</cfif>
		<cfset ArrayAppend(local.knownvars[local.scopename],local.varstruct)>
	</cffunction>
	
	<cffunction name="getCommentBlockHeader" output="No">
		<cfargument name="header" type="string" required="false" default="">
		<cfargument name="body" type="string" required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.body   = arguments.body>
		<cfset local.header = arguments.header>
		<cfset local.result = output.render(local,Trim(variables.tpl_comment_block),"header")>
		
		<cfif local.body neq "">
			<cfset local.result = local.result & emptyLine() & getCommentLine(local.body)>
		</cfif>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getCommentLine" output="No">
		<cfargument name="body" type="string" required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.body   = arguments.body>
		<cfset local.result = output.render(local,Trim(variables.tpl_comment_line),"body")>
		
		<cfreturn local.result>
	</cffunction>

	<cffunction name="getScopeOutput" output="No">
		<cfargument name="scopename" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.scopename = arguments.scopename>
		<cfset local.scopevars = getScopeVars(local.scopename)>
		<cfset local.result = StructNew()>
		<cfset local.result.getter_setter_bodies = ArrayNew(1)>
		<cfset local.result.component_sets = ArrayNew(1)>
		
		<cfif scopename eq "variables">
			<cfset local.get_set_template = variables.tpl_getset_private>
		<cfelse>
			<cfset local.get_set_template = variables.tpl_getset_public>
		</cfif>
		
		<cfif ArrayLen(local.scopevars)>
			<cfloop from="1" to="#ArrayLen(local.scopevars)#" index="i">	
				<cfset local.variable = local.scopevars[i]>
				<cfset local.variable.scope = local.scopename>
				<cfset local.variable.uname = variables.strHelp.firstcap(local.variable.name).get()>
				<cfset ArrayAppend(local.result.getter_setter_bodies, output.render(local.variable, local.get_set_template, "uname,name,scope,datatype,required"))>
				<cfset ArrayAppend(local.result.component_sets, output.render(local.variable,Trim(variables.tpl_set),"scope,name,default"))>
			</cfloop>
		</cfif>
		<cfreturn local.result>
	</cffunction>
		
	<cffunction name="getMethodsOutput" output="No">
		<cfset var local = StructNew()>
		<cfset local.methods = getScopeVars("methods")>
		<cfset local.result = StructNew()>
		<cfset local.result.methods = ArrayNew(1)>
		
		<cfif ArrayLen(local.methods)>
			<cfloop from="1" to="#ArrayLen(local.methods)#" index="i">
				<cfset local.temp = getMethodOutput(local.methods[i])>
				<cfset ArrayAppend(local.result.methods, output.render(local.temp, variables.tpl_method, "name,params,returntype,returnvalue,locals"))>
			</cfloop>
		</cfif>
		<cfreturn local.result.methods>
	</cffunction>
	
	<cffunction name="getMethodOutput" output="No">
		<cfargument name="method" type="struct" required="true">
		<cfargument name="parsesetters" type="boolean" required="false" default="false">
		
		<cfset var local = StructNew()>
		<cfset local.method = arguments.method>
		<cfset local.parsesetters = arguments.parsesetters>
		
		<cfset local.temp = StructNew()>
		<cfset local.temp.name        = local.method.name>
		<cfset local.temp.returntype  = local.method.rettype>
		<cfset local.temp.returnvalue = local.method.retval>
		
		<cfset local.temp.params      = ArrayNew(1)>
		<cfset local.temp.locals      = ArrayNew(1)>
		<cfset local.temp.setters     = StructNew()>
		<cfset local.temp.setters.public  = ArrayNew(1)>
		<cfset local.temp.setters.private = ArrayNew(1)>
		
		<cfloop from="1" to="#ArrayLen(local.method.params)#" index="local.p">
			<cfset local.argvar = local.method.params[local.p]>
			<cfif local.argvar.required>
				<cfset ArrayAppend(local.temp.params, output.render(local.argvar, variables.tpl_req_arg, "name,datatype"))>
			<cfelse>
				<cfset ArrayAppend(local.temp.params, output.render(local.argvar, variables.tpl_opt_arg, "name,datatype,default"))>
			</cfif>
			<cfset ArrayAppend(local.temp.locals, output.render(local.argvar, variables.tpl_local_arg, "name"))>
			
			<cfif local.parsesetters>
				<cfset local.varstruct = StructNew()>
				<cfset local.varstruct.name = variables.strHelp.firstCap(local.argvar.name).get()>
				<cfif NOT StructIsEmpty(getScopeVar("variables", local.argvar.name))>
					<cfset local.varstruct.value = "arguments." & local.argvar.name>
					<cfset ArrayAppend(local.temp.setters.private, output.render(local.varstruct, variables.tpl_init_setter_private, "name,value"))>
				</cfif>
				<cfif NOT StructIsEmpty(getScopeVar("this", local.argvar.name))>
					<cfset local.varstruct.value = "arguments." & local.argvar.name>
					<cfset ArrayAppend(local.temp.setters.public, output.render(local.varstruct, variables.tpl_init_setter_public, "name,value"))>
				</cfif>	
			</cfif>
		</cfloop>
		<cfset local.temp.params = outputArr(local.temp.params, 1, variables.LTABDELIM)>
		<cfset local.temp.locals = outputArr(local.temp.locals, 1, variables.LTABDELIM)>

		<cfreturn local.temp>
	</cffunction>
	
	<cffunction name="getInit" output="No" returntype="string">
		<cfargument name="paramlist" type="string" required="false" default="#getInit_argv()#">
		
		<cfset var local = StructNew()>
		<cfset local.paramlist = arguments.paramlist>
		<cfset local.method = StructNew()>
		<cfset local.method.name = "init">
		<cfset local.method.rettype = getName()>
		<cfset local.method.retval = "this">
		<cfset local.method.params = parseParams(local.paramlist)>
		<cfset local.method = getMethodOutput(local.method, true)>
		<cfset local.method.locals = local.method.locals & emptyLine(0, true) & outputArr(local.method.setters.public)>
		<cfset local.method.locals = local.method.locals & emptyLine(0, true) & outputArr(local.method.setters.private)>
		<cfset local.result = output.render(local.method, variables.tpl_method, "name,params,returntype,returnvalue,locals")>
		
		<cfreturn local.result>
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
		<cfset local.result.body = output.render(local.result, Trim(variables.tpl_component), "name,body")>
		
		<cfreturn local.result>
	</cffunction>

<!--- -------------------------------------------------------------------- --->
<!--- PUBLIC GETTER SETTERS --->
<!--- -------------------------------------------------------------------- --->
	<cffunction name="getKnown_delimiters" output="No">
		<cfreturn this.KNOWN_DELIMITERS>
	</cffunction>
	<cffunction name="setKnown_delimiters" output="No">
		<cfargument name="KNOWN_DELIMITERS" type="string" required="false">
		<cfset this.KNOWN_DELIMITERS = arguments.KNOWN_DELIMITERS>
	</cffunction>
	
	<cffunction name="getName" output="No">
		<cfreturn this.name>
	</cffunction>
	<cffunction name="setName" output="No">
		<cfargument name="name" type="string" required="true">
		<cfset this.name = arguments.name>
	</cffunction>
	
	
	<cffunction name="getExtends" output="No">
		<cfreturn this.extends>
	</cffunction>
	<cffunction name="setExtends" output="No">
		<cfargument name="extends" type="string" required="false">
		<cfset this.extends = arguments.extends>
	</cffunction>
	
	
	<cffunction name="getKnownvars" output="No">
		<cfreturn this.knownvars>
	</cffunction>
	<cffunction name="setKnownvars" output="No">
		<cfargument name="knownvars" type="struct" required="false">
		<cfset this.knownvars = arguments.knownvars>
	</cffunction>
	
	
	<cffunction name="getPublic_gsv" output="No">
		<cfreturn this.public_gsv>
	</cffunction>
	<cffunction name="setPublic_gsv" output="No">
		<cfargument name="public_gsv" type="string" required="false">
		<cfset this.public_gsv = arguments.public_gsv>
	</cffunction>
	
	
	<cffunction name="getPrivate_gsv" output="No">
		<cfreturn this.private_gsv>
	</cffunction>
	<cffunction name="setPrivate_gsv" output="No">
		<cfargument name="private_gsv" type="string" required="false">
		<cfset this.private_gsv = arguments.private_gsv>
	</cffunction>
	
	
	<cffunction name="getOther_methods" output="No">
		<cfreturn this.other_methods>
	</cffunction>
	<cffunction name="setOther_methods" output="No">
		<cfargument name="other_methods" type="string" required="false">
		<cfset this.other_methods = arguments.other_methods>
	</cffunction>
	
	
	<cffunction name="getCreate_init" output="No">
		<cfreturn this.create_init>
	</cffunction>
	<cffunction name="setCreate_init" output="No">
		<cfargument name="create_init" type="boolean" required="false">
		<cfset this.create_init = arguments.create_init>
	</cffunction>
	
	
	<cffunction name="getAuto_set_init" output="No">
		<cfreturn this.auto_set_init>
	</cffunction>
	<cffunction name="setAuto_set_init" output="No">
		<cfargument name="auto_set_init" type="boolean" required="false">
		<cfset this.auto_set_init = arguments.auto_set_init>
	</cffunction>
	
	
	<cffunction name="getInit_argv" output="No">
		<cfreturn this.init_argv>
	</cffunction>
	<cffunction name="setInit_argv" output="No">
		<cfargument name="init_argv" type="string" required="false">
		<cfset this.init_argv = arguments.init_argv>
	</cffunction>
</cfcomponent>
