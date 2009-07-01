<cfcomponent extends="AbstractDBIterator" name="DBQueryIterator" hint="Concrete implementation for a query-iterator">
	<cffunction name="init" returntype="any" hint="set iterator properties from query">
		<cfargument name="collection" type="query" required="true">
		
		<cfset setCollection(arguments.collection)>
		<cfset setIterable(arguments.collection)>
		<cfset setLength(arguments.collection.recordcount)>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setNext" returntype="boolean" hint="update iterator properties when next is called; returns true on success">
		<cfif super.setNext()>
			<cfset setCurrent(row2struct(getIterable(), getIndex()))>
			
			<!--- Set as array where index corresponds to index in columnlist
			<cfset setCurrent(getCollection().getRow(getIndex()-1))> 
			--->
			<cfset setKey(getIndex())>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="row2struct" hint="there doesn't seem to be another way to get the current row in a struct form">
		<cfargument name="query"  type="query" required="true">
		<cfargument name="index"  type="numeric" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		<cfloop list="#arguments.query.columnlist#" index="local.column">
			<cfset StructInsert(local.result, local.column, arguments.query[local.column][arguments.index])>
		</cfloop>
		
		<cfreturn local.result>
	</cffunction>
</cfcomponent>