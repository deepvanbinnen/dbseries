<cfcomponent name="dbtableproxy">
	
	<cffunction name="init">
		<cfargument name="dbtable" type="dbtable" required="true">
			<cfset this.t = arguments.dbtable>
			<cfset variables.PK  = "primarykey">
			<cfset variables.dbtable = arguments.dbtable>
			<cfset variables.primarykeys = variables.dbtable.getPrimaryKeys()>
			<cfset variables.ds  = variables.dbtable.getDS()>
			<cfset variables.dbrecord    = createObject("component", "dbrecord").init(tableObj=variables.dbtable, record=StructNew(), isnew=false)>
			<cfset variables.filtersets  = StructNew()>
			
			<cfset variables.selectcols = "*">
			
			<cfset orderBy()>
			<cfset createPKFilterSet()>
			<cfset resetSelectCols()>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getUtil" returntype="utils" access="public">
		<cfreturn variables.dbtable.getUtil()>
	</cffunction>
	
	<cffunction name="resetSelectCols" returntype="void" access="public">
		<cfset this.selectcols = variables.selectcols>
	</cffunction>
	
	<cffunction name="getPrimaryKeys" returntype="any" access="public">
		<cfreturn variables.primarykeys>
	</cffunction>
	
	<cffunction name="getPrimaryKeyColumns" returntype="any" access="public">
		<cfreturn StructKeyList(variables.primarykeys)>
	</cffunction>
	
	<cffunction name="clearFilters" returntype="void" access="public">
		<cfset var it = getUtil().iterator(variables.filtersets)>
		<cfloop condition="#it.whileHasNext()#">
			<cfif it.current.isTemporary()>
				<cfset StructDelete(variables.filtersets, it.key)>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="hasNamedArguments" returntype="boolean">
		<cfargument name="args" required="true" type="struct">
		<cfreturn getUtil().namedArguments(arguments.args)>
	</cffunction>
	
	<cffunction name="ListHasList" returntype="boolean">
		<cfreturn getUtil().ListHasList(arguments)>
	</cffunction>
	
	<cffunction name="filter" returntype="dbfilterset" access="public">
		<cfset var fs = getFilterSet()>
		<cfset var a  = StructNew()>
		<cfset var it = getUtil().iterator(arguments)>
		<cfloop condition="#it.whileHasNext()#">
			<cfset StructInsert(a, it.key, arguments[it.key])>
		</cfloop>
		<cfset fs.filter(argumentCollection=a)>
		<cfreturn fs>
	</cffunction>
	
	<cffunction name="filter2" returntype="struct" access="public">
		<cfset var filterArgParser = createObject("component", "cfc.db.ArgParser").init()>
		<cfset filterArgParser.option("columnname", "dbcolumn", true).typeconv("string", this, "getColumn", "columnname")>
		<cfset filterArgParser.option("operator", "string", false, "=")>
		<cfset filterArgParser.option("value", "string", false)>
		<cfset filterArgParser.option("isand", "boolean", false, true)>
		<cfreturn filterArgParser.get(arguments.values())>
	</cffunction>
	
	<cffunction name="getFilterSets" returntype="struct" access="public">
		<cfreturn variables.filtersets>
	</cffunction>
	
	<cffunction name="createPKFilterSet" returntype="void" access="public">
		<cfset var it = getUtil().iterator(variables.primarykeys)>
		<cfset var fs = createFilterSet("primarykey")>
		
		<cfloop condition="#it.whileHasNext()#">
			<cfset fs.andEQ(it.current)>
		</cfloop>
	</cffunction>
	
	<cffunction name="getPKFilterSet" returntype="array" access="public">
		<cfreturn getFilterSetArray("primarykey")>
	</cffunction>
	
	<cffunction name="getFilterSetArray" returntype="array" access="private">
		<cfargument name="filtersetname" required="true" type="string">
		
		<cfif StructKeyExists(variables.filtersets, arguments.filtersetname)>
			<cfreturn variables.filtersets[arguments.filtersetname].get()>
		</cfif>
		<cfreturn ArrayNew(1)>
	</cffunction>
	
	<cffunction name="getFilterSet" returntype="dbfilterset" access="private">
		<cfargument name="filtersetname" default="" required="false" type="string">
		
		<cfif NOT StructKeyExists(variables.filtersets, arguments.filtersetname)>
			<cfreturn createFilterSet(arguments.filtersetname)>
		</cfif>
		<cfreturn variables.filtersets[arguments.filtersetname]>
	</cffunction>
	
	<cffunction name="addFilterSet" returntype="dbfilterset" access="private">
		<cfargument name="filtersetname" required="true" type="string">
		<cfargument name="filterset" required="true" type="dbfilterset">

		<cfif NOT StructKeyExists(variables.filtersets, arguments.filtersetname)>
			<cfset StructInsert(variables.filtersets, arguments.filtersetname, arguments.filterset)>
		</cfif>
		<cfreturn getFilterSet(arguments.filtersetname)>
	</cffunction>
	
	<cffunction name="createFilterSet" returntype="dbfilterset" access="public">
		<cfargument name="filtersetname" default="" required="false" type="string">
		<cfargument name="isand" default="true" required="false" type="boolean">
		
		<cfset var temp = false>
		<cfset var fn = arguments.filtersetname>
		
		<cfif fn eq "">
			<cfset temp = true>
			<cfset fn = createUUID()>
		</cfif>
		<cfreturn addFilterSet(fn, createObject("component", "dbfilterset").init(this, arguments.isand, temp))>
	</cffunction>
	
	
	<cffunction name="getRecordQuery" returntype="query" access="public">
		<cfargument name="filterset"  required="no" type="array" default="#ArrayNew(1)#">
		<cfargument name="debug"      required="no" type="boolean" default="false">
		
		<cfset var q = QueryNew("")>
		<cfset var pk = getUtil().iterator(arguments.filterset)>
		<cfset var dbg = arguments.debug>
		
		<cftry>
			<cfquery name="q" datasource="#variables.ds#" result="x">
			SELECT #this.selectcols#
			FROM   #getTableName()#
			<cfif pk.getLength()>
				WHERE 
					<cfloop condition="#pk.whileHasNext()#">
						<cfif pk.index neq 1>
							#pk.current.getAnd()#
						</cfif>
						#pk.current.getColumnName()# 
						#pk.current.getOperator()#
						<cfif pk.current.isList()>
						(
						</cfif>
						<cfqueryparam cfsqltype="#pk.current.getColumn().getCFDataType()#" value="#pk.current.getValue()#" list="#pk.current.isList()#">
						<cfif pk.current.isList()>
						)
						</cfif>
					</cfloop>
			</cfif>
			<cfif getOrderBy() neq "">
				ORDER BY #getOrderBy()#
			</cfif>
			</cfquery>
			
			<cfset resetSelectCols()>
			<cfset clearFilters()>
			
			<!--- <cfdump var="#x#"> --->
			<cfcatch type="any">
				<cfdump var="#cfcatch	#">
				<cfset q = getUtil()._throwQueryError(cfcatch)>
			</cfcatch>
		</cftry>
			
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getRecords" returntype="dbrecordset" access="public">
		<cfreturn createRecordSet(getRecordQuery())>
	</cffunction>
	
	<cffunction name="getRecordByIdQuery" returntype="query" access="public">
		<cfset var fltarr = getFilterSetArray("primarykey")>
		<cfset var result = "">
		
		<cfif ArrayLen(arguments) gte ArrayLen(fltarr)>
			<cfset fltarr[1].setValue(arguments[1])>
		</cfif>
		
		<cfreturn getRecordQuery(fltarr)>
	</cffunction>
	
	<cffunction name="getRecordById" returntype="dbrecordset" access="public">
		<cfreturn createRecordSet(getRecordByIdQuery(argumentCollection=arguments), false)>
	</cffunction>
	
	<cffunction name="getColumnDefault" returntype="struct" access="public">
		<cfreturn variables.dbtable.getColumnDefault()>
	</cffunction>
	
	<cffunction name="columnExists" returntype="boolean" access="public">
		<cfargument name="columnname" type="string" required="true">
		<cfreturn variables.dbtable.columnExists(arguments.columnname)>
	</cffunction>
	
	<cffunction name="getColumn" returntype="dbcolumn" access="remote">
		<cfargument name="columnname" type="string" required="true">
		<cfreturn variables.dbtable.getColumn(arguments.columnname)>
	</cffunction>
	
	<cffunction name="getColumn2" returntype="dbcolumn" access="public">
		<cfargument name="columnname" type="string" required="true">
		<cfinvoke component="#this#" method="getColumn" columnname="#arguments.columnname#" returnvariable="returnvar"></cfinvoke>
		<cfreturn returnvar>
	</cffunction>
	
	<cffunction name="createRecord" returntype="dbrecord" access="public">
		<cfset var colDefault = getColumnDefault()>
		<cfreturn variables.dbrecord.create(record=colDefault, isnew=true)>
	</cffunction>
	
	<cffunction name="createRecordSet" returntype="dbrecordset" access="public">
		<cfargument name="records" type="query" required="true">
		<cfargument name="multipleresult" type="boolean" required="false" default="true">
		
		<cfset var recordset = createObject("component", "dbrecordset").init(variables.dbrecord, arguments.multipleresult, arguments.records.columnlist)>
		<cfset recordset.add(records)>
		<cfreturn recordset>
	</cffunction>
	
	<cffunction name="getTableName" returntype="string" access="package">
		<cfreturn variables.dbtable.getTableName()>
	</cffunction>
	
	<cffunction name="orderBy" returntype="dbtableproxy" access="public">
		<cfargument name="orderClause" type="string" required="false" default="">		
		<cfset variables.orderClause = arguments.orderClause>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setSelectCols" returntype="dbtableproxy" access="public">
		<cfargument name="selectcols" type="string" required="true">		
			<cfset variables.selectcols = arguments.selectcols>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="select" returntype="dbtableproxy" access="public">
		<cfargument name="selectcols" type="string" required="true">		
			<cfset this.selectcols = arguments.selectcols>
			<cfset this.columnlist = arguments.selectcols>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getSelectCols" returntype="string" access="public">
		<cfreturn this.columnlist>
	</cffunction>

	<cffunction name="getOrderBy" returntype="string" access="public">
		<cfreturn variables.orderClause>
	</cffunction>
	
	<cffunction name="dump" returntype="struct" access="public">
		<cfset var keyvalue = StructNew()>
		<cfset var it = getUtil().iterator(variables.filtersets)>
		<cfset var DBTable = "DBTable">
		<cfset var SelectColumns = "Select">
		<cfset var Filtersets = "Filtersets">
		
		<cfset StructInsert(keyvalue, SelectColumns, this.selectcols)>
		<cfset StructInsert(keyvalue, DBTable, variables.dbtable.dump())>
		<cfset StructInsert(keyvalue, Filtersets, StructNew())>
		
		<cfloop condition="#it.whileHasNext()#">
			<cfset StructInsert(keyvalue[Filtersets], it.key, it.current.innerdump())>
		</cfloop>
		<cfreturn keyvalue>
	</cffunction>
	
</cfcomponent>