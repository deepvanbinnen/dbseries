<cfcomponent name="Pair">
	<cfset this.pair  = "">
	<cfset this.key = "">
	<cfset this.value = "">
	
	<cfset variables.delimiter = "=">
	
	<cffunction name="init">
		<cfargument name="pair"      required="true" type="any">
		<cfargument name="delimiter" required="false" type="string" default="#_getDelimiter()#">
		<cfif arguments.delimiter neq _getDelimiter()>
			<cfset _setDelimiter(arguments.delimiter)>
		</cfif>
		<cfset _setPair(arguments.pair)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getKey">
		<cfreturn this.key>
	</cffunction>
	
	<cffunction name="getValue">
		<cfreturn this.value>
	</cffunction>
	
	<cffunction name="setKey">
		<cfargument name="key" type="any" required="true">
		<cfset this.key = TRIM(arguments.key)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setValue">
		<cfargument name="value" type="any" required="true">
		<cfset this.value = arguments.value>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setPair">
		<cfargument name="pair" required="true" type="any">
		<cfset var local = StructNew()>
		<cfset local.pair = ListToArray(arguments.pair, _getDelimiter())>
		<cfif ArrayLen(local.pair)>
			<cfset setKey(local.pair[1])>
			<cfif ArrayLen(local.pair) gt 1>
				<cfset ArrayDeleteAt(local.pair, 1)>
				<cfset local.tmp = ArrayNew(1)>
				<cfset local.tmp.addAll(local.pair)>
				<cfset setValue(ArrayToList(local.tmp, "="))>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="_getDelimiter">
		<cfreturn variables.delimiter>
	</cffunction>
	
	<cffunction name="_setDelimiter">
		<cfargument name="delimiter" type="any" required="true">
		<cfset variables.delimiter = arguments.delimiter>
		<cfreturn this>
	</cffunction>
	
	
	
</cfcomponent>