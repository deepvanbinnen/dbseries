<cfcomponent name="dbobject">
	<!--- PRIVATE CONSTANTS --->
	<cfset variables.SYSTEMSCHEMAS = "information_schema,pg_catalog">
	<cfset variables.SCHEMAINCLUDE = "">
	<cfset variables.SCHEMAEXCLUDE = "">
	
	<!--- PRIVATE VARIABLES --->
	<cfset variables.ds         = "">
	<cfset variables.allObj     = "">
	<cfset variables.tableObj  = "">
	<cfset variables.schemas    = "">
	<cfset variables.tables     = "">
	<cfset variables.views      = "">
	
<!---
===============================================================================
= PUBLIC FUNCTIONS =
===============================================================================
--->
	<cffunction name="init" returntype="dbobject" access="public">
		<cfargument name="ds" required="true" type="string">
		<cfargument name="schemainclude" required="false" type="string" default="">
		<cfargument name="schemaexclude" required="false" type="string" default="">
		<cfargument name="systemschemas" required="false" type="string" default="">
			
		<cfset variables.SCHEMAINCLUDE = arguments.schemainclude>
		<cfset variables.SCHEMAEXCLUDE = arguments.schemaexclude>
		<cfif arguments.systemschemas neq "">
			<cfset variables.SYSTEMSCHEMAS = arguments.systemschemas>
		</cfif>
		
		<cfset _setDS(arguments.ds)>
		<cfset _setAllObjects()>
		<cfset _setSchemas()>
		<cfset _setTables()>
		<cfset _setViews()>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getObj" returntype="dbtable" access="public" hint="get table as on object">
		<cfargument name="tablename" required="true" type="string">
		<cfargument name="autojoin"  required="false" type="boolean" default="false">
		<cfargument name="columns"   required="false" type="string"  default="*">
		
		<cfreturn createObject("component", "dbtable").init(this, arguments.tablename, arguments.autojoin, arguments.columns)>
	</cffunction>
	
	<cffunction name="getDS" returntype="string" access="public" hint="get datasource">
		<cfreturn variables.ds>
	</cffunction>
	
	<cffunction name="getAllObjects" returntype="query" access="public" hint="get 'in memory' informationschema query">
		<cfreturn variables.allObj>
	</cffunction>
	
	<cffunction name="getSchemas" returntype="string" access="public" hint="get used schemas as a list">
		<cfreturn variables.schemas>
	</cffunction>
	
	<cffunction name="getTables" returntype="query" access="public" hint="get tables as a query">
		<cfreturn variables.tables>
	</cffunction>
	
	<cffunction name="getTableList" returntype="string" access="public" hint="get tablenames as a list">
		<cfreturn ValueList(variables.tables.table_name)>
	</cffunction>
	
	<cffunction name="getFullTableList" returntype="string" access="public" hint="get full-qualified tablenames as a list">
		<cfreturn ValueList(variables.tables.fulltablename)>
	</cffunction>
	
	<cffunction name="getViews" returntype="query" access="public" hint="get views as a query">
		<cfreturn variables.views>
	</cffunction>
	
	<cffunction name="getViewList" returntype="string" access="public" hint="get viewnames as a list">
		<cfreturn ValueList(variables.views.tablename)>
	</cffunction>
	
	<cffunction name="getFullViewList" returntype="string" access="public" hint="get full-qualified viewnames as a list">
		<cfreturn ValueList(variables.views.fulltablename)>
	</cffunction>
	
	<cffunction name="getColumn" returntype="query" access="public" hint="get columns as a query">
		<cfargument name="tablename"  required="true" type="string">
		<cfargument name="columnname" required="true" type="string">
			<cfset var local = StructNew()>
			<cfset var columns = getColumns(arguments.tablename)>
			<cfquery name="local.column" dbtype="query">
			SELECT *
			FROM columns
			WHERE column_name = '#arguments.columnname#'
			</cfquery>
		<cfreturn local.column>
	</cffunction>
	
	<cffunction name="getColumns" returntype="query" access="public" hint="get columns as a query">
		<cfargument name="tablename"  required="true" type="string">
			<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn _getColumns(s.schemaname, s.tablename)>
	</cffunction>
	
	<cffunction name="getColumnList" returntype="string" access="public" hint="get columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getColumnList(getColumns(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getFullColumnList" returntype="string" access="public" hint="get columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getFullColumnList(getColumns(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getPrimaryKeys" returntype="query" access="public" hint="get primary key columns as a query">
		<cfargument name="tablename"  required="true" type="string">
			<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn _getColumns(s.schemaname, s.tablename, "PRIMARY KEY")>
	</cffunction>
	
	<cffunction name="getPrimaryKeyList" returntype="string" access="public" hint="get primary key columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getColumnList(getPrimaryKeys(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getFullPrimaryKeyList" returntype="string" access="public" hint="get primary key columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getFullColumnList(getPrimaryKeys(arguments.tablename))>
	</cffunction>

	<cffunction name="getForeignKeys" returntype="query" access="public">
		<cfargument name="tablename"  required="true" type="string" hint="get foreign key columns as a query">
			<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn _getColumns(s.schemaname, s.tablename, "FOREIGN KEY")>
	</cffunction>
	
	<cffunction name="getForeignKeyList" returntype="string" access="public" hint="get foreign key columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getColumnList(getForeignKeys(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getFullForeignKeyList" returntype="string" access="public" hint="get foreign key columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getFullColumnList(getForeignKeys(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getRequired" returntype="query" access="public" hint="get required columns as a query">
		<cfargument name="tablename"  required="true" type="string">
			<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn _getColumns(s.schemaname, s.tablename, "REQUIRED")>
	</cffunction>
	
	<cffunction name="getRequiredList" returntype="string" access="public" hint="get required columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getColumnList(getRequired(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getFullRequiredList" returntype="string" access="public" hint="get required columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getFullColumnList(getRequired(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getNullable" returntype="query" access="public" hint="get optional columns as a query">
		<cfargument name="tablename"  required="true" type="string">
			<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn _getColumns(s.schemaname, s.tablename, "NULLABLE")>
	</cffunction>
	
	<cffunction name="getNullableList" returntype="string" access="public" hint="get optional columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getColumnList(getNullable(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getFullNullableList" returntype="string" access="public" hint="get optional columns as a list">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getFullColumnList(getNullable(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getReferenceTables" returntype="string" access="public" hint="returns the table's lookup tables as a list">
		<cfargument name="tablename"  required="true" type="string">
			<cfset var fk = getForeignKeys(arguments.tablename)>
		<cfreturn ValueList(fk.refering_table)>
	</cffunction>
	
	<cffunction name="getReferences" returntype="query" access="public" hint="for easy referencing :)">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn getForeignKeys(arguments.tablename)>
	</cffunction>
	
	<cffunction name="getReferedBy" returntype="query" access="public" hint="returns table columns where this table is used as a lookup">
		<cfargument name="tablename"  required="true" type="string">
		
		<cfset var q = getAllObjects()>
		<cfset var s = _splitSchema(arguments.tablename)>
	
		<cfquery name="q" dbtype="query">
		SELECT *
		FROM  q
		WHERE referencing_schema = '#s.schemaname#'
			AND referencing_table = '#s.tablename#'
		</cfquery>
		
		<cfset q = _getTableObjects(q)>
			
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getTablesAndViews" returntype="query" access="public" hint="get table and view names from infoquery">
		<cfset var q = _getTableObjects()>
			<cfquery name="q" dbtype="query">
			SELECT DISTINCT table_schema
				, table_name
				, table_type
				, table_schema +  '.' + table_name as fulltablename
			FROM    q
			ORDER BY 
				table_schema, table_name
			</cfquery>
		<cfreturn q>
	</cffunction>
	
	
	<cffunction name="getFullTable" returntype="string" access="public" hint="returns the fully qualified tablename for a table">
		<cfargument name="tablename"  required="true" type="string">
		<cfset var s = _splitSchema(arguments.tablename)>
		
		<cfreturn s.schemaname & "." & s.tablename>
	</cffunction>

	<cffunction name="getSchemaName" returntype="string" access="public" hint="returns the schemaname for a table">
		<cfargument name="tablename"  required="true" type="string">
		<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn s.schemaname>
	</cffunction>
<!---
===============================================================================
= PRIVATE FUNCTIONS =
===============================================================================
--->
	
	<cffunction name="_setDS" returntype="void" access="private" hint="set datasource to use">
		<cfargument name="ds" required="true" type="string">
		<cfset variables.ds = arguments.ds>
	</cffunction>
	
	<cffunction name="_setSchemas" returntype="void" access="private" hint="set used schemas in a list">
		<cfset var q = getAllObjects()>
		<cfquery name="q" dbtype="query">
		SELECT DISTINCT table_schema
		FROM  q
		ORDER BY table_schema
		</cfquery>
		<cfset variables.schemas = ValueList(q.table_schema)>
	</cffunction>
	
	<cffunction name="_schemaLookup" returntype="query" access="private" hint="get schema for a given tablename">
		<cfargument name="tablename"  required="true" type="string">
		
		<cfset var q = getTables()>
		<cfquery name="q" dbtype="query">
		SELECT  DISTINCT table_name, table_schema  
		FROM    q
		WHERE   table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tablename#">
		</cfquery>
		
		<cfreturn q>
	</cffunction>
	
	<cffunction name="_splitSchema" returntype="struct" access="private" hint="split a dotted table into tablename and schema">
		<cfargument name="tablename"  required="true" type="string">
		
		<cfset var t = ListToArray(arguments.tablename, ".")>
		<cfset var l = ArrayLen(t)>
		<cfset var s = StructNew()>
		
		<cfswitch expression="#l#">
			<cfcase value="1">
				<cfset t = _schemaLookup(t[l])>
				<cfif t.recordcount eq 1>
					<cfset s["schemaname"] = t.table_schema>
					<cfset s["tablename"]  = t.table_name>	
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfset s["schemaname"] = t[l-1]>
				<cfset s["tablename"]  = t[l]>	
			</cfdefaultcase>
		</cfswitch>
		
		<cfif NOT StructKeyExists(s, "schemaname")>
			<cfthrow message="Unable to determine tableschema">
		</cfif>
		
		<cfreturn s>
	</cffunction>
	
	<cffunction name="_getColumnList" returntype="string" access="private" hint="return columnnames from a query on infoschema">
		<cfargument name="columnquery"  required="true" type="query">
		<cfreturn ValueList(arguments.columnquery.column_name)>
	</cffunction>
	
	<cffunction name="_getFullColumnList" returntype="string" access="private" hint="return full qualified columnnames from a query on infoschema">
		<cfargument name="columnquery"  required="true" type="query">
		<cfreturn ValueList(arguments.columnquery.fullcolumnname)>
	</cffunction>
		
	<cffunction name="_getColumns" returntype="query" access="private" hint="return columns for a given schema and table filtered on keytype">
		<cfargument name="schemaname" required="true" type="string">
		<cfargument name="tablename"  required="true" type="string">
		<cfargument name="constraint" required="false" type="string" default="">
		
		<cfset var q = _getTableObjects()>
		<cfquery name="q" dbtype="query">
		SELECT  * 
		FROM    q
		WHERE   table_schema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schemaname#">
			AND table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tablename#">
			<cfswitch expression="#arguments.constraint#">
				<cfcase value="PRIMARY KEY,FOREIGN KEY">
					AND constraint_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.constraint#">
				</cfcase>
				<cfcase value="REQUIRED">
					AND is_nullable = <cfqueryparam cfsqltype="cf_sql_varchar" value="NO">
				</cfcase>
				<cfcase value="NULLABLE">
					AND is_nullable = <cfqueryparam cfsqltype="cf_sql_varchar" value="YES">
				</cfcase>
			</cfswitch>
		ORDER BY 
			<cfif arguments.constraint neq "">key_ordinal_position,</cfif> ordinal_position
		</cfquery>
		
		<cfreturn q>
	</cffunction>
	
	<cffunction name="_setViews" returntype="void" access="private" hint="'allObj'-query with only views">
		<cfset var q = getTablesAndViews()>
		<cfquery name="variables.views" dbtype="query">
		SELECT  *
		FROM    q
		WHERE table_type = 'VIEW'
		ORDER BY 
			table_schema, table_name
		</cfquery>
	</cffunction>
	
	<cffunction name="_setTables" returntype="void" access="private" hint="'allObj'-query with views excluded">
		<cfset var q = getTablesAndViews()>
		<cfquery name="variables.tables" dbtype="query">
		SELECT  *
		FROM    q
		WHERE table_type <> 'VIEW'
		ORDER BY 
			table_schema, table_name
		</cfquery>
	</cffunction>
	
	<cffunction name="_getTableObjects" returntype="query" access="public" hint="returns a simplified version of an 'allObj'-query">
		<cfargument name="objquery" type="query" required="false" default="#getAllObjects()#">
		<cfset var q = arguments.objquery>
		<cfquery name="q" dbtype="query">
		SELECT  DISTINCT
		      table_schema
			, table_type
			, table_name
			, constraint_type 
			, key_ordinal_position
			, ordinal_position
			, column_name
			, data_type
			, column_default
			, is_nullable
			, refering_schema
			, refering_table
			, refering_column
			, table_schema +  '.' + table_name as fulltablename
			, table_schema +  '.' + table_name + '.' + column_name as fullcolumnname
			, refering_schema +  '.' + refering_table as fullreftable
			, refering_schema +  '.' + refering_table +  '.' + refering_column as fullrefcolumn
		FROM    q
		ORDER BY 
			table_schema, table_name, ordinal_position
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	
	<cffunction name="_setAllObjects" returntype="void" access="private" hint="hits the database, queries informationschema to retrieve all table, view and key information and sets the 'allObj' variable.">
		<cfquery name="variables.allObj" datasource="#getDS()#">
		SELECT 
			  t.table_schema
			, t.table_type
			, t.table_name
			, cn.constraint_type 
			, cn.constraint_name
			, k.ordinal_position as key_ordinal_position
			, c.ordinal_position
			, c.column_name
			, c.data_type
			, c.column_default
			, c.is_nullable
			, k2.constraint_name as referencing_constraint
			, k2.table_schema AS referencing_schema
			, k2.table_name AS referencing_table
			, k2.column_name AS referencing_column
			, fk.table_schema AS refering_schema
			, fk.table_name AS refering_table
			, fk.column_name AS refering_column
			, r.update_rule
			, r.delete_rule
		FROM  information_schema.tables t
			, information_schema.columns c
				LEFT JOIN information_schema.key_column_usage k
					ON c.column_name = k.column_name
					  AND c.table_name = k.table_name
					  AND c.table_schema = k.table_schema
				LEFT JOIN information_schema.table_constraints cn
					ON cn.constraint_name = k.constraint_name	
				LEFT JOIN information_schema.referential_constraints r
					ON k.constraint_name = r.unique_constraint_name
				LEFT JOIN information_schema.key_column_usage k2
					ON r.constraint_name = k2.constraint_name
				LEFT JOIN information_schema.constraint_column_usage fk
					ON cn.constraint_name = fk.constraint_name
		WHERE 1 = 1
		  <cfif variables.SYSTEMSCHEMAS neq "">
			  AND t.table_schema NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.SYSTEMSCHEMAS#" list="true">)
		  </cfif>
		  <cfif variables.SCHEMAINCLUDE neq "">
			  AND t.table_schema IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.SCHEMAINCLUDE#" list="true">)
		  </cfif>
		  <cfif variables.SCHEMAEXCLUDE neq "">
			  AND t.table_schema IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.SCHEMAEXCLUDE#" list="true">)
		  </cfif>
		  AND c.table_schema = t.table_schema
		  AND c.table_name = t.table_name
		ORDER BY 1,2,3,4,5,6
		</cfquery>
	</cffunction>
</cfcomponent>