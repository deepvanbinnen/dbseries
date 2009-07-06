<cfcomponent>
	<cfset variables.options  = ArrayNew(1)>
	<cfset variables.optnames = StructNew()>
	<cfset variables.optreq   = "">
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get">
		<cfargument name="original" type="any" required="true">
		
		<cfset var out = StructNew()>
		<cfset var args = iterator(original)>
		<cfset var opts = iterator(getOptions())>
		<cfset var bnamed = false>
		
		<cfoutput>
			<cfloop condition="#opts.whileHasNext()#">
				<!--- <p>#def.index#: Setting out from index</p> --->
				<cfset StructInsert(out, opts.current.retkey, opts.current.retdefault, true)>
				<cfif NOT bnamed>
					<cfif args.hasNext()>
						<cfset args.next()>
						<cfif NOT args.numericKey()>
							<cfset bnamed = true>
						<cfelse>
							<cfset StructUpdate(out, opts.current.retkey, getValidatedValue(args.current,opts.current))>
						</cfif>
					<cfelse>
						<cfif opts.current.required>
							<cfthrow message="required missing">
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfoutput>
		
		<cfif bnamed>
			<cfset out = getNamed(out, original)>
		</cfif>
		
		<cfreturn out>
	</cffunction>
	
	<cffunction name="getNamed">
		<cfargument name="currout" type="struct" required="true">
		<cfargument name="original" type="any" required="true">
		
		<cfset var out = arguments.currout>
		<cfset var args = iterator(arguments.original)>
		<cfset var foundkeys = "">
		<cfset var requireds = variables.optreq>
		<cfset var reqindex  = variables.optreq>
		
		
		<cfloop condition="#args.whileHasNext()#">
			<cfset foundkeys = ListAppend(foundkeys, args.key)>
			<cfset reqindex  = ListFind(requireds, args.key)>
			<cfif reqindex>
				<cfset requireds = ListDeleteAt(requireds, reqindex)>
			</cfif>
			<cfif StructKeyExists(out, args.key)>
				<cfset StructUpdate(out, args.key, getValidatedValue(args.current, variables.optnames[args.key]))>
			</cfif>
		</cfloop>
		
		<cfif ListLen(requireds)>
			<cfthrow message="requireds (#requireds#) missing">
		</cfif>
		
		<cfreturn out>
	</cffunction>
	
	<cffunction name="getValidatedValue">
		<cfargument name="currarg" type="any" required="true">
		<cfargument name="curropt"  type="any" required="true">
		
		<cfset var arg = arguments.currarg>
		<cfset var out = arguments.curropt>
		
		<cfset var type = getType(arg)>
		<cfset var conv = StructKeyExists(out.typeconv, type)>

		<cfif (type eq out.outtype) OR conv>
			<cfif conv>
				<cfset conv = out.typeconv[type]>
				<cftry>
					<cfinvoke component="#conv.getComponent()#" method="#conv.getMethod()#" returnvariable="arg">
						<cfinvokeargument name="#conv.getParameter()#" value="#arg#">
					</cfinvoke>
					<cfcatch type="any">
						<cfdump var="#cfcatch#">
						<cfthrow message="convert function error">
					</cfcatch>
				</cftry>
				<!--- <p>-- Function call</p> --->
			</cfif>
		<cfelse>
			<cfthrow message="type error">
		</cfif>
		<cfreturn arg>
	</cffunction>

	<cffunction name="getOptions">
		<cfreturn variables.options>
	</cffunction>
	
	<cffunction name="typeconv">
		<cfargument name="intype"  required="true" type="string">
		<cfargument name="component" required="true" type="any">
		<cfargument name="method"    required="true" type="string">
		<cfargument name="parameter" required="true" type="string">
		
		<cfset var i = ArrayLen(variables.options)>
		<cfset var c = "">
		<cfif i eq 0>
			<cfthrow message="typeconv called without existing outtype">
		</cfif>
		<cfset c = createObject("component", "ArgConverter").init(variables.options[i].outtype, arguments.intype, arguments.component, arguments.method, arguments.parameter)>
		<cfreturn addConvertor(c)>
	</cffunction>
	
	<cffunction name="addConvertor">
		<cfargument name="argconvert" required="true" type="ArgConverter">
			<cfset var i = ArrayLen(variables.options)>
			<cfset var p = "">
			<cfset var a = arguments.argconvert>
			
			<cfif i eq 0>
				<cfthrow message="typeconv called without existing outtype">
			</cfif>
			
			<cfset p = variables.options[i]>
			<cfif p.outtype neq a.getOutType()>
				<cfthrow message="argmentconverter outtype doesn't match argument outtype">
			</cfif>
			<cfset StructInsert(p.typeconv, a.getInType(), a, true)>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="option">
		<cfargument name="outkey" required="true" type="string">
		<cfargument name="outtype" required="true" type="string">
		<cfargument name="required" required="false" type="boolean" default="true">
		<cfargument name="outdefault" required="false" type="any" default="">
		<cfargument name="typeconv" required="false" type="struct" default="#StructNew()#">
		
			<cfset var parseble = StructNew()>
			<cfset parseble["retkey"]     = arguments.outkey>
			<cfset parseble["outtype"]    = arguments.outtype>
			<cfset parseble["retdefault"] = arguments.outdefault>
			<cfset parseble["required"]   = arguments.required>
			<cfset parseble["typeconv"]   = typeconv>
			
			<cfset ArrayAppend(variables.options,parseble)>
			<cfset StructInsert(variables.optnames, arguments.outkey,parseble)>
			<cfif arguments.required>
				<cfset variables.optreq   = ListAppend(variables.optreq,arguments.outkey)>
			</cfif>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="iterator">
		<cfargument name="iterable" required="true">
		<cfreturn createObject("component", "cfc.db.Iterator").init(arguments.iterable)>
	</cffunction>
	
	<cffunction name="gettype">
		<cfargument name="obj" required="true" type="any">
		<cfset var t = getMetaData(arguments.obj)>
		<cfoutput>#t.getClass().getSuperClass().getName()#</cfoutput>
		<cftry>
			<cfset t = t.getName()>
			<cfcatch type="any">
				<cftry>
					<cfset t = t.name>
					<cfcatch type="any">
						<cfset t = "TERRIBLE TYPE ERROR!">
					</cfcatch>
				</cftry>
			</cfcatch>
		</cftry>
		<cfreturn LCASE(ListLast(t, "."))>
	</cffunction>
	
</cfcomponent>