<cfcomponent extends="AbstractDBNativeIterator" name="DBArrayIterator" hint="Concrete implementation for an array-iterator">
	<cffunction name="init" returntype="any" hint="set iterator properties from array">
		<cfargument name="collection" type="array" required="true">
		<cfset setCollection(arguments.collection)>
		<cfset setIterable(getCollection().iterator())>
		<cfset super.init()>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setNext" returntype="boolean" hint="update iterator properties when next is called; returns true on success">
		<cfif super.setNext()>
			<cfset setKey(getIndex())>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="reset" returntype="any" hint="resets the iterator">
		<cfset super.reset()>
		<cfset setIterable(getCollection().iterator())>
		<cfreturn this>
	</cffunction>
</cfcomponent>