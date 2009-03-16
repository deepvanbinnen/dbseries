
<cfset starttime = getTickCount()>

<cfset output  = createObject("component", "cfc.db.HTML").init()>
<cfset strHelp = createObject("component", "cfc.pf").init()>

<cfset templatedir = ExpandPath('.') & "/templates/">

<cffile action="read" file="#templatedir#scoped_var.tpl" variable="tpl_set">
<cffile action="read" file="#templatedir#local_arg_var.tpl" variable="tpl_local_arg">
<cffile action="read" file="#templatedir#getter_setter_public.tpl" variable="tpl_getset_public">
<cffile action="read" file="#templatedir#getter_setter_private.tpl" variable="tpl_getset_private">
<cffile action="read" file="#templatedir#req_arg.tpl" variable="tpl_req_arg">
<cffile action="read" file="#templatedir#opt_arg.tpl" variable="tpl_opt_arg">
<cffile action="read" file="#templatedir#method_public.tpl" variable="tpl_method">
<cffile action="read" file="#templatedir#component.tpl" variable="tpl_component">
<cffile action="read" file="#templatedir#exec_setter_public.tpl" variable="tpl_init_setter_public">
<cffile action="read" file="#templatedir#exec_setter_private.tpl" variable="tpl_init_setter_private">

<cfset global_known_vars = StructNew()>
<cfset variable_scope_vars = "">
<cfset this_scope_vars = "">

<cfset component_sets        = ArrayNew(1)>
<cfset getter_setter_bodies  = ArrayNew(1)>
<cfset other_method_bodies   = ArrayNew(1)>

<cfset formtextareas = StructNew()>
<cfset formtextareas["this"]      = "componentthisscope">
<cfset formtextareas["variables"] = "componentvariables">

<cfset c = StructNew()>
<cfset c.name = form.componentname>

<cffunction name="encaps">
	<cfargument name="instring" type="string" required="false" default="">
	<cfargument name="quoter" required="false" default="34" type="numeric">
	
	<cfif ASC(LEFT(instring,1)) eq arguments.quoter AND ASC(RIGHT(instring,1)) eq arguments.quoter>
		<cfreturn arguments.instring>	
	<cfelse>
		<cfreturn CHR(arguments.quoter) & arguments.instring & CHR(arguments.quoter)>
	</cfif>
</cffunction>

<cfloop collection="#formtextareas#" item="scope">
	<cfset current_scope_formelement = formtextareas[scope]>
	<cfset current_scope = scope>
	<cfset current_var_list = "">
	
	<cfset getter_setter_vars = ListToArray(form[current_scope_formelement],chr(10))>
	<cfif ArrayLen(getter_setter_vars)>
		<cfset guessed_delimiter = " ">
		<cfif ListFind(getter_setter_vars[1], ",")>
			<cfset guessed_delimiter = ",">	
		</cfif>
		
		<cfloop from="1" to="#ArrayLen(getter_setter_vars)#" index="i">
			<cfset getter_setter_var = ListToArray(getter_setter_vars[i],guessed_delimiter)>
			<cfset variable          = StructNew()>
			<cfset variable.name     = TRIM(getter_setter_var[1])>
			<cfif ArrayLen(getter_setter_var) gte 2>
				<cfset variable.datatype = Trim(getter_setter_var[2])>
			<cfelse>
				<cfset variable.datatype = "any">
			</cfif>
			
			<cfif ArrayLen(getter_setter_var) gte 3>
				<cfset variable.required = Trim(getter_setter_var[3])>
			<cfelse>
				<cfset variable.required = "true">
			</cfif>
			
			<cfif ArrayLen(getter_setter_var) gte 4>
				<cfset variable.default = Trim(getter_setter_var[4])>
				<cfset re = "^(StructNew|ArrayNew|QueryNew|createObject)">
				<cfif REFindNoCase(re,variable.default)>
					<cfset variable.default = encaps(variable.default,35)>
				</cfif>
			<cfelse>
				<cfset variable.default = "">
			</cfif>
			
			<cfset variable.scope    = current_scope>
			<cfset variable.uname    = strHelp.firstCap(variable.name).get()>
			
			<cfset StructInsert(global_known_vars, variable.name, variable, true)>
			<cfset current_var_list = ListAppend(current_var_list, variable.name)>
			
			<cfswitch expression="#scope#">
				<cfcase value="variables">
					<cfset get_set_template = tpl_getset_private>
				</cfcase>
				<cfdefaultcase>
					<cfset get_set_template = tpl_getset_public>
				</cfdefaultcase>
			</cfswitch>
			<cfset ArrayAppend(getter_setter_bodies, output.render(variable, get_set_template, "uname,name,scope,datatype,required"))>
			<cfset ArrayAppend(component_sets, output.render(variable,Trim(tpl_set),"scope,name,default"))>
			
		</cfloop>
		
	</cfif>
	
	<cfswitch expression="#scope#">
		<cfcase value="variables">
			<cfset get_set_template = tpl_getset_private>
			<cfset variable_scope_vars = current_var_list>
		</cfcase>
		<cfdefaultcase>
			<cfset get_set_template = tpl_getset_public>
			<cfset this_scope_vars = current_var_list>
		</cfdefaultcase>
	</cfswitch>
</cfloop>

<cfset argvar_default_scope = "variables">
<cfset other_methods = ListToArray(form.componentmethods,"@")>
<cfif ArrayLen(other_methods)>
	<cfloop from="1" to="#ArrayLen(other_methods)#" index="i">
		<cfset other_method = TRIM(other_methods[i])>
		<cfif Find(chr(10), other_method)>
			<cfset guessed_delimiter = CHR(10)>
		<cfelseif Find("|", other_method)>
			<cfset guessed_delimiter = "|">
		<cfelse>
			<cfset guessed_delimiter = ' '>
		</cfif>
		<cfset other_method = ListToArray(other_method, guessed_delimiter)>
		
		<cfset method_def = StructNew()>
		<cfset method_def.name        = other_method[1]>
		<cfset method_def.params      = "">
		<cfset method_def.returntype  = "any">
		<cfset method_def.returnvalue = "">
		<cfset method_def.locals      = ArrayNew(1)>
		
		
		<cfif ArrayLen(other_method) gt 2>
			<cfset requireds = TRIM(other_method[3])>
		<cfelse>
			<cfset requireds = "">
		</cfif>
		
		<cfif ArrayLen(other_method) gt 3 AND TRIM(other_method[4]) neq "">
			<cfset method_def.returntype = other_method[4]>
		<cfelse>
			<cfset method_def.returntype = "any">
		</cfif>
		
		<cfif ArrayLen(other_method) gt 4 AND TRIM(other_method[5]) neq "">
			<cfset method_def.returnvalue = other_method[5]>
		<cfelse>
			<cfset method_def.returnvalue = "">
		</cfif>
		
		<cfset argArray = ArrayNew(1)>
		<cfif ArrayLen(other_method) gt 1>
			<cfset params = Trim(other_method[2])>
			<cfloop list="#params#" index="param">
				<cfset pair = ListToArray(param,"=")>
				<cfset paramdef = param>
				<cfset param = TRIM(REReplace(pair[1],"[^a-zA-Z0-9_=]", "", "ALL"))>
				<cfif param neq "">
					<cfset argvar = StructNew()>
					<cfset argvar.name = param>
					<cfset argvar.required = true>
					<cfset argvar.defaultvalue = "">
					<cfset argvar.datatype = "any">
					
					<cfif StructKeyExists(global_known_vars, param)>
						<cfset argvar = Duplicate(global_known_vars[param])>
						<cfif ListFind(requireds, param)>
							<cfset argvar.required = true>
						<cfelse>
							<cfset argvar.required = false>
							<cfif ArrayLen(pair) gt 1>
								<cfif ListLen(pair[2],'.') gt 1>
									<cfset argvar.defaultvalue = CHR(35) & Trim(pair[2]) & CHR(35)>
								<cfelse>
									<cfset argvar.defaultvalue = Trim(pair[2])>
								</cfif>
							<cfelse>
								<cfif (NOT Find("=", paramdef)) AND argvar_default_scope eq "variables">
									<cfif ListFind(variable_scope_vars, param)>
										<cfset argvar.defaultvalue = CHR(35) & "variables." & param & CHR(35)>
									<cfelseif ListFind(this_scope_vars, param)>
										<cfset argvar.defaultvalue = CHR(35) & "this." & param & CHR(35)>
									<cfelse>
										<cfset argvar.defaultvalue = "">
									</cfif>
								<cfelse>
									<cfset argvar.defaultvalue = "">
								</cfif>
							</cfif>
						</cfif>
					</cfif>
					<cfif argvar.required>
						<cfset ArrayAppend(argArray, output.render(argvar, tpl_req_arg, "name,datatype"))>
					<cfelse>	
						<cfset ArrayAppend(argArray, output.render(argvar, tpl_opt_arg, "name,datatype,defaultvalue"))>
					</cfif>
					<cfset ArrayAppend(method_def.locals, output.render(argvar, tpl_local_arg, "name"))>
				</cfif>
			</cfloop>
			<cfset method_def.params = ArrayToList(argArray, CHR(13)&CHR(10)&CHR(9))>
		</cfif>
		<cfset method_def.locals = ArrayToList(method_def.locals, CHR(13)&CHR(10)&CHR(9))>
		<cfset ArrayAppend(other_method_bodies, output.render(method_def, tpl_method, "name,params,returntype,returnvalue,locals"))>
	</cfloop>
</cfif>

<cfif form.createinitmethod eq 1>

	<cfset method_def = StructNew()>
	<cfset method_def.name        = "init">
	<cfset method_def.params      = "">
	<cfset method_def.returntype  = c.name>
	<cfset method_def.returnvalue = "this">
	<cfset method_def.body      = "">
	<cfset method_def.locals      = ArrayNew(1)>
	
	<cfset delimiter     = CHR(10)>
	<cfset init_variables = method_def.params>
	<cfset init_setters = ArrayNew(1)>
	<cfset argArray = ArrayNew(1)>
	
	
	<cfset given_params = ListToArray(form.componentinitmethod, chr(10))>
	<cfif ArrayLen(given_params) gt 1>
		<cfset requireds = TRIM(given_params[2])>
		<cfset params = TRIM(given_params[1])>
	<cfelse>
		<cfset requireds = "">
		<cfset params = TRIM(form.componentinitmethod)>
	</cfif>
	
	<cfloop list="#params#" index="param">
		<cfset pair = ListToArray(param,"=")>
		<cfset paramdef = param>
		<cfset param = TRIM(REReplace(pair[1],"[^a-zA-Z0-9_=]", "", "ALL"))>
		<cfif param neq "">
			<cfset argvar = StructNew()>
			<cfset argvar.name = param>
			<cfset argvar.required = true>
			<cfset argvar.defaultvalue = "">
			<cfset argvar.datatype = "any">
			
			<cfif StructKeyExists(global_known_vars, param)>
				<cfset argvar = Duplicate(global_known_vars[param])>
				<cfif ListFind(requireds, param)>
					<cfset argvar.required = true>
				<cfelse>
					<cfset argvar.required = false>
					<cfif ArrayLen(pair) gt 1>
						<cfif ListLen(pair[2],'.') gt 1>
							<cfset argvar.defaultvalue = CHR(35) & Trim(pair[2]) & CHR(35)>
						<cfelse>
							<cfset argvar.defaultvalue = Trim(pair[2])>
						</cfif>
					<cfelse>
						<cfif (NOT Find("=", paramdef)) AND argvar_default_scope eq "variables">
							<cfif ListFind(variable_scope_vars, param)>
								<cfset argvar.defaultvalue = CHR(35) & "variables." & param & CHR(35)>
							<cfelseif ListFind(this_scope_vars, param)>
								<cfset argvar.defaultvalue = CHR(35) & "this." & param & CHR(35)>
							<cfelse>
								<cfset argvar.defaultvalue = "">
							</cfif>
						<cfelse>
							<cfset argvar.defaultvalue = "">
						</cfif>
					</cfif>
				</cfif>
			</cfif>
			<cfif argvar.required>
				<cfset ArrayAppend(argArray, output.render(argvar, tpl_req_arg, "name,datatype"))>
			<cfelse>	
				<cfset ArrayAppend(argArray, output.render(argvar, tpl_opt_arg, "name,datatype,defaultvalue"))>
			</cfif>
			<cfset ArrayAppend(method_def.locals, output.render(argvar, tpl_local_arg, "name"))>
			<cfif form.componentinitargsauto eq 1>
				<cfset varstruct = StructNew()>
				<cfset varstruct.name = strHelp.firstCap(argvar.name).get()>
				<cfif ListFindNoCase(variable_scope_vars, argvar.name)>
					<cfset varstruct.value = "arguments." & argvar.name>
					<cfset ArrayAppend(init_setters, output.render(varstruct, tpl_init_setter_private, "name,value"))>
				</cfif>
				<cfif ListFindNoCase(this_scope_vars, argvar.name)>
					<cfset varstruct.value = "arguments." & argvar.name>
					<cfset ArrayAppend(init_setters, output.render(varstruct, tpl_init_setter_public, "name,value"))>
				</cfif>	
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- <cfset ArrayAppend(method_def.locals, ArrayToList(init_setters, CHR(13)&CHR(10)&CHR(9)))>
	 --->
	<cfset method_def.params = ArrayToList(argArray, CHR(13)&CHR(10)&CHR(9))>
	<cfset method_def.locals = ArrayToList(method_def.locals, CHR(13)&CHR(10)&CHR(9))>
	<cfset method_def.locals = method_def.locals & CHR(13) & CHR(10) & CHR(13) & CHR(10) &CHR(9) & ArrayToList(init_setters, CHR(13)&CHR(10)&CHR(9))>

	<cfset ArrayPrepend(other_method_bodies, output.render(method_def, tpl_method, "name,params,returntype,returnvalue,locals"))>
</cfif>


<cfsavecontent variable="myoutput">
<cfoutput>#ArrayToList(component_sets, CHR(13)&CHR(10))#
#CHR(13)&CHR(10)#	
#ArrayToList(other_method_bodies, CHR(13)&CHR(10))#
#CHR(13)&CHR(10)#
#ArrayToList(getter_setter_bodies, CHR(13)&CHR(10))#
</cfoutput>
</cfsavecontent>

<cfset c.body = strHelp.indent(myoutput, 1).get()>
<cfset myoutput = output.render(c,Trim(tpl_component),"name,body")>

<cfset form.filegenerated = false>
<cfif form.componentfilename neq "">
	<cfif Find("/var/www/deepvanbinnen/", form.componentfilename) AND ListLast(form.componentfilename,".") eq 'cfc'>
		<cfif NOT FileExists(form.componentfilename) OR form.componentfileoverwrite eq 1>
			<cftry>
				<cffile action="write" file="#form.componentfilename#" output="#myoutput#">
				<cfset form.filegenerated = true>
				<cfset form.generationtime = getTickCount()-starttime>
				<cfcatch type="any">
					<cfdump var="#cfcatch#">
					<cfset form.raisederror = "Write failure">
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset form.raisederror = "Error writing file. It probably exists">
		</cfif>
	<cfelse>
		<cfset form.raisederror = "Illegal file: #form.componentfilename#">
	</cfif>
</cfif>

<cfset form.generatedcode = myoutput>
