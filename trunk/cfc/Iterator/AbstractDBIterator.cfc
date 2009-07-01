<cfcomponent name="AbstractDBIterator" hint="Default implementation for dbiterator">
	<cfset init()>
	
	<cffunction name="init">
		<cfset reset("", 0)>
	</cffunction>

	
	<cffunction name="hasValues">
		<cfreturn getLength() neq 0>
	</cffunction>
	
	<cffunction name="reset">
		<cfargument name="collection" type="any"     required="false" default="#getCollection()#">
		<cfargument name="length"     type="numeric" required="false" default="#getLength()#">
		<cfset setCollection(arguments.collection)>
		<cfset setLength(arguments.length)>
		<cfset setKey("")>
		<cfset setCurrent("")>
		<cfset setIndex(0)>
	</cffunction>
	
	<cffunction name="getCollection" returntype="any" hint="return the collection that is iterated">
		<cfreturn variables.collection>
	</cffunction>
	
	<cffunction name="setCollection" returntype="any" hint="set the collection that is iterated">
		<cfargument name="collection" type="any" required="true">
			<cfset variables.collection = arguments.collection>
			<cfset this.collection = variables.collection>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getCurrent" returntype="any" hint="return the current element">
		<cfreturn variables.current>
	</cffunction>
	
	<cffunction name="setCurrent" returntype="any" hint="set the current element">
		<cfargument name="current" type="any" required="true">
			<cfset variables.current = arguments.current>
			<cfset this.current = variables.current>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getIndex" returntype="numeric" hint="get the current index">
		<cfreturn variables.curridx>
	</cffunction>
	
	<cffunction name="setIndex" returntype="any" hint="set the current index">
		<cfargument name="index" type="numeric" required="true">
			<cfset variables.curridx = arguments.index>
			<cfset this.index   = variables.curridx>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getKey" returntype="any" hint="get the current key">
		<cfreturn variables.currkey>
	</cffunction>
	
	<cffunction name="setKey" returntype="any" hint="set the current key">
		<cfargument name="key" type="any" required="true">
			<cfset variables.currkey = arguments.key>
			<cfset this.key     = variables.currkey>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getLength" returntype="numeric" hint="get the number of elements iterated">
		<cfreturn variables.length>
	</cffunction>
	
	<cffunction name="setLength" returntype="any" hint="set the number of elements to iterate">
		<cfargument name="length" type="numeric" required="true">
			<cfset variables.length = arguments.length>
			<cfset this.length  = variables.length>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getIterable" hint="get the iterator, in case of native iterator this will be the JAVA-iterator">
		<cfreturn variables.iterable>
	</cffunction>
	
	<cffunction name="setIterable" returntype="any" hint="set the iterator, in case of native iterator this will be the JAVA-iterator">
		<cfargument name="iterable" type="any" required="true">
			<cfset variables.iterable = arguments.iterable>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="hasNext" returntype="boolean" hint="return if current index is larger than the number of elements to iterate">
		<cfreturn getLength() GT getIndex()>
	</cffunction>
	
	<cffunction name="whileHasNext" returntype="boolean" hint="calls next; concrete implementation of next should update the current element!">
		<cfreturn setNext()>
	</cffunction>
	
	<cffunction name="setNext" returntype="boolean" hint="advances the index with one, if current index isn't larger than the number of elements to iterate">
		<cfif hasNext()>
			<cfset setIndex(getIndex()+1)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="next" returntype="any" hint="return next element in collection">
		<cfif setNext()>
			<cfreturn getCurrent()>
		</cfif>
		<cfabort showerror="There isn't a next element">
	</cffunction>
</cfcomponent>