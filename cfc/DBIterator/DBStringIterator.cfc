<cfcomponent extends="AbstractDBIterator" name="DBStringIterator" hint="Concrete implementation of iterator for a chracterstring">
	<cffunction name="init" returntype="any" hint="set iterator properties from characterstring">
		<cfargument name="collection" type="string" required="true">
		
		<cfset setCollection(arguments.collection)>
		<cfset setIterable(arguments.collection)>
		<cfset setLength(Len(arguments.collection))>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setNext" returntype="boolean" hint="update iterator properties when next is called; returns true on success">
		<cfif super.setNext()>
			<!--- <cfset setIndex(getIndex()+1)> --->
			<cfset setCurrent(Mid(getIterable(), getIndex(), 1))>
			<cfset setKey(getIndex())>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
</cfcomponent>