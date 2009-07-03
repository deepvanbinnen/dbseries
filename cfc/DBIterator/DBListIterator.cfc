<cfcomponent extends="DBArrayIterator" name="DBListIterator" hint="Concrete implementation for a list-iterator, converts list to array and uses array-iterator">
	<cffunction name="init" returntype="any" hint="convert list to array and return array iterator">
		<cfargument name="collection"  type="string" required="true">
		<cfargument name="delimiter" type="string" required="false" default=",">
		
		<cfset setDelimiter(arguments.delimiter)>
		<cfreturn super.init(ListToArray(arguments.collection, getDelimiter()))>	
	</cffunction>
	
	<cffunction name="reset" returntype="any" hint="resets the iterator">
		<cfset super.reset()>
		<cfreturn init(getList(), getDelimiter())>
	</cffunction>
	
	<cffunction name="getList" returntype="any" hint="resets the iterator">
		<cfreturn ArrayToList(getCollection(), getDelimiter())>
	</cffunction>

	<cffunction name="getDelimiter" returntype="any" hint="resets the iterator">
		<cfreturn variables.delimiter>
	</cffunction>
	
	<cffunction name="setDelimiter" returntype="any" hint="resets the iterator">
		<cfargument name="delimiter" type="string" required="true" default=",">
			<cfset variables.delimiter = arguments.delimiter>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>