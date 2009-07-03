<cfcomponent extends="AbstractDBIterator" hint="iterator decorator">
	<cfset variables.factory  = createObject("component", "DBIteratorFactory")>
	<cfset variables.iterator = variables.factory.getNullIterator()>
	
	<cffunction name="init" returntype="any"  hint="initialise creation object for iterators">
		<cfif ArrayLen(arguments) GT 1>
			<cfreturn create(arguments[1], arguments[2])>
		<cfelseif ArrayLen(arguments) GT 0>
			<cfreturn create(arguments[1])>
		<cfelse>
			<cfreturn _setIterator(variables.factory.nullIterator)>
		</cfif>
	</cffunction>
	
	<cffunction name="create">
		<cfargument name="collection" type="any"    required="true"  hint="the collection to create an iterator for">
		<cfargument name="listdelim"  type="string" required="false" default="," hint="the delimiter used for 'SimpleValue' lists, pass in empty string to create a string iterator using Mid()">
		
		<cfset _setIterator(variables.factory.create(argumentCollection=arguments))>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setIterator">
		<cfargument name="iterator" type="any"  required="true" hint="the current iterator">
		
		<cfset variables.iterator = arguments.iterator>
		<!--- Update decorator properties --->
		<!--- TODO: This just can not be the right way to do this  --->
		<cfset _setCollection(getCollection())>
		<cfset _setLength(getLength())>
		<cfset _updateProperties()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_updateProperties">
		<cfset _setKey(getKey())>
		<cfset _setIndex(getIndex())>
		<cfset _setCurrent(getCurrent())>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="reset" returntype="any" hint="resets the iterator">
		<cfreturn variables.iterator.reset()>
	</cffunction>
	
	<cffunction name="next">
		<cfif variables.iterator.next()>
			<cfset _updateProperties()>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="setNext">
		<cfif variables.iterator.setNext()>
			<cfset _updateProperties()>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="whileHasNext">
		<cfif variables.iterator.whileHasNext()>
			<cfset _updateProperties()>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="hasNext">
		<cfreturn variables.iterator.hasNext()>
	</cffunction>
	
	<cffunction name="getCollection">
		<cfreturn variables.iterator.getCollection()>
	</cffunction>
	
	<cffunction name="setCollection">
		<cfargument name="collection" type="any" required="true">
		<cfset _setCollection(arguments.collection)>
		<cfreturn variables.iterator.setCollection(arguments.collection)>
	</cffunction>
	
	<cffunction name="_setCollection">
		<cfargument name="collection" type="any" required="true">
		<cfreturn this.collection = arguments.collection>
	</cffunction>
	
	<cffunction name="getCurrent">
		<cfreturn variables.iterator.getCurrent()>
	</cffunction>
	
	<cffunction name="setCurrent">
		<cfargument name="current" type="any" required="true">
			<cfset variables.iterator.setCurrent(arguments.current)>
			<cfset _setCurrent()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setCurrent">
		<cfargument name="current" type="any" required="false" default="">
			<cfset this.current = arguments.current>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getIndex">
		<cfreturn variables.iterator.getIndex()>
	</cffunction>
	
	<cffunction name="setIndex">
		<cfargument name="index" type="numeric" required="true">
			<cfset variables.iterator.setIndex(arguments.index)>
			<cfset _setIndex(arguments.index)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setIndex">
		<cfargument name="index" type="numeric" required="true">
			<cfset this.index = arguments.index>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getKey">
		<cfreturn variables.iterator.getKey()>
	</cffunction>
	
	<cffunction name="setKey">
		<cfargument name="key" type="any" required="true">
		<cfset _setKey(arguments.key)>
		<cfreturn variables.iterator.setKey(arguments.key)>
	</cffunction>
	
	<cffunction name="_setKey">
		<cfargument name="key" type="any" required="true">
			<cfset this.key = arguments.key>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getLength">
		<cfreturn variables.iterator.getLength()>
	</cffunction>
	
	<cffunction name="setLength">
		<cfargument name="length" type="numeric" required="true">
		<cfset _setLength(arguments.length)>
		<cfreturn variables.iterator.setLength(arguments.length)>
	</cffunction>
	
	<cffunction name="_setLength">
		<cfargument name="length" type="numeric" required="true">
			<cfset this.length = arguments.length>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getIterable">
		<cfreturn variables.iterator.getIterable()>
	</cffunction>
	
	<cffunction name="setIterable">
		<cfargument name="iterable" type="any" required="true">
		<cfreturn variables.iterator.setIterable(arguments.iterable)>
	</cffunction>
	
	
</cfcomponent>