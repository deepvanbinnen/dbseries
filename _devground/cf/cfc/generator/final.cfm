<cfdump var="#form#">

<cfset x = createObject("component", "CFCGenerator_final").init(form.componentname)>
<cfset x.parseScope('variables', form.componentvariables)>
<cfset x.parseScope('this', form.componentthisscope)>
<cfset x.parseMethods(form.componentmethods)>
<cfset x.parseConstructorMethod(form.componentinitmethod)>

<cfdump var="#x.getOutput()#">

<cfabort>

<cfset variables = StructNew()>
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


<cfset utils = createObject("component", "cfc.db.HTML").init()>

<cfset vars = StructNew()>

<cfset COLON = 58>


<cfset local = StructNew()>
<cfset local.set_variables = ArrayNew(1)>
<cfset local.getter_setter_public = ArrayNew(1)>
<cfset local.getter_setter_private = ArrayNew(1)>
<cfset local.constructor_method = ArrayNew(1)>
<cfset local.methods = ArrayNew(1)>


<cfset scopes = utils.p2s("public=componentthisscope,private=componentvariables")>
<cfset scopeit = utils.iterator(scopes)>
<cfloop condition="#scopeit.whileHasNext()#">
	<cfset StructInsert(vars, scopeit.key, utils.p2s("keys,vars"))>
	<cfset vars[scopeit.key]["vars"] = ArrayNew(1)>
	<cfset varit = utils.iterator(utils.d2a(TRIM(form[scopeit.current])))>
	<cfloop condition="#varit.whileHasNext()#">
		<cfset out_var = parseParamString(varit.current)>
		<cfset out_var.uname = utils.firstCap(out_var.name).get()>
		<cfswitch expression="#scopeit.key#">
			<cfcase value="public">
				<cfset out_var.scope = "this">
				<cfset ArrayAppend(local.getter_setter_public, utils.render(out_var, variables.tpl_getset_public, "uname,name,scope,datatype,required"))>
			</cfcase>
			<cfcase value="private">
				<cfset out_var.scope = "variables">
				<cfset ArrayAppend(local.getter_setter_private, utils.render(out_var, variables.tpl_getset_private, "uname,name,scope,datatype,required"))>
			</cfcase>
		</cfswitch>
		<cfset ArrayAppend(vars[scopeit.key]["vars"],out_var)>
		<cfset vars[scopeit.key]["keys"] = ListAppend(vars[scopeit.key]["keys"],out_var.name)>
		<cfset ArrayAppend(local.set_variables, utils.render(out_var, Trim(variables.tpl_set), "scope,name,default"))>
	</cfloop>
</cfloop>

<cfset vars["methods"] = ArrayNew(1)>
<cfset methods = utils.d2a(instring=form.componentmethods, delimiter="@")>
<cfif IsDefined("form.createinitmethod")>
	<cfset methodstring = "init:#form.componentname# " & form.componentinitmethod & " this">
	<cfset ArrayPrepend(methods, methodstring)>
</cfif>
<cfset method = utils.iterator(methods)>
<cfloop condition="#method.whileHasNext()#">
	<cfset m = parseMethodString(method.current)>
	<cfset m.locals = ArrayToList(m.locals, CHR(10))>
	<cfset m.args = ArrayToList(m.args, CHR(10))>
	<cfset ArrayAppend(vars["methods"], m)>
	<cfset ArrayAppend(local.methods, utils.render(m, variables.tpl_method, "name,args,returntype,returnvalue,locals"))>
</cfloop>

<cfset component = StructNew()>
<cfset component.name = form.componentname>
<cfset component.body = ArrayNew(1)>
<cfset component.body.addAll(local.set_variables)>
<cfset component.body.addAll(local.methods)>
<cfset component.body.addAll(local.getter_setter_public)>
<cfset component.body.addAll(local.getter_setter_private)>
<cfset component.body = ArrayToList(component.body, CHR(10)&CHR(10))>
<cfset component.body = utils.indent(component.body, 1).get()>
<cfset component.body = utils.render(component, Trim(variables.tpl_component), "name,body")>
<cfoutput><textarea cols="120" rows="80">#TRIM(component.body)#</textarea></cfoutput>

 
<!--- <cfset local.set_variables = ArrayNew(1)>
<cfset local.getter_setter_public = ArrayNew(1)>
<cfset local.getter_setter_private = ArrayNew(1)>
<cfset local.constructor_method = ArrayNew(1)>
<cfset local.methods = ArrayNew(1)>
<cfdump var="#local#">

<cfdump var="#vars#"> --->

