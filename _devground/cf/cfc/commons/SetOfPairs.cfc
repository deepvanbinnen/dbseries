<cfcomponent name="SetOfPairs" extends="SetOf" hint="manage a collection of pairs">
	<cfset variables.delimiter     = ","><!--- Delimiter for the string in --->
	<cfset variables.pairdelimiter = "="><!--- Delimiter for the key-pair-val --->
	
	<cfset variables.keys = ArrayNew(1)>
	
	<cffunction name="init" hint="instantiate and parse">
		<cfargument name="pairstring"    required="true" type="any" hint="key-value string to parse">
		<cfargument name="delimiter"     required="false" type="string" default="#_getDelimiter()#" hint="defaults to comma">
		<cfargument name="pairdelimiter" required="false" type="string" default="#_getPairDelimiter()#" hint="defaults to equals">
		
		<!--- reset delimiters if necessary --->
		<cfif arguments.delimiter neq _getDelimiter()>
			<cfset _setDelimiter(arguments.delimiter)>
		</cfif>
		<cfif arguments.pairdelimiter neq _getPairDelimiter()>
			<cfset _setPairDelimiter(arguments.pairdelimiter)>
		</cfif>
		<!--- parse string and populate the SetOf-instance --->
		<cfset _populate(ListToArray(arguments.pairstring, _getDelimiter()))>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getValue">
		<cfargument name="key" required="true" type="any">
		<cfset var Local = StructNew()>
		<cfset Local.value = findKey(arguments.key)>
		
		<cfif NOT isSimpleValue(Local.value)>
			<cfset Local.value = Local.value.getValue()>
		</cfif>
		<cfreturn Local.value>
	</cffunction>
	
	<cffunction name="getKey">
		<cfargument name="key" required="true" type="any">
		<cfreturn findKey(arguments.key)>
	</cffunction>
	
	<cffunction name="getKeys">
		<cfreturn ArrayToList(variables.keys)>
	</cffunction>
		
	<cffunction name="getPairs">
		<cfreturn getCollection()>
	</cffunction>
	
	<cffunction name="iterator">
		<cfargument name="iterable" required="false" type="any" default="#getPairs()#">
		<cfreturn super.iterator(arguments.iterable)>
	</cffunction>
	
	<cffunction name="findKey">
		<cfargument name="key" required="true" type="any">
		<cfset var Local = StructNew()>
		<cfset Local.pairs = iterator()>
		<cfloop condition="#Local.pairs.whileHasNext()#">
			<cfif Local.pairs.current.getKey() eq arguments.key>
				<cfreturn Local.pairs.current>
			</cfif>
		</cfloop>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="asStruct">
		<cfset var Local = StructNew()>
		<cfset Local.struct = StructNew()>
		<cfset Local.it     = iterator()>
		<cfloop condition="#Local.it.whileHasNext()#">
			<cfset StructInsert(Local.struct, Local.it.current.getKey(), Local.it.current.getValue(), TRUE)>
		</cfloop>
		<cfreturn Local.struct>
	</cffunction>
	
	<cffunction name="_getDelimiter">
		<cfreturn variables.delimiter>
	</cffunction>
	
	<cffunction name="_setDelimiter">
		<cfargument name="delimiter" type="any" required="true">
		<cfset variables.delimiter = arguments.delimiter>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_getPairDelimiter">
		<cfreturn variables.pairdelimiter>
	</cffunction>
	
	<cffunction name="_setPairDelimiter">
		<cfargument name="pairdelimiter" type="any" required="true">
		<cfset variables.pairdelimiter = arguments.pairdelimiter>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_populate" hint="take a list of pairs, instantiate pair objects and add them to the SetOf-instance">
		<cfargument name="pairs"     required="true" type="any">
		
		<cfset var Local = StructNew()>
		<!--- get an iterator object --->
		<cfset Local.pairs = super.iterator(arguments.pairs)>
		<cfloop condition="#Local.pairs.whileHasNext()#">
			<!--- create and add pair --->
			<cfset _add(createObject("component", "Pair").init(Local.pairs.current, _getPairDelimiter()))>
			<!--- append key to list of keys --->
			<cfset ArrayAppend(variables.keys, getLastItem().getKey())>
		</cfloop>
	</cffunction>

</cfcomponent>