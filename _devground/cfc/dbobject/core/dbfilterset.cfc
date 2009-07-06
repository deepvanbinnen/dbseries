<cfcomponent name="dbfilterset">
	<cfset variables.tblproxy = ArrayNew(1)>
	<cfset variables.filters = ArrayNew(1)>
	<cfset variables.isand   = true>
	<cfset variables.istemp  = true>
	
	
	<cffunction name="init" returntype="dbfilterset">
		<cfargument name="tableproxy" type="dbtableproxy" required="true">
		<cfargument name="isand" type="boolean" required="false" default="#variables.isand#">
		<cfargument name="istemp" type="boolean" required="false" default="#variables.istemp#">
		<cfset variables.tblproxy = arguments.tableproxy>
		<cfset variables.istemp = arguments.istemp>
		<cfset _setUtil()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" returntype="array">
		<cfreturn variables.filters>
	</cffunction>
	
	<cffunction name="isAndSet" returntype="boolean">
		<cfreturn variables.isand>
	</cffunction>
	
	<cffunction name="isTemporary" returntype="boolean">
		<cfreturn variables.istemp>
	</cffunction>
	
	<cffunction name="getRecordQuery" returntype="query">
		<cfreturn variables.tblproxy.getRecordQuery(get())>
	</cffunction>
	
	<cffunction name="getRecords" returntype="dbrecordset" access="public">
		<cfreturn variables.tblproxy.createRecordSet(getRecordQuery())>
	</cffunction>
	
	<cffunction name="_setUtil" returntype="void" access="private">
		<cfset variables.util = createObject("component","utils").init()>
	</cffunction>
	
	<cffunction name="getUtil" returntype="utils" access="public">
		<cfreturn variables.util>
	</cffunction>
	
	<cffunction name="addFilterDefArray" returntype="dbfilterset" access="public">
		<cfargument name="fltdef" required="true" type="array">
		<cfargument name="isand" required="false" type="boolean">
		<cfargument name="operator" required="false" type="string">
		
		
		<cfset var it  = getUtil().iterator(arguments.fltdef)>
		<cfset var bAnd = "">
		<cfset var op = IsDefined("arguments.operator")>
		
		<cfloop condition="#it.whileHasNext()#">
			<cfif IsDefined("arguments.isAnd")>
				<cfset bAnd = arguments.isAnd>
			<cfelse>
				<cfset bAnd = it.current.isand>
			</cfif>
			<cfif IsDefined("arguments.operator")>
				<cfset op = arguments.operator>
			<cfelse>
				<cfset op = it.current.operator>
			</cfif>
			<cfset create(it.current.columnname, op, it.current.value, bAnd)>
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="filter" returntype="dbfilterset" access="public">
		<cfreturn addFilterDefArray(convertFilterArgs(arguments))>
	</cffunction>
	
	<cffunction name="orfilter" returntype="dbfilterset" access="public">
		<cfset var arg = convertFilterArgs(arguments)>
		<cfset var it  = getUtil().iterator(arg)>
		
		<cfloop condition="#it.whileHasNext()#">
			<cfset create(it.current.columnname, it.current.operator, it.current.value, false)>
			<!--- <cfoutput>#it.current.columnname.getColumnname()#, #it.current.operator#, #it.current.value#, #it.current.isand#</cfoutput> --->
		</cfloop>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="andEQ" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "=">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orEQ" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "=">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andNEQ" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "<>">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orNEQ" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "<>">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andIN" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "IN">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andNotIN" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "NOT IN">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orNotIN" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "NOT IN">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andLIKE" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "LIKE">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orLIKE" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "LIKE">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andNotLIKE" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "NOT LIKE">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orNotLIKE" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "NOT LIKE">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andSW" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "SW">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orSW" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "SW">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andNotSW" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "NOT SW">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orNotSW" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "NOT SW">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andEW" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "EW">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orEW" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "EW">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andGT" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "GT">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orGT" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "GT">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andGTE" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "GTE">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orGTE" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "GTE">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andLT" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "LT">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orLT" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "LT">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andLTE" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "LTE">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orLTE" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "LTE">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="andNotEW" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "NOT EW">
		<cfset var isand    = true>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="orNotEW" returntype="dbfilterset">
		<cfset var arg      = convertFilterArgs(arguments)>
		<cfset var operator = "NOT EW">
		<cfset var isand    = false>
		
		<cfreturn addFilterDefArray(fltdef=arg, operator=operator, isand=isand)>
	</cffunction>
	
	<cffunction name="create" returntype="dbfilterset">
		<cfargument name="column"   type="dbcolumn" required="true">
		<cfargument name="operator" type="string" required="true">
		<cfargument name="value"    type="any"      required="false" default="">
		<cfargument name="isand"    type="boolean"  required="false" default="true">
		
			<cfset var f = createObject("component", "dbfilter").init(arguments.column, arguments.operator, arguments.value, arguments.isand)>
			
		<cfreturn _add(f)>
	</cffunction>
	
	<cffunction name="columnExists" returntype="boolean" access="public">
		<cfargument name="columnname" type="string" required="true">
		<cfreturn variables.tblproxy.columnExists(arguments.columnname)>
	</cffunction>
	
	<cffunction name="getColumn" returntype="dbcolumn" access="public">
		<cfargument name="columnname" type="string" required="true">
		<cfreturn variables.tblproxy.getColumn(arguments.columnname)>
	</cffunction>
	
	<cffunction name="convertFilterArgs" returntype="array">
		<cfargument name="args" required="true" type="struct">
		
		<cfset var a      = ArrayNew(1)>
		<cfset var s      = StructNew()>
		<cfset var tmp    = "">
		<cfset var arg    = arguments.args>
		<cfset var arglst = StructKeyList(arguments.args)>
		<cfset var debug  = false>
		
		<cfif debug>
			<cfdump var="#arg#">
		</cfif>
		<cfif getUtil().namedArguments(arg)>
			<cfif debug><p>Checking Named Args!</p></cfif>
			<cfset arglist = StructKeyList(arg)>
			<cfif getUtil().ListHasList(arglist,"columnname") OR getUtil().ListHasList(arglist,"dbcolumn")>
				<cfif debug><p>Named Args</p></cfif>
				<cfset s = StructNew()>
				<cfset s.columnname = "">
				<cfif ListFind(arglist,"columnname") AND columnExists(arg.columnname)>
					<cfset s.columnname = getColumn(arg.columnname)>
				<cfelse>
					<cfset s.columnname = getColumn(arg.dbcolumn)>
				</cfif>
				<cfif s.columnname neq "">
					<cfset s.value      =  "">
					<cfset s.operator   =  "=">
					<cfset s.isand      =  true>
					<cfif ListFind(arglist, "value")>
						<cfset s.value = arg.value>
					</cfif>
					<cfif ListFind(arglist, "operator")>
						<cfset s.operator = arg.operator>
					</cfif>
					<cfif ListFind(arglist, "isand")>
						<cfset s.isand = arg.isand>
					</cfif>
					<cfset ArrayAppend(a,s)>
				</cfif>
			<cfelse>
				<cfif debug><p>Named By Column Args!</p></cfif>
				<cfset it = getUtil().iterator(arglist)>
				<cfloop condition="#it.whileHasNext()#">
					<cfif columnExists(it.current)>
						<cfset s = StructNew()>
						<cfset s.columnname = getColumn(it.current)>
						<cfset s.value =  arg[it.current]>
						<cfset s.operator =  "=">
						<cfset s.isand =  true>
						<cfset ArrayAppend(a,s)>
					</cfif>
					<!--- <cfoutput>#it.current# = #arguments[it.current]#</cfoutput> --->
				</cfloop>
			</cfif>
		<cfelse>
			<cfif ListLen(arglst) gt 0>
				<cfif debug><p>Trying to match sequenced args</p></cfif>
				<cfif (IsSimpleValue(arg["1"]) AND columnExists(arg["1"])) OR getUtil().getType(arg["1"]) eq "dbcolumn">
					<cfset s = StructNew()>
					<cfif IsSimpleValue(arg["1"])>
						<cfset s.columnname = getColumn(arg["1"])>
					<cfelse>
						<cfset s.columnname = arg["1"]>
					</cfif>
					<cfset s.value      =  "">
					<cfset s.operator   =  "=">
					<cfset s.isand      =  true>
					<cfif ListLen(arglst) gt 1>
						<cfinvoke component="dbfilter" method="isOperator" operator="#arg['2']#" returnvariable="tmp">
						<cfif tmp>
							<cfif debug><p>Operator found in second arg!</p></cfif>
							<cfset s.operator=arg["2"]>
						<cfelse>
							<cfif debug><p>Value assumed in second arg!</p></cfif>
							<cfset s.value=arg["2"]>
						</cfif>
						<cfif  ListLen(arglst) gt 2>
							<cfif tmp>
								<cfif debug><p>Value set from third arg!</p></cfif>
								<cfinvoke component="dbfilter" method="isOperator" operator="#arg['3']#" returnvariable="tmp">
								<cfset s.value=arg["3"]>
							<cfelse>
								<cfinvoke component="dbfilter" method="isOperator" operator="#arg['3']#" returnvariable="tmp">
								<cfif debug><p>Operator found and set from third arg!</p></cfif>
								<cfset s.operator=arg["3"]>
							</cfif>
							<cfif ArrayLen(arguments) eq 4 AND isBoolean(arguments["4"])>
								<cfset s.isand=arg["4"]>
							</cfif>
						</cfif>
					</cfif>
					<cfset ArrayAppend(a,s)>
				</cfif>
			</cfif>
		</cfif>
		<cfreturn a>
	</cffunction>
	
	<cffunction name="_add" returntype="dbfilterset">
		<cfargument name="filter" type="dbfilter" required="true">
			<cfset ArrayAppend(variables.filters, arguments.filter)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="innerdump" returntype="struct" access="public">
		<cfset var keyvalue = StructNew()>
		<cfset var it = getUtil().iterator(variables.filters)>
		<cfset var Filters = "Filters">
		
		<cfset StructInsert(keyvalue, Filters, ArrayNew(1))>
		<cfset StructInsert(keyvalue, "Temporary", isTemporary())>
		<cfset StructInsert(keyvalue, "Is and?", isAndSet())>
		
		<cfloop condition="#it.hasNext()#">
			<cfset col = it.next()>
			<cfset ArrayAppend(keyvalue[Filters], it.current.dump())>
		</cfloop>
		<cfreturn keyvalue>
	</cffunction>

	<cffunction name="dump" returntype="struct" access="public">
		<cfreturn variables.tblproxy.dump()>
	</cffunction>	
</cfcomponent>