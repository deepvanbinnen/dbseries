<cfcomponent name="IndexedSetOf" extends="SetOf">
	<cfset variables.collection  = QueryNew("item")>
	<cfset variables.indexable   = "">
	<cfset variables.length      = "">
	<cfset variables.index       = "0">
	<cfset variables.current     = "">
	
	<cffunction name="init">
		<cfargument name="indexables" required="false" type="string" default="">
		<cfif arguments.indexables neq "">
			<cfset _addIndexables(arguments.indexables)>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add">
		<cfargument name="item" required="true" type="any">
		<cfset QueryAddRow(variables.collection)>
		<cfset QuerySetCell(variables.collection, "item", arguments.item)>
		<cfset _setLength()>
	    <cfset _setIndex(getLength())>
	    <cfset _setIndexables()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_addIndexables">
		<cfargument name="indexables" required="true" type="string">
		<cfset var local = StructNew()>
		<cfloop list="#arguments.indexables#" index="local.indexable">
			<cfset QueryAddColumn(variables.collection,local.indexable,ArrayNew(1))>
		</cfloop>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_getIndexables">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setIndexables">
		<cfset var local = StructNew()>
		<cfset local.current = getCurrent()>
		<cfif IsStruct(local.current)>
			<cfset local.columns = getAll().columnlist>
			<!--- This returns true when the current is a component --->
			<cfloop list="#local.columns#" index="local.column">
				<cfif StructKeyExists(local.current, local.column)>
					<cfset QuerySetCell(variables.collection, local.column, local.current[local.column], getIndex())>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="get">
		<cfargument name="key" required="true" type="any">
		<cfset var local = StructNew()>
		<cfset var q = getAll()>
		<cfquery name="local.q" dbtype="query">
			SELECT *
			FROM q
			WHERE mykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.key#">
		</cfquery>
		
		<cfreturn local.q>
	</cffunction>
	
	<cffunction name="_get">
		<cfargument name="index" required="true" type="any">
		<cfreturn variables.collection["item"][arguments.index]>
	</cffunction>
	
	<cffunction name="getAll">
		<cfreturn variables.collection>
	</cffunction>
	
	<cffunction name="getLength">
		<cfreturn variables.length>
	</cffunction>
	
	<cffunction name="getCurrent">
		<cfreturn variables.current>
	</cffunction>
	
	<cffunction name="getIndex">
		<cfreturn variables.index>
	</cffunction>
	
	<cffunction name="_setCurrent">
		<cfargument name="index" required="true" type="any">
		<cfset variables.current = _get(arguments.index)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setIndex">
		<cfargument name="index" required="true" type="any">
		<cfset variables.index = arguments.index>
		<cfset _setCurrent(getIndex())>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setLength">
		<cfargument name="length" required="false" type="any" default="#variables.collection.recordcount#">
		<cfset variables.length = arguments.length>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>