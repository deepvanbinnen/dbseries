<cfset output = createObject("component", "cfc.db.HTML").init()>
<cfset strHelp = createObject("component", "cfc.pf").init()>

<cffile action="read" file="#ExpandPath('.')#/getter_setter.tpl" variable="tpl">
<cffile action="read" file="#ExpandPath('.')#/scoped_var.tpl" variable="tpl_set">
<cffile action="read" file="#ExpandPath('.')#/req_arg.tpl" variable="tpl_req_arg">
<cffile action="read" file="#ExpandPath('.')#/opt_arg.tpl" variable="tpl_opt_arg">
<cffile action="read" file="#ExpandPath('.')#/method.tpl" variable="tpl_method">
<cffile action="read" file="#ExpandPath('.')#/component.tpl" variable="tpl_component">


<cfset componentvariables = ListToArray("user,string,true, ,limit,numeric,false,50,page,numeric,false,1")>
<cfset scope = "this">
<cfset body  = ArrayNew(1)>
<cfset sets  = ArrayNew(1)>

<cfset known_vars = StructNew()>

<cfloop from="1" to="#ArrayLen(componentvariables)#" index="i" step="4">
	<cfset variable=StructNew()>
	<cfset variable.name     = componentvariables[i]>
	<cfset variable.datatype = componentvariables[i+1]>
	<cfset variable.required = componentvariables[i+2]>
	<cfset variable.default  = Trim(componentvariables[i+3])>
	<cfset variable.scope    = "this">
	<cfset variable.uname    = strHelp.firstCap(variable.name).get()>
	<cfset ArrayAppend(body,output.render(variable,Trim(tpl),"uname,name,scope,datatype,required"))>
	<cfset ArrayAppend(sets,output.render(variable,Trim(tpl_set),"scope,name,default"))>
	
	<cfset StructInsert(known_vars, componentvariables[i], variable, true)>
</cfloop>

<cfset m = ArrayNew(1)>

<cfset methods = ListToArray("@getAlbums|user,limit=50,page=1|user@getArtists|user,limit=50,page=1|user@getTracks|user,limit=50,page=1|user","@")>
<cfloop from="1" to="#arraylen(methods)#" index="i">
	<cfset method = ListToArray(methods[i],"|")>
	
	<cfif ArrayLen(method) gte 2>
		<cfset params     = method[2]>
	</cfif>
	<cfset requireds = "">
	<cfif ArrayLen(method) gte 2>
		<cfset requireds  = method[2]>
	</cfif>
	
	<cfset curmethod = StructNew()>
	<cfset curmethod.name = method[1]>
	<cfset args = ArrayNew(1)>
	<cfloop list="#params#" index="param">
		<cfset pair = ListToArray(param,"=")>
		<cfif StructKeyExists(known_vars, pair[1])>
			<cfset v = StructNew()>
			<cfset v = Duplicate(known_vars[pair[1]])>
			<cfdump var="#v#">
			<cfif ListFind(requireds,pair[1])>
				<cfset v.required = true>
				<cfset ArrayAppend(args,output.render(v,Trim(tpl_req_arg),"name,datatype"))>
			<cfelse>
				<cfset v.required = false>
				<cfif ArrayLen(pair) gt 1>
					<cfset v.default = pair[2]>
				<cfelse>
					<cfset v.default = "">
				</cfif>
				<cfset ArrayAppend(args,output.render(v,Trim(tpl_opt_arg),"name,datatype,default"))>
			</cfif>
			<cfset curmethod.args   = ArrayToList(args,CHR(13)&CHR(10)&CHR(9))>
			<cfset curmethod.return = "/">
		<cfelse>
			Unknown var!
			<cfabort>
		</cfif>
	</cfloop>
	<cfset ArrayAppend(m,output.render(curmethod,Trim(tpl_method),"name,args,return"))>
</cfloop>

<cfsavecontent variable="myoutput">
<cfoutput>#ArrayToList(sets, CHR(13)&CHR(10))#

#ArrayToList(body, CHR(13)&CHR(10)&CHR(13)&CHR(10))#

#ArrayToList(m, CHR(13)&CHR(10)&CHR(13)&CHR(10))#
</cfoutput>
</cfsavecontent>

<cfset c = StructNew()>
<cfset c.name = "Library">
<cfset c.body = strHelp.indent(myoutput, 1).get()>
<cfset myoutput = output.render(c,Trim(tpl_component),"name,body")>

<cfoutput><textarea cols="100" rows="20">#myoutput#</textarea></cfoutput>
<cfoutput>
<pre>#HTMLEditFormat(myoutput)#</pre></cfoutput>