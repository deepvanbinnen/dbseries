<cfcomponent name="dbtable">
	<cfset variables.dbo          = "">
	<cfset variables.ds           = "">
	<cfset variables.fulltable    = "">
	<cfset variables.schemaname   = "">
	<cfset variables.tablename    = "">
	<cfset variables.selectcols   = "*">
	<cfset variables.columns      = StructNew()>
	<cfset variables.orderclause  = "">
	<cfset variables.primarykeys  = StructNew()>
	<cfset variables.foreignkeys  = StructNew()>
	<cfset variables.requiredcols = StructNew()>
	
	<cffunction name="init" returntype="dbtable">
		<cfargument name="dbo"        type="mydbobject" required="true">
		<cfargument name="schemaname" type="string" required="true">
		<cfargument name="tablename"  type="string" required="true">
			<cfset _setDBO(arguments.dbo)>
			<cfset _setDS()>
			<cfset _setSchemaName(arguments.schemaname)>
			<cfset _setTableName(arguments.tablename)>
			<cfset _setFullTableName()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getUtil" returntype="utils" access="public">
		<cfreturn variables.dbo.getUtil()>
	</cffunction>
	
	<cffunction name="getDS" returntype="string" access="public">
		<cfreturn variables.ds>
	</cffunction>
	
	<cffunction name="getFullTableName" returntype="string" access="public">
		<cfreturn variables.fulltable>
	</cffunction>
	
	<cffunction name="getSchemaName" returntype="string" access="public">
		<cfreturn variables.schemaname>
	</cffunction>
	
	<cffunction name="getTableName" returntype="string" access="public">
		<cfreturn variables.tablename>
	</cffunction>
	
	<cffunction name="getPrimaryKeys" returntype="struct" access="public">
		<cfreturn variables.primarykeys>
	</cffunction>
	
	<cffunction name="getPrimaryKeyColumns" returntype="string" access="public">
		<cfreturn StructKeyList(variables.primarykeys)>
	</cffunction>
	
	<cffunction name="getForeignKeys" returntype="struct" access="public">
		<cfreturn variables.foreignkeys>
	</cffunction>
	
	<cffunction name="getForeignKeyColumns" returntype="string" access="public">
		<cfreturn StructKeyList(variables.foreignkeys)>
	</cffunction>
	
	<cffunction name="getRequired" returntype="struct" access="public">
		<cfreturn variables.requiredcols>
	</cffunction>
	
	<cffunction name="getRequiredColumns" returntype="string" access="public">
		<cfreturn StructKeyList(variables.requiredcols)>
	</cffunction>
	
	<cffunction name="columnExists" returntype="boolean" access="public">
		<cfargument name="columnname" type="string" required="true">
		<cfreturn StructKeyExists(variables.columns, arguments.columnname)>
	</cffunction>
	
	<cffunction name="getColumnList" returntype="string" access="public">
		<cfreturn StructKeyList(variables.columns)>	
	</cffunction>
	
	<cffunction name="getColumn" returntype="dbcolumn" access="public">
		<cfargument name="columnname" type="string" required="true">
		<cfif columnExists(arguments.columnname)>
			<cfreturn variables.columns[arguments.columnname]>
		<cfelse>
			<cfthrow message="#arguments.columnname# can not be found!">
		</cfif>
	</cffunction>
	
	<cffunction name="getColumnDefault" returntype="struct" access="public">
		<cfset var d = StructNew()>
		<cfset var it = getUtil().iterator(variables.columns)>
		<cfloop condition="#it.whileHasNext()#">
			<cfset StructInsert(d, it.key, it.current.getDefault())>
		</cfloop>
		<cfreturn d>	
	</cffunction>
	
	<cffunction name="_setDBO" returntype="void" access="private">
		<cfargument name="dbo" type="mydbobject" required="true">
		<cfset variables.dbo = arguments.dbo>
	</cffunction>
	
	<cffunction name="_setDS" returntype="void" access="private">
		<cfset variables.ds = variables.dbo.getDS()>
	</cffunction>
	
	<cffunction name="_setTableName" returntype="void" access="private">
		<cfargument name="tablename" type="string" required="true">		
		<cfset variables.tablename = arguments.tablename>
	</cffunction>
	
	<cffunction name="_setSchemaName" returntype="void" access="private">
		<cfargument name="schemaname" type="string" required="true">		
		<cfset variables.schemaname = arguments.schemaname>
	</cffunction>
	
	<cffunction name="_setFullTableName" returntype="void" access="private">
		<cfset variables.fulltable = getUtil().dot(getSchemaName(), getTableName())>
	</cffunction>
	
	<cffunction name="_addColumn" returntype="void" access="package">
		<cfargument name="column" type="dbcolumn" required="true">
		<cfset var colname = arguments.column.getColumnName()>
		<cfset StructInsert(variables.columns, colname, arguments.column, true)>
		<cfif arguments.column.isPrimaryKey() AND NOT StructKeyExists(variables.primarykeys, colname)>
			<cftry>
				<cfset StructInsert(variables.primarykeys, colname, arguments.column)>
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>	
		<cfif arguments.column.isForeignKey() AND NOT StructKeyExists(variables.foreignkeys, colname)>
			<cftry>
				<cfset StructInsert(variables.foreignkeys, colname, arguments.column)>
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>	
		<cfif arguments.column.isRequired() AND NOT StructKeyExists(variables.requiredcols, colname)>
			<cftry>
				<cfset StructInsert(variables.requiredcols, colname, arguments.column)>
				<cfcatch type="any"></cfcatch>
			</cftry>
		</cfif>	
	</cffunction>
	
	<cffunction name="dump" returntype="struct" access="public">
		<cfset var keyvalue = StructNew()>
		<cfset var it = getUtil().iterator(variables.columns)>
		<cfset var col = "">
		<cfset var Table = "Table">
		<cfset var Columns = "Columns">
		
		<cfset StructInsert(keyvalue, Table, getTableName())>
		<cfset StructInsert(keyvalue, Columns, StructNew())>
		
		<cfloop condition="#it.hasNext()#">
			<cfset col = it.next()>
			<cfset StructInsert(keyvalue[Columns], col.getColumnName(), col.dump())>
		</cfloop>
		<cfreturn keyvalue>
	</cffunction>
	
</cfcomponent>