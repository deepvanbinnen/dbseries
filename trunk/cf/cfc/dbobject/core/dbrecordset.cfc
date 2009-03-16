<cfcomponent name="dbrecordset">
	<cfset variables.recordset   = ArrayNew(1)>
	<cfset variables.recordProxy = "">
	<cfset variables.length      = 0>
	<cfset variables.colnames    = "">
	<cfset variables.issingle    = false>
	<cfset variables.multiple    = false>
	<cfset variables.record      = "">
	
	<cffunction name="init" returntype="dbrecordset">
		<cfargument name="record"     type="dbrecord" required="true">
		<cfargument name="multiple"   type="boolean" required="false" default="true">
		<cfargument name="columnlist" type="string" required="false" default="">
		
			<cfset variables.multiple    = arguments.multiple>
			<cfset variables.recordProxy = arguments.record>
			<cfset this.columnlist = arguments.columnlist>
			<cfset _setUtil()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" returntype="array">
		<cfreturn variables.recordset>
	</cffunction>
	
	<cffunction name="getColumns" returntype="string">
		<cfreturn variables.colnames>
	</cffunction>
	
	<cffunction name="getColumn" returntype="any">
		<cfargument name="columnname" type="string" required="true">
		<cfreturn variables.recordProxy.getColumn(columnname)>
	</cffunction>
	
	<cffunction name="getLength" returntype="numeric">
		<cfreturn variables.length>
	</cffunction>
	
	<cffunction name="setLength" returntype="void">
		<cfargument name="length" required="true" type="numeric">
		<cfset variables.length = arguments.length>
	</cffunction>
	
	<cffunction name="add" returntype="dbrecordset">
		<cfargument name="query" required="true" type="query">
		
		<cfset var q = arguments.query>
		<cfset var it = getUtil().iterator(q)>
		
		<cfset setLength(q.recordcount)>
		<cfloop condition="#it.whileHasNext()#">
			<cfset _addRecord(it.current, false)>
		</cfloop>
		
		<cfif q.recordcount eq 0>
			<cfset _copyProperties(variables.recordProxy)>
		<cfelse>
			<cfset _copyProperties(variables.recordset[1])>
		</cfif>
		
		<cfset variables.record = "">
		<cfset variables.issingle = (q.recordcount eq 1)>
		<cfif variables.issingle>
			<cfset variables.record = variables.recordset[1]>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="hasone" returntype="boolean">
		<cfreturn variables.issingle>
	</cffunction>
	
	<cffunction name="iterator" returntype="Iterator">
		<cfif hasone() AND NOT variables.multiple>
			<cfreturn variables.record.iterator()>
		</cfif>
		<cfreturn getUtil().iterator(get())>
	</cffunction>
	
	<cffunction name="_setUtil" returntype="void" access="private">
		<cfset variables.util = createObject("component","utils").init()>
	</cffunction>
	
	<cffunction name="getUtil" returntype="utils" access="public">
		<cfreturn variables.util>
	</cffunction>
	
	<cffunction name="_copyProperties" returntype="void" access="private">
		<cfargument name="record" type="dbrecord" required="true">
		
		<cfset var r = arguments.record>
		<cfset var it = getUtil().iterator(r.getKeys())>
	
		<cfloop condition="#it.whileHasNext()#">
			<cfif IsSimpleValue(r[it.current]) AND NOT StructKeyExists(this,it.current)>	
				<cfset StructInsert(this, it.current, r[it.current])>
			</cfif>
		</cfloop>
		<cfset variables.colnames = r.getKeys()>
	</cffunction>
	
	<cffunction name="_addRecord" returntype="void" access="private">
		<cfargument name="record" required="true" type="struct">
		<cfargument name="isnew" required="true" type="boolean">
			<cfset ArrayAppend(variables.recordset, variables.recordProxy.create(record=arguments.record, isnew=arguments.isnew))>
	</cffunction>
	
	<cffunction name="dump" returntype="struct" access="public">
		<cfset var keyvalue = StructNew()>
		<cfset var it = iterator()>
		<cfset var arr = "">
		<cfset var recordset = "Recordset">
	
		<cfset StructInsert(keyvalue, recordset, ArrayNew(1))>
		<cfloop condition="#it.whileHasNext()#">
			<cfset ArrayAppend(keyvalue[recordset], it.current.dump())>
		</cfloop>
		
		<cfreturn keyvalue>
	</cffunction>
	
</cfcomponent>