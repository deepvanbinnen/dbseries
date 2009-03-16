<cfcomponent extends="SetOf">
	<cfset variables.iterator = "">
	<cfset variables.itcount  = "0">
	<cfset variables.hasavailable = FALSE>
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="iterator">
		<cfargument name="iterable" type="any" required="true">
		<cfset setIterator()>
		<cfif IsObject(variables.iterator)>
			<cfreturn variables.iterator.init(arguments.iterable)>
		</cfif>
	</cffunction>
	
	<cffunction name="setIterator">
		<cfset var Local = StructNew()>
		<cfset Local.iters = super.iterator()>
		<cfloop condition="#Local.iters.whileHasNext()#">
			<cfif Local.iters.current.done>
				<cfset variables.iterator = Local.iters.current>
				<cfreturn true>
			</cfif>
		</cfloop>
		<cfset variables.iterator = addIterator()>
	</cffunction>
	
	<cffunction name="addIterator">
		<cfset super._add(createObject("component", "Iterator"))>
		<cfset variables.itcount  = super.getLength()>
		<cfreturn super.getLastItem()>
	</cffunction>
	
</cfcomponent>