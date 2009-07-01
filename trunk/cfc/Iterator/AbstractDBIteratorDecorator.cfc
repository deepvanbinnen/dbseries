<cfcomponent extends="AbstractDBIterator" hint="delegate method calls from an iterator">
	<cfset variables.factory  = "">
	<cfset variables.iterator = "">
	
	<cffunction name="init" returntype="any" hint="set the concrete iterator to use for delegation">
		<cfargument name="factory"  required="true" type="any" hint="the factory used to create me">
		<cfargument name="iterator" required="true" type="any" hint="a concrete iterator">
			<cfset variables.iterator = arguments.iterator>
			<cfset variables.factory  = arguments.factory>
			
			<cfset _setCollection(getCollection())>
			<cfset _setLength(getLength())>
			<cfset _updateProperties()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create">
		<cfreturn variables.factory.create(argumentCollection=arguments)>
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
	
	<cffunction name="_updateProperties">
		<cfset _setKey(getKey())>
		<cfset _setIndex(getIndex())>
		<cfset _setCurrent(getCurrent())>
		<cfreturn this>
	</cffunction>
</cfcomponent>