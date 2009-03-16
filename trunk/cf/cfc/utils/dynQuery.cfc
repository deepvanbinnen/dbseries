<cfcomponent output="No" displayname="dynQuery" hint="provides an interface for dynamic queries" extends="dynRow">

	<cffunction name="init" hint="creates a query based on a columnlist and returns a new row ">
		<cfargument name="lColumnlist" required="Yes" type="string">
		<cfset this.Query = this.createQuery(arguments.lColumnlist)>
		<cfset super.init(this.Query)>
		<cfset this.newRow()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addRow" output="No" returntype="query" hint="adds a new row based on a struct with the columnnames/values">
		<cfargument name="stColumnvalues" required="Yes" type="struct">
		<cfset QueryAddRow(this.Query)>
		<cfloop collection="#arguments.stColumnvalues#" item="sColumnname">
			<cfset QuerySetCell(this.Query,sColumnname,arguments.stColumnvalues[sColumnname])>
		</cfloop>
		<cfreturn this.getQuery()>
	</cffunction>
	
	<cffunction name="appendQuery" output="No" returntype="query" hint="appends a queryresult to the query">
		<cfargument name="qQuery" required="Yes" type="query">
		<cfloop query="arguments.qQuery">
			<cfset this.addRow(this.getRowFromQuery(arguments.qQuery,currentrow))>
		</cfloop>
		<cfreturn this.getQuery()>
	</cffunction>
	
	<cffunction name="getRowFromQuery" output="No" returntype="struct" hint="returns a row-object from a query-result">
		<cfargument name="qQuery" required="Yes" type="query">
		<cfargument name="iRowNum" required="Yes" type="numeric">
		
		<cfset var sColList = arguments.qQuery.columnlist>
		<cfset var stTmpRow = this.getEmptyRow()>
		<cfloop list="#sColList#" index="thiscol">
			<cfset stTmpRow[thiscol] = arguments.qQuery[thiscol][arguments.iRowNum]>
		</cfloop>
		<cfreturn stTmpRow>
	</cffunction>
	
	<cffunction name="createSequence" output="No" returntype="string" hint="returns a sequence of numbers based on start and and value">
		<cfargument name="iStart" required="Yes" type="numeric">
		<cfargument name="iEnd" required="Yes" type="numeric">
		<cfargument name="iStep" required="No" type="numeric" default="1">
		<cfset var lSequence = "">
		<cfloop from="#arguments.iStart#" to="#arguments.iEnd#" step="#arguments.iStep#" index="i">
			<cfset lSequence = ListAppend(lSequence,i)>
		</cfloop>
		
		<cfreturn lSequence>
	</cffunction>
	
	<cffunction name="clearQuery" output="No" returntype="query" hint="clears all records in the queryobject">
		<cfset var lRownumbers = this.createSequence(1,this.Query.recordcount)>
		<cfreturn this.deleteRows(lRownumbers)>
	</cffunction> 
	
	<cffunction name="createQuery" output="No" returntype="query" hint="returns a new query in memory">
		<cfargument name="lColumnlist" required="Yes" type="string">
		<cfset var qOutquery = QueryNew(arguments.lColumnlist)>
		<cfreturn qOutquery>
	</cffunction>
	
	<cffunction name="deleteRows" output="No" returntype="query" hint="deletes a (list of) row(s) from the query based on rownumber">
		<cfargument name="rownumbers" required="Yes" type="string">
		<cfset var tmpQuery = createQuery(this.Query.columnlist)>
		
		<cfloop query="this.Query">
			<cfif NOT ListFind(arguments.rownumbers,currentrow)>
				<cfset QueryAddRow(tmpQuery)>
				<cfloop list="#this.Query.columnlist#" index="col">
					<cfset QuerySetCell(tmpQuery, col, this.Query[col][currentrow])>
				</cfloop>
			</cfif>
		</cfloop>
		<cfset this.Query = tmpQuery>
		<cfreturn this.getQuery()>
	</cffunction>
	
	<cffunction name="getCurrentRow" output="No" returntype="struct" hint="gets the current row">
		<cfreturn this.stCurRow>
	</cffunction>
	
	<cffunction name="getEmptyRow" output="No" returntype="struct" hint="creates and returns an empty row object based on this query without setting it as the currentrow">
		<cfreturn super.getEmptyRow()>
	</cffunction>
		
	<cffunction name="getNewRowWithValues" output="No" returntype="struct" hint="creates and returns a row filled with values without setting it as the currentrow">
		<cfargument name="stColumnvalues" required="Yes" type="struct">
		<cfset var row = this.getEmptyRow()>
		<cfset row = super.setRowColumns(row,stColumnvalues)>
		<cfreturn row>
	</cffunction>
	
	<cffunction name="getRownumsForSubQuery" output="yes" returntype="string" hint="returns the rownumbers for a given query-on-query result">
		<cfargument name="qOriginal" required="Yes" type="query">
		<cfargument name="qResult" required="Yes" type="query">
		<cfset var lRownums = "">
		<cfset var bFound = TRUE>
		<cfloop query="arguments.qOriginal">
			<cfloop from="1" to="#arguments.qResult.recordcount#" index="i">
				<cfif NOT ListFind(lRownums,currentrow)>
					<cfset bFound = TRUE>
					<cfloop list="#arguments.qResult.columnlist#" index="col">
						<cfif arguments.qOriginal[col][currentrow] neq arguments.qResult[col][i]>
							<cfset bFound = FALSE>
							<cfbreak>
						</cfif>
					</cfloop>
					<cfif bFound>
						<cfset lRownums = ListAppend(lRownums,currentrow)>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>
		<cfreturn lRownums>
	</cffunction> 
 
	<cffunction name="getQuery" output="No" returntype="query" hint="returns the queryobject">
		<cfreturn this.Query>
	</cffunction>
	
	<cffunction name="newRow" output="No" returntype="struct" hint="creates an empty row and sets it as the current row">
		<cfreturn this.setCurrentRow(this.getEmptyRow())>
	</cffunction>
	
	<cffunction name="reverseQuery" output="No" returntype="query" hint="ordinary reverse a queryresult">
		<cfargument name="qQuery" required="Yes" type="query">
		<cfset var tmpQuery = createQuery(arguments.qQuery.columnlist)>
		
		<cfloop from="#arguments.qQuery.recordcount#" to="1" index="i" step="-1">
			<cfset QueryAddRow(tmpQuery)>
			<cfloop list="#tmpQuery.columnlist#" index="col">
				<cfset QuerySetCell(tmpQuery, col, arguments.qQuery[col][i])>
			</cfloop>
		</cfloop>
		
		<cfreturn tmpQuery>
	</cffunction>
	
	<cffunction name="setColumns" output="No" returntype="struct" hint="updates a set of column values in the current row">
		<cfargument name="stColumnvalues" required="Yes" type="struct">
		<cfreturn super.setRowColumns(this.stCurRow,arguments.stColumnvalues)>
	</cffunction>
	
	<cffunction name="setColumn" output="No" returntype="struct" hint="updates a column value in the current row">
		<cfargument name="stColumnName" required="Yes" type="string">
		<cfargument name="stColumnValue" required="Yes" type="string">
		<cfreturn super.setRowColValue(this.stCurRow,arguments.stColumnName,stColumnValue)>
	</cffunction>

	<cffunction name="setColumnsForRowNum" output="No" returntype="query" hint="gets a row by rownumber">
		<cfargument name="iRowNumber" required="Yes" type="numeric">
		<cfargument name="stColumnvalues" required="Yes" type="struct">
		<cfloop collection="#arguments.stColumnvalues#" item="sColumnname">
			<cfset this.setColumnForRowNum(sColumnname,arguments.stColumnvalues[sColumnname], arguments.iRowNumber)>
		</cfloop>
		<cfreturn this.getQuery()>
	</cffunction>
	
	<cffunction name="setColumnForRowNum" output="No" returntype="query" hint="gets a row by rownumber">
		<cfargument name="iRowNumber" required="Yes" type="numeric">
		<cfargument name="stColumnName" required="Yes" type="string">
		<cfargument name="stColumnValue" required="Yes" type="string">
		<cfset QuerySetCell(this.Query, arguments.stColumnName, arguments.stColumnValue, arguments.iRowNumber)>
		<cfreturn this.getQuery()>
	</cffunction>
	
	<cffunction name="setCurrentRow" output="No" returntype="struct" hint="sets the current row">
		<cfargument name="stRow" required="Yes" type="struct">
		<cfset this.stCurRow = arguments.stRow>
		<cfreturn this.getCurrentRow()>
	</cffunction>
	
	<cffunction name="listToRow" output="No" returntype="struct" hint="returns a row based on given columnnames and listvalues">
		<cfargument name="sColNames" required="Yes" type="string">
		<cfargument name="sColValues" required="Yes" type="string">
		<cfargument name="sColValDelimiter" required="No" type="string" default=",">
		
		<cfset var stOut = StructNew()>
		<cfset var sVal = "">
		<cfloop from="1" to="#ListLen(arguments.sColNames)#" index="i">
			<cfset sVal = ListGetAt(arguments.sColValues,i,arguments.sColValDelimiter)>
			<cfif UCASE(sVal) eq "NULL"><cfset sVal = ""></cfif>
			<cfset stOut[ListGetAt(arguments.sColNames,i)] = sVal>
		</cfloop>
		
		<cfreturn stOut>
	</cffunction>
	
</cfcomponent>