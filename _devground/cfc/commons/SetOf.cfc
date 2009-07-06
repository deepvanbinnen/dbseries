<cfcomponent name="SetOf">
	<cfset variables.collection = ArrayNew(1)>
	<cfset variables.length     = ArrayLen(variables.collection)>
	
	<cffunction name="init">
		<cfif ArrayLen(arguments) neq 0>
			<cfset _populate(arguments[1])>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="iterator">
		<cfargument name="iterable" required="false" type="any" default="#getCollection()#">
		<cfreturn createObject("component", "Iterator").init(arguments.iterable)>
	</cffunction>
	
	<cffunction name="getItem">
		<cfargument name="index" required="true" type="numeric">
		<cfreturn _get(arguments.index)>
	</cffunction>
	
	<cffunction name="getFirstItem">
		<cfreturn _get(1)>
	</cffunction>
	
	<cffunction name="getLastItem">
		<cfreturn _get(getLength())>
	</cffunction>
	
	<cffunction name="getCollection">
		<cfreturn variables.collection>
	</cffunction>
	
	<cffunction name="getLength">
		<cfreturn variables.length>
	</cffunction>
	
	<cffunction name="_setLength">
		<cfargument name="length" required="false" type="any" default="#ArrayLen(getCollection())#">
		<cfset variables.length = arguments.length>
		<cfif variables.length neq ArrayLen(getCollection())>
			<cfset ArrayResize(getCollection(), variables.length)>
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="_get">
		<cfargument name="index" required="true" type="any">
		<cfif arguments.index gt 0 AND arguments.index LTE getLength()>
			<cfreturn variables.collection[arguments.index]>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="_add">
		<cfargument name="item" required="true" type="any">
		<cfset ArrayAppend(variables.collection, arguments.item)>
		<cfset _setLength()>
	</cffunction>
	
	<cffunction name="_populate">
		<cfargument name="items" required="true" type="any">
		<cfset var Local = StructNew()>
		<cfset Local.items = iterator(arguments.items)>
		<cfloop condition="#Local.items.whileHasNext()#">
			<cfset _add(Local.items.current)>
		</cfloop>
	</cffunction>
	
</cfcomponent>