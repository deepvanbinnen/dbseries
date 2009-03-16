<cfcomponent name="DBRecord" output="false">
	<cfset variables.isvalidrecord = true>
	
	<cffunction name="init" returntype="DBRecord" output="yes">
		<cfargument name="tableObj" type="dbtable" required="true">
		<cfargument name="record"   type="struct" required="true">
		<cfargument name="isnew"    type="boolean" required="true">
		
		<cfset var isempty = true>
		<cfset var column = "">
		<cfset variables.tableObj = arguments.tableObj>
		<cfset variables.isnew = arguments.isnew>
		<cfset variables.ds = variables.tableObj.getDS()>
		
		<cfloop collection="#arguments.record#" item="column">
			<cfset StructInsert(this, column, arguments.record[column])>
			<cfset isempty = false>
		</cfloop>
		<cfset _setUtil()>
		<cfset _setIsEmpty(isempty)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create">
		<cfargument name="record" type="struct"  required="true">
		<cfargument name="isnew"  type="boolean" required="false" default="false">
		<cfreturn createObject("component", "dbrecord").init(tableObj=variables.tableObj, record=arguments.record, isnew=arguments.isnew)>
	</cffunction>
	
	<cffunction name="_setUtil" access="public">
		<cfset this.util = variables.tableObj.getUtil()>
	</cffunction>
	
	<cffunction name="getUtil" access="public">
		<cfreturn this.util>
	</cffunction>
	
	<cffunction name="_setIsEmpty" access="public">
		<cfargument name="isempty"  type="boolean" required="true">
		<cfset variables.isempty = arguments.isempty>
	</cffunction>
	
	<cffunction name="isEmpty" access="public">
		<cfreturn variables.isempty>
	</cffunction>
	
	<cffunction name="isSave" access="public">
		<cfreturn variables.isvalidrecord>
	</cffunction>
	
	<cffunction name="save" access="public">
		<cfif isSave()>
			<cfif isNewRecord()>
				<cfset insertRecord()>
			<cfelse>
				<cfset updateRecord()>			
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="delete" access="public">
		<cfif isSave()>
			<cfif NOT isNewRecord()>
				<cfset deleteRecord()>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="haskey" returntype="boolean" output="yes">
		<cfargument name="key" type="string" required="true">
		<cfreturn StructKeyExists(this, key)>
	</cffunction>
	
	<cffunction name="isPrimaryKey" returntype="boolean" output="yes">
		<cfargument name="key" type="string" required="true">
		<cfreturn getColumn(arguments.key).isPrimaryKey()>
	</cffunction>
	
	<cffunction name="getCFDataType" returntype="string" output="yes">
		<cfargument name="key" type="string" required="true">
		<cfreturn getColumn(arguments.key).getCFDataType()>
	</cffunction>
	
	<cffunction name="getColumn" returntype="any" output="yes">
		<cfargument name="key" type="string" required="true">
		<cfreturn variables.tableObj.getColumn(arguments.key)>
	</cffunction>
	
	<cffunction name="isNewRecord" returntype="boolean" output="yes">
		<cfreturn variables.isnew>
	</cffunction>
	
	<cffunction name="get" returntype="string" output="yes">
		<cfargument name="key" type="string" required="true">
		<cfif haskey(key)>
			<cfreturn this[key]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="set" returntype="DBRecord" output="yes">
		<cfargument name="key" type="string" required="true">
		<cfargument name="val" type="any" required="true">
		<cfif haskey(key)>
			<cfset StructUpdate(this, arguments.key, arguments.val)>
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="setKeys" returntype="DBRecord" output="yes">
		<cfloop collection="#arguments#" item="name">
			<cfif haskey(key)>
				<cfset StructUpdate(this, name, arguments[name])>
			</cfif>
		</cfloop> 
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getKeys" returntype="string" output="yes">
		<cfargument name="excludepk" type="boolean" required="false" default="false">
		<cfset var keys = "">
		<cfloop collection="#this#" item="name">
			<cfif IsSimpleValue(this[name])>
				<cfif NOT isPrimaryKey(name) OR NOT arguments.excludepk>
					<cfset keys = ListAppend(keys, name)>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn keys>
	</cffunction>
	
	<cffunction name="insertRecord" returntype="void" access="package">
		<cfset var q    = "">
		<cfset var cols = getKeys(excludepk=true)>
		<cfset var it   = getUtil().iterator(cols)>
		
		<cfquery name="q" datasource="#variables.ds#">
			INSERT INTO #getTableName()# (
				#cols#
			)
			VALUES (
			<cfloop condition="#it.whileHasNext()#">
				<cfif it.index neq 1>,</cfif>
				<!--- #it.key# = #arguments.record.get(it.current)# #arguments.record.getCFDataType(it.current)# --->
					<cfqueryparam value="#get(it.current)#" cfsqltype="#getCFDataType(it.current)#">
			</cfloop>
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="updateRecord" returntype="void" access="package">
		<cfset var q  = "">
		<cfset var it = getUtil().iterator(getKeys(excludepk=true))>
		<cfset var pk = getUtil().iterator(createPKFilterSet().get())>
		
		<cfif it.getLength()>
			<cfquery name="q" datasource="#variables.ds#">
				<cfoutput>
					UPDATE #getTableName()# 
					SET 
					<cfloop condition="#it.whileHasNext()#">
						<cfif it.index neq 1>,</cfif>
						<!--- #it.key# = #arguments.record.get(it.current)# #arguments.record.getCFDataType(it.current)# --->
	 					#it.current# = <cfqueryparam value="#get(it.current)#" cfsqltype="#getCFDataType(it.current)#">
					</cfloop>
					WHERE
					<cfloop condition="#pk.whileHasNext()#">
						<cfif pk.index neq 1>
							#pk.current.getAnd()#
						</cfif>
						#pk.current.getColumnName()# 
						#pk.current.getOperator()#
						<!--- #pk.current.getCFDataType()# #pk.key# #arguments.record.get(pk.current.getColumnName())# --->
						<cfqueryparam cfsqltype="#pk.current.getCFDataType()#" value="#get(pk.current.getColumnName())#">
					</cfloop>
				</cfoutput>
			</cfquery>
		</cfif>
		
	</cffunction>
	
	<cffunction name="deleteRecord" returntype="void" access="package">
		<cfset var q  = "">
		<cfset var it = getUtil().iterator(getKeys(excludepk=true))>
		<cfset var pk = getUtil().iterator(createPKFilterSet().get())>
		
		<cfquery name="q" datasource="#variables.ds#">
			DELETE FROM #getTableName()# 
			WHERE
			<cfloop condition="#pk.whileHasNext()#">
				<cfif pk.index neq 1>
					#pk.current.getAnd()#
				</cfif>
				#pk.current.getColumnName()# 
				#pk.current.getOperator()#
				<!--- #pk.current.getCFDataType()# #pk.key# #arguments.record.get(pk.current.getColumnName())# --->
				<cfqueryparam cfsqltype="#pk.current.getCFDataType()#" value="#get(pk.current.getColumnName())#">
			</cfloop>
		</cfquery>
	</cffunction>
	
	<cffunction name="getTableName" returntype="string" access="package">
		<cfreturn variables.tableObj.getTableName()>
	</cffunction>
	
	<cffunction name="getDS" returntype="string" access="package">
		<cfreturn variables.tableObj.getDS()>
	</cffunction>
	
	<cffunction name="getProperties" returntype="struct" access="public">
		<cfset var s = StructNew()>
		<cfset var it = getUtil().iterator(getKeys())>
	
		<cfloop condition="#it.whileHasNext()#">
			<cfif StructKeyExists(this,it.current) AND IsSimpleValue(this[it.current])>	
				<cfset StructInsert(s, it.current, this[it.current])>
			</cfif>
		</cfloop>
		<cfreturn s>
	</cffunction>
	
	<cffunction name="propiterator" returntype="Iterator">
		<cfreturn getUtil().iterator(getProperties())>
	</cffunction>
	
	<cffunction name="iterator" returntype="Iterator">
		<cfreturn getUtil().iterator(getProperties())>
	</cffunction>
	
	<cffunction name="dump" returntype="struct" access="public">
		<cfset var keyvalue = StructNew()>
		<cfset var it = iterator()>
	
		<cfloop condition="#it.whileHasNext()#">
			<cfif StructKeyExists(this,it.key) AND IsSimpleValue(this[it.key])>	
				<cfset StructInsert(keyvalue, it.key, this[it.key])>
			</cfif>
		</cfloop>
		
		<cfreturn keyvalue>
	</cffunction>
</cfcomponent>