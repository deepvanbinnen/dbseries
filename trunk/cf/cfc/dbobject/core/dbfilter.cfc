<cfcomponent name="dbfilter">
	<cfset variables.column    = "">
	<cfset variables.operator  = "">
	<cfset variables.value     = "">
	<cfset variables.andstring = "">
	<cfset variables.isand     = true>
	<cfset variables.operators = "=,>,<,<=,>=,<>,EQ,NEQ,LIKE,IN,NOT,NOT IN,NOT LIKE,SW,EW,NOT SW,NOT EW,GT,LT,GTE,LTE,!">
	<cfset variables.valprefix = "">
	<cfset variables.valsuffix = "">
	<cfset variables.listvalue = "">
	
	
	<cffunction name="init" returntype="dbfilter">
		<cfargument name="column"   type="dbcolumn" required="true">
		<cfargument name="operator" type="string"   required="true">
		<cfargument name="value"    type="any"      required="false" default="">
		<cfargument name="isand"    type="boolean"  required="false" default="#variables.isand#">
		
			<cfset _setUtil()>
			<cfset _setColumn(arguments.column)>
			<cfset _setOperator(arguments.operator)>
			<cfset _setAnd(arguments.isand)>
			<cfset setValue(arguments.value)>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setUtil" returntype="void" access="private">
		<cfset variables.util = createObject("component","utils").init()>
	</cffunction>
	
	<cffunction name="getUtil" returntype="utils" access="public">
		<cfreturn variables.util>
	</cffunction>
	
	<cffunction name="setValue" returntype="any">
		<cfargument name="value" type="any" required="true">
		<cfset variables.value = arguments.value>
		<cfreturn getValue()>
	</cffunction>
	
	<cffunction name="getColumnName" returntype="string">
		<cfreturn _getColumn().getColumnName()>
	</cffunction>
	
	<cffunction name="getOperator" returntype="string">
		<cfreturn variables.operator>
	</cffunction>
	
	<cffunction name="getCFDataType" returntype="string">
		<cfreturn _getColumn().getCFDataType()>
	</cffunction>
	
	<cffunction name="getValue" returntype="any">
		<cfreturn variables.valprefix & variables.value & variables.valsuffix>
	</cffunction>
	
	<cffunction name="getAnd" returntype="string">
		<cfreturn IIF(variables.isand, DE("AND"), DE("OR"))>
	</cffunction>
	
	<cffunction name="isList" returntype="string">
		<cfreturn variables.listvalue>
	</cffunction>
	
	<cffunction name="_getColumn" returntype="dbcolumn">
		<cfreturn getColumn()>
	</cffunction>
	
	<cffunction name="getColumn" returntype="dbcolumn">
		<cfreturn variables.column>
	</cffunction>
	
	<cffunction name="_setColumn" returntype="void">
		<cfargument name="column" type="dbcolumn" required="true">
		<cfset variables.column = arguments.column>
	</cffunction>
	
	<cffunction name="_setOperator" returntype="void">
		<cfargument name="operator" type="string" required="true">
		<cfset variables.operator = arguments.operator>
		<cfset _setFilterOptions()>
	</cffunction>
	
	<cffunction name="_setFilterOptions" returntype="void">
		<cfset variables.valprefix = "">
		<cfset variables.sufprefix = "">
		<cfset variables.listvalue = false>
		
		<cfswitch expression="#variables.operator#">
			<cfcase value="LIKE,NOT LIKE">
				<cfset variables.valprefix = "%">
				<cfset variables.valsuffix = "%">
			</cfcase>
			<cfcase value="IN,NOT IN">
				<cfset variables.listvalue = true>
			</cfcase>
			<cfcase value="SW,NOT SW">
				<cfset variables.valsuffix = "%">
				<cfset variables.operator  = REPLACE(variables.operator, "SW", "LIKE")>
			</cfcase>
			<cfcase value="EW">
				<cfset variables.valprefix = "%">
				<cfset variables.operator  = REPLACE(variables.operator, "EW", "LIKE")>
			</cfcase>
			<cfcase value="GT">
				<cfset variables.operator  = REPLACE(variables.operator, "GT", ">")>
			</cfcase>
			<cfcase value="GTE">
				<cfset variables.operator  = REPLACE(variables.operator, "GT", ">=")>
			</cfcase>
			<cfcase value="LT">
				<cfset variables.operator  = REPLACE(variables.operator, "LT", "<")>
			</cfcase>
			<cfcase value="LTE">
				<cfset variables.operator  = REPLACE(variables.operator, "LTE", "<=")>
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="_setAnd" returntype="dbfilter">
		<cfargument name="isand" type="boolean" required="true">
		<cfset variables.isand = arguments.isand>
		<cfreturn this>
	</cffunction>

	<cffunction name="isOperator" returntype="boolean">
		<cfargument name="operator" type="string" required="true">
		<cfreturn ListFindNoCase(variables.operators, arguments.operator)>
	</cffunction>
		
	<cffunction name="dump" returntype="struct" access="public">
		<cfset var keyvalue = StructNew()>
		<cfset var it = getUtil().iterator("operator")>
		<cfset var Column = "Column">
		
		<cfset StructInsert(keyvalue, Column, variables.column.dump())>
		
		<cfloop condition="#it.whileHasNext()#">
			<cfif StructKeyExists(variables,it.value) AND IsSimpleValue(variables[it.value])>	
				<cfset StructInsert(keyvalue, it.value, variables[it.value])>
			</cfif>
		</cfloop>
		<cfset StructInsert(keyvalue, "value", getValue())>
		<cfset StructInsert(keyvalue, "andstring", getAnd())>
		<cfset StructInsert(keyvalue, "listvalue", isList())>
		<cfreturn keyvalue>
	</cffunction>

</cfcomponent>