<cfcomponent name="mydbobjectmap">
	<cfset variables.dbo    = "">
	<cfset variables.util   = "">
	<cfset variables.objmap = StructNew()>
	
	<cffunction name="init" returntype="mydbobjectmap" access="public">
		<cfargument name="dbo" required="true" type="mydbobject">
		<cfset _setDBO(arguments.dbo)>
		<cfset _setUtil()>
		<cfset _setObjMap()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getObj" returntype="dbtable" access="public">
		<cfargument name="schema" required="Yes" type="string">
		<cfargument name="table" required="Yes" type="string">
		<cftry>
			<cfreturn variables.objmap[arguments.schema][arguments.table]>
			<cfcatch type="any">
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getObjMap" returntype="struct" access="public">
		<cfreturn variables.objmap>
	</cffunction>
	
	<cffunction name="getDBO" returntype="mydbobject" access="public">
		<cfreturn variables.dbo>
	</cffunction>
	
	<cffunction name="_setDBO" returntype="void" access="private">
		<cfargument name="dbo" required="true" type="mydbobject">
		<cfset variables.dbo = arguments.dbo>
	</cffunction>
	
	<cffunction name="_setUtil" returntype="void" access="private">
		<cfset variables.util = getDBO().getUtil()>
	</cffunction>
	
	<cffunction name="_setObjMap" returntype="void" access="private">
		<cfset var q = getDBO().getTables()>
		<cfset var m = variables.objmap>
		<cfloop query="q">
			<cfif NOT StructKeyExists(m, table_schema)>
				<cfset StructInsert(m, table_schema, StructNew())>
			</cfif>
			<cfset StructInsert(m[table_schema], table_name, _createMapEntry(table_schema, table_name))>
		</cfloop>
	</cffunction>
	
	<cffunction name="_getColumns" returntype="query" access="public">
		<cfargument name="schema" required="Yes" type="string">
		<cfargument name="table" required="Yes" type="string">
		<cfreturn variables.dbo.getColumns(variables.util.dot(arguments.schema, arguments.table))>
	</cffunction>
	
	<cffunction name="_createMapEntry" returntype="dbtable" access="public" output="true">
		<cfargument name="schema" required="Yes" type="string">
		<cfargument name="table" required="Yes" type="string">
		
		<cfset var dbtable = createObject("component", "dbtable").init(dbo=variables.dbo, schemaname=arguments.schema, tablename=arguments.table)>
		<cfset _addColumns(dbtable, _getColumns(schema=arguments.schema, table=arguments.table))>
		
		<cfreturn dbtable>
	</cffunction>
	
	<cffunction name="_addColumns" returntype="void" access="public" output="true">
		<cfargument name="dbtable" type="dbtable" required="true">
		<cfargument name="columnQuery" type="query" required="true">
		
		<cfloop query="arguments.columnQuery">
			<cfset tmpObj = createObject("component", "dbcolumn").init(
				  dbtable      = arguments.dbtable
				, columnname   = column_name
				, dbdatatype   = data_type
				, cfdatatype   = variables.util.getCFQPByDataType(data_type)
				, isrequired   = is_nullable
				, isprimarykey = (constraint_type eq 'PRIMARY KEY')
				, isforeignkey = (constraint_type eq 'FOREIGN KEY')
				, refschema    = refering_schema
				, reftable     = refering_table
				, refcolumn    = refering_column	
				, defaultval   = column_default
			)>
			<cfset arguments.dbtable._addColumn(tmpObj)>
		</cfloop>
		
	</cffunction>
	
</cfcomponent>