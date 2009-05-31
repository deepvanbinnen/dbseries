<cfcomponent hint="I represent the stack of executions for the parser">
	<cfset variables.MAXREQUESTS = 10>
	<cfset variables.stack       = ArrayNew(1)>
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add" returntype="boolean" hint="adds context to stack return true on succeed">
		<cfargument name="context" hint="context to add">
		<cfif maxReached()>
			<cfreturn false>
		</cfif>
		<cfset ArrayPrepend(variables.stack, arguments.context)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="get">
		<cfargument name="index" type="numeric" required="false" default="1">
		<cfif getLength() GTE arguments.index>
			<cfreturn variables.stack[arguments.index]>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="getLength">
		<cfreturn ArrayLen(getStack())>
	</cffunction>
	
	<cffunction name="getOriginal">
		<cfif getLength()>
			<cfreturn get(getLength())>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getStack">
		<cfreturn variables.stack>
	</cffunction>
	
	<cffunction name="isOriginal">
		<cfreturn (getLength() eq 1)>
	</cffunction>
	
	<cffunction name="maxReached">
		<cfreturn (getLength() GT variables.MAXREQUESTS)>
	</cffunction>
	
	<cffunction name="remove">
		<cfif getLength()>
			<cfset ArrayDeleteAt(variables.stack,1)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
</cfcomponent>