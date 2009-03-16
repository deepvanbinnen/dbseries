<cfcomponent name="dbcolumn">
	<cfset variables.dbtable    = "">
	<cfset variables.columnname = "">
	<cfset variables.fullname   = "">
	<cfset variables.value      = "">
	<cfset variables.dbdatatype = "">
	<cfset variables.cfdatatype = "">
	<cfset variables.required   = false>
	<cfset variables.primarykey = false>
	<cfset variables.foreignkey = false>
	<cfset variables.refschema  = "">
	<cfset variables.reftable   = "">
	<cfset variables.refcolumn  = "">
	<cfset variables.defaultval = "">
	
	<cffunction name="init" returntype="dbcolumn">
		<cfargument name="dbtable"      type="dbtable" required="true">
		<cfargument name="columnname"   type="string" required="true">
		<cfargument name="dbdatatype"   type="string" required="true">
		<cfargument name="cfdatatype"   type="string" required="true">
		<cfargument name="isrequired"   type="boolean" required="true">
		<cfargument name="isprimarykey" type="boolean" required="true">
		<cfargument name="isforeignkey" type="boolean" required="true">
		<cfargument name="refschema"    type="string" required="true">
		<cfargument name="reftable"     type="string" required="true">
		<cfargument name="refcolumn"    type="string" required="true">
		<cfargument name="defaultval"   type="string" required="true">
		<cfset variables.defaultval = "">
		
			<cfset _setDBTable(arguments.dbtable)>
			<cfset _setColumnName(arguments.columnname)>
			<cfset _setDBDataType(arguments.dbdatatype)>
			<cfset _setCFDataType(arguments.cfdatatype)>
			<cfset _setIsRequired(arguments.isrequired)>
			<cfset _setPrimaryKey(arguments.isprimarykey)>
			<cfset _setForeignKey(arguments.isforeignkey)>
			<cfset _setRefSchema(arguments.refschema)>
			<cfset _setRefTable(arguments.reftable)>
			<cfset _setRefColumn(arguments.refcolumn)>
			<cfset _setDefault(arguments.defaultval)>
			
			<cfset _setFullColumnName()>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setValue" returntype="any">
		<cfargument name="value" type="any" required="true">
		<cfset variables.value = arguments.value>
		<cfreturn getValue()>
	</cffunction>
	
	<cffunction name="getValue" returntype="any">
		<cfreturn variables.value>
	</cffunction>
	
	<cffunction name="getColumnName" returntype="string" access="public">
		<cfreturn variables.columnname>	
	</cffunction>
	
	<cffunction name="getTableName" returntype="string" access="public">
		<cfreturn variables.dbtable.getTableName()>	
	</cffunction>
	
	<cffunction name="getSchemaName" returntype="string" access="public">
		<cfreturn variables.dbtable.getSchemaName()>	
	</cffunction>
	
	<cffunction name="getFullTableName" returntype="string" access="public">
		<cfreturn variables.dbtable.getFullTableName()>	
	</cffunction>
	
	<cffunction name="getFullColumnName" returntype="string" access="public">
		<cfreturn variables.fullname>	
	</cffunction>
	
	<cffunction name="getUtil" returntype="utils" access="public">
		<cfreturn variables.dbtable.getUtil()>	
	</cffunction>
	
	<cffunction name="getDBDataType" returntype="string" access="public">
		<cfreturn variables.dbdatatype>	
	</cffunction>
	
	<cffunction name="getCFDataType" returntype="string" access="public">
		<cfreturn variables.cfdatatype>	
	</cffunction>
	
	<cffunction name="getDefault" returntype="string" access="public">
		<cfreturn variables.defaultval>	
	</cffunction>
	
	<cffunction name="isRequired" returntype="boolean" access="public">
		<cfreturn variables.required>	
	</cffunction>
	
	<cffunction name="isPrimaryKey" returntype="boolean" access="public">
		<cfreturn variables.primarykey>	
	</cffunction>
	
	<cffunction name="isForeignKey" returntype="boolean" access="public">
		<cfreturn variables.foreignkey>	
	</cffunction>
	
	<cffunction name="getRefSchema" returntype="string" access="public">
		<cfreturn variables.refschema>
	</cffunction>
	
	<cffunction name="getRefTable" returntype="string" access="public">
		<cfreturn variables.reftable>
	</cffunction>
	
	<cffunction name="getRefColumn" returntype="string" access="public">
		<cfreturn variables.refcolumn>
	</cffunction>
	
	<cffunction name="_setIsRequired" returntype="void" access="private">
		<cfargument name="isrequired" type="boolean" required="true">		
		<cfset variables.required = arguments.isrequired>
	</cffunction>
	
	<cffunction name="_setPrimaryKey" returntype="void" access="package">
		<cfargument name="isprimarykey" type="boolean" required="true">		
		<cfset variables.primarykey = arguments.isprimarykey>
	</cffunction>
	
	<cffunction name="_setForeignKey" returntype="void" access="public">
		<cfargument name="isforeignkey" type="boolean" required="true">	
			<cfset variables.foreignkey = arguments.isforeignkey>
	</cffunction>
	
	<cffunction name="_setRefSchema" returntype="string" access="public">
		<cfargument name="refschema" type="string" required="true">
		<cfset variables.refschema = arguments.refschema>
	</cffunction>
	
	<cffunction name="_setRefTable" returntype="void" access="private">
		<cfargument name="reftable" type="string" required="true">
		<cfset variables.reftable = arguments.reftable>
	</cffunction>
	
	<cffunction name="_setRefColumn" returntype="void" access="private">
		<cfargument name="refcolumn" type="string" required="true">
		<cfset variables.refcolumn = arguments.refcolumn>
	</cffunction>
	
	<cffunction name="_setDefault" returntype="void" access="private">
		<cfargument name="defaultval" type="string" required="true">
		<cfset variables.defaultval = arguments.defaultval>
	</cffunction>
	
	<cffunction name="_setFullColumnName" returntype="void" access="private" output="true">
		<cfset variables.fullname = getUtil().dot(getFullTableName(), getColumnName())>
	</cffunction>
	
	<cffunction name="_setDBTable" returntype="void" access="private">
		<cfargument name="dbtable" type="dbtable" required="true">		
		<cfset variables.dbtable = arguments.dbtable>
	</cffunction>
	
	<cffunction name="_setColumnName" returntype="void" access="private">
		<cfargument name="columnname" type="string" required="true">		
		<cfset variables.columnname = arguments.columnname>
	</cffunction>
	
	<cffunction name="_setDBDataType" returntype="void" access="private">
		<cfargument name="dbdatatype" type="string" required="true">		
		<cfset variables.dbdatatype = arguments.dbdatatype>
	</cffunction>
	
	<cffunction name="_setCFDataType" returntype="void" access="private">
		<cfargument name="cfdatatype" type="string" required="true">		
		<cfset variables.cfdatatype = arguments.cfdatatype>
	</cffunction>
	
	<cffunction name="dump" returntype="struct" access="public">
		<cfset var keyvalue = StructNew()>
		<cfset var it = getUtil().iterator("dbtable,columnname,fullname,value,dbdatatype,cfdatatype,required,primarykey,foreignkey,refschema,reftable,refcolumn")>
	
		<cfloop condition="#it.whileHasNext()#">
			<cfif StructKeyExists(variables,it.value) AND IsSimpleValue(variables[it.value])>	
				<cfset StructInsert(keyvalue, it.value, variables[it.value])>
			</cfif>
		</cfloop>
		
		<cfreturn keyvalue>
	</cffunction>
	
</cfcomponent>