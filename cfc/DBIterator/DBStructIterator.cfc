<cfcomponent extends="AbstractDBNativeIterator" name="DBStructIterator" hint="Concrete implementation for a struct-iterator">
	<cffunction name="init" returntype="any"  hint="set iterator properties from struct">
		<cfargument name="collection" type="struct" required="true">
		
		<cfset setCollection(arguments.collection)>
		<cfset setIterable(getCollection().entrySet().iterator())>
		<cfset super.init()>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="setNext" returntype="boolean" hint="update iterator properties when next is called; returns true on success">
		<cfif super.setNext()>
			<cfset setKey(getCurrent().getKey())>
			<cfset setCurrent(getCurrent().getValue())>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="reset" returntype="any" hint="resets the iterator">
		<cfset super.reset()>
		<cfset setIterable(getCollection().entrySet().iterator())>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>