<cfcomponent name="mydbobject">
	<cfset variables.ds         = "">
	<cfset variables.allObj     = "">
	<cfset variables.tableObj  = "">
	<cfset variables.schemas    = "">
	<cfset variables.schemalist = "">
	<cfset variables.tables     = "">
	<cfset variables.tablelist  = "">
	<cfset variables.defschema  = "">
	<cfset variables.objmap     = "">
	<cfset variables.util       = "">
	
	<cfset variables.SYSTEMSCHEMAS = "information_schema,pg_catalog">
	<cfset variables.SCHEMAINCLUDE = "">
	<cfset variables.SCHEMAEXCLUDE = "">
	
	
	<cffunction name="init" returntype="mydbobject" access="public">
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
			<cfset _setUtil()>
			<cfset _setAllObjects()>
			<cfset _setTableObjects()>
			<cfset _setSchemas()>
			<cfset _setSchemaList()>
			<cfset _setTables()>
			<cfset _setTableList()>
			<cfset _setDefaultSchema()>
			<cfset _setObjMap()>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setDS" returntype="void" access="private">
		<cfargument name="ds" required="true" type="string">
		<cfset variables.ds = arguments.ds>
	</cffunction>
	
	<cffunction name="getDS" returntype="string" access="public">
		<cfreturn variables.ds>
	</cffunction>
	
	<cffunction name="_setObjMap" returntype="void" access="private">
		<cfset variables.objmap = createObject("component", "mydbobjectmap").init(this)>
	</cffunction>
	
	<cffunction name="_getObjMap" returntype="mydbobjectmap" access="public">
		<cfreturn variables.objmap>
	</cffunction>
	
	<cffunction name="getObjMap" returntype="struct" access="public">
		<cfreturn _getObjMap().getObjMap()>
	</cffunction>
	
	<cffunction name="_setUtil" returntype="void" access="private">
		<cfset variables.util = createObject("component","utils").init()>
	</cffunction>
	
	<cffunction name="getUtil" returntype="utils" access="public">
		<cfreturn variables.util>
	</cffunction>
	
	<cffunction name="resetObjMap" returntype="void" access="public">
		<cfset _setObjMap()>
	</cffunction>
	
	<cffunction name="getObj" returntype="dbtableproxy">
		<cfargument name="name" required="true" type="string">
		<cfset var s = _splitSchema(arguments.name)>
		<cftry>
			<cfreturn createObject("component", "dbtableproxy").init(_getObjMap().getObj(s.schemaname, s.tablename))>
			<cfcatch type="any">
				<cfdump var="#cfcatch#">
				<cfthrow message="Unable to find object #arguments.name#">
			</cfcatch>
		</cftry>
		<!--- <cfreturn createObject("component", "cfc.dbtable")> --->
	</cffunction>
	
	<cffunction name="_setSchemas" returntype="void" access="private">
		<cfset var q = getAllObjects()>
		<cfquery name="q" dbtype="query">
		SELECT DISTINCT table_schema
		FROM  q
		ORDER BY table_schema
		</cfquery>
		<cfset variables.schemas = q>
	</cffunction>
	
	<cffunction name="getSchemas" returntype="string" access="public">
		<cfreturn variables.schemas>
	</cffunction>
	
	<cffunction name="_setSchemaList" returntype="void" access="private">
		<cfset variables.schemalist = ValueList(variables.schemas.table_schema)>
	</cffunction>
	
	<cffunction name="getSchemaList" returntype="string" access="public">
		<cfreturn variables.schemalist>
	</cffunction>
	
	<cffunction name="_setDefaultSchema" returntype="void" access="private">
		<cfif ListLen(getSchemaList()) eq 1>
			<cfset variables.defschema = variables.schemalist>
		</cfif>
	</cffunction>
	
	<cffunction name="_getDefaultSchema" returntype="string" access="public">
		<cfreturn variables.defschema>
	</cffunction>
	
	<cffunction name="_setTables" returntype="void" access="private">
		<cfset var q = getAllObjects()>
		<cfquery name="q" dbtype="query">
		SELECT DISTINCT table_schema +  '.' + table_name as fulltablename, table_name, table_schema 
		FROM  q
		ORDER BY table_schema, table_name
		</cfquery>
		<cfset variables.tables = q>
	</cffunction>
	
	<cffunction name="getTables" returntype="query" access="public">
		<cfreturn variables.tables>
	</cffunction>

	<cffunction name="_setTableList" returntype="void" access="private">
		<cfset variables.tablelist = ValueList(variables.tables.fulltablename)>
	</cffunction>
	
	<cffunction name="getTableList" returntype="string" access="public">
		<cfreturn variables.tablelist>
	</cffunction>
	
	<cffunction name="_schemaLookup" returntype="query" access="private">
		<cfargument name="tablename"  required="true" type="string">
		
		<cfset var q = getTables()>
		<cfquery name="q" dbtype="query">
		SELECT  DISTINCT table_name, table_schema  
		FROM    q
		WHERE   table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tablename#">
		</cfquery>
		
		<cfreturn q>
	</cffunction>
	
	<cffunction name="_splitSchema" returntype="struct" access="private">
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
			</cfdefaultcase>>
		</cfswitch>
		
		<cfif NOT StructKeyExists(s, "schemaname")>
			<cfthrow message="Unable to determine tableschema">
		</cfif>
		
		<cfreturn s>
	</cffunction>
	
	<cffunction name="getColumns" returntype="query" access="public">
		<cfargument name="tablename"  required="true" type="string">
			<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn _getColumns(s.schemaname, s.tablename)>
	</cffunction>
	
	<cffunction name="getColumnList" returntype="string" access="public">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getColumnList(getColumns(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getPrimaryKeyColumns" returntype="string" access="public">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getColumnList(getPrimaryKeys(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getPrimaryKeys" returntype="query" access="public">
		<cfargument name="tablename"  required="true" type="string">
			<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn _getColumns(s.schemaname, s.tablename, "PRIMARY KEY")>
	</cffunction>

	<cffunction name="getForeignKeys" returntype="query" access="public">
		<cfargument name="tablename"  required="true" type="string">
			<cfset var s = _splitSchema(arguments.tablename)>
		<cfreturn _getColumns(s.schemaname, s.tablename, "FOREIGN KEY")>
	</cffunction>
	
	<cffunction name="getForeignKeyColumns" returntype="string" access="public">
		<cfargument name="tablename"  required="true" type="string">
		<cfreturn _getColumnList(getForeignKeys(arguments.tablename))>
	</cffunction>
	
	<cffunction name="getForeignKeyTableColumns" returntype="string" access="public">
		<cfargument name="tablename" required="true" type="string">
		<cfset var s = "">
		<cfset var fk = getForeignKeys(arguments.tablename)>
		
		<cfloop query="fk">
			<cfset s = variables.util.dot(refering_schema,refering_table,refering_column)>
		</cfloop>
		
		<cfreturn s>
	</cffunction>
	
	<cffunction name="_getColumnList" returntype="string" access="private">
		<cfargument name="columnquery"  required="true" type="query">
		<cfreturn ValueList(arguments.columnquery.column_name)>
	</cffunction>
		
	<cffunction name="_getColumns" returntype="query" access="private">
		<cfargument name="schemaname" required="true" type="string">
		<cfargument name="tablename"  required="true" type="string">
		<cfargument name="constraint" required="false" type="string" default="">
		
		
		<cfset var q = getTableObjects()>
		<cfquery name="q" dbtype="query">
		SELECT  * 
		FROM    q
		WHERE   table_schema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.schemaname#">
			AND table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tablename#">
			<cfif arguments.constraint neq "">
				AND constraint_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.constraint#">
			</cfif>
		ORDER BY 
			<cfif arguments.constraint neq "">key_ordinal_position,</cfif> ordinal_position
		</cfquery>
		
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getTableObjects" returntype="query" access="public">
		<cfreturn variables.tableObj>
	</cffunction>
	
	<cffunction name="_setTableObjects" returntype="void" access="private">
		<cfset variables.tableObj = _getTableObjects()>
	</cffunction>
	
	<cffunction name="_getTableObjects" returntype="query" access="public">
		<cfset var q = getAllObjects()>
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
		FROM    q
		ORDER BY 
			table_schema, table_name, ordinal_position
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getAllObjects" returntype="query" access="public">
		<cfreturn variables.allObj>
	</cffunction>
	
	<cffunction name="_setAllObjects" returntype="void" access="private">
		<cfset variables.allObj = _getAllObjects()>
	</cffunction>
	
	<cffunction name="_getAllObjects" returntype="query" access="public">
		<cfset var q = QueryNew("")>
		<cfquery name="q" datasource="#getDS()#">
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
		<cfreturn q>
	</cffunction>
</cfcomponent>