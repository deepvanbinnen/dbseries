<cfcomponent extends="AbstractDBIterator" hint="Execute methods on native JAVA-iterator">
	<cffunction name="init" returntype="any" hint="set iterator properties from native JAVA-iterator">
		<cfset setLength(getCollection().size())>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="hasNext" returntype="boolean" hint="checks if there is a next element from native JAVA-iterator">
		<cfreturn getIterable().hasNext()>
	</cffunction>
	
	<cffunction name="setNext" returntype="boolean" hint="update current element with next element from native JAVA-iterator, returns true on success">
		<cfif super.setNext()>
			<cfset setCurrent(getIterable().next())>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
</cfcomponent>