<cfcomponent hint="I represent the stack of executions for the parser">
	<cfset variables.MAXREQUESTS  = 100>
	<cfset variables.stack        = ArrayNew(1)>
	<cfset variables.executed     = ArrayNew(1)>
	<cfset variables.types        = StructNew()>
	<cfset variables.emptyContext = "">
	<cfset variables.current      = "">
	
	<cffunction name="init">
		<cfargument name="emptyContext" type="any" hint="context to add">
			<cfset variables.emptyContext = arguments.emptyContext>
			<cfset setEmptyContext()>
			<cfset setCurrent(getEmptyContext())>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add" returntype="boolean" hint="adds context to stack return true on succeed">
		<cfargument name="context" type="any" hint="context to add">
		<cfif maxReached()>
			<cfreturn false>
		</cfif>
		<cfset ArrayPrepend(variables.stack, arguments.context)>
		<cfset StructInsert(variables.types, arguments.context.getType(), true, true)>
		<cfset setCurrent(arguments.context)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="get" returntype="any">
		<cfargument name="index" type="numeric" required="false" default="0">
		
		<cfif arguments.index eq 0>
			<cfreturn getCurrent()>
		<cfelse>
			<cfif getLength() GTE arguments.index>
				<cfreturn variables.stack[arguments.index]>
			</cfif>
			<cfreturn getEmptyContext()>
		</cfif>
	</cffunction>
	
	<cffunction name="getCurrent">
		<cfreturn variables.current>
	</cffunction>
	
	<cffunction name="getEmptyContext">
		<cfreturn variables.emptyContext>
	</cffunction>
	
	<cffunction name="getLength">
		<cfreturn ArrayLen(getStack())>
	</cffunction>
	
	<cffunction name="getExecutedStack">
		<cfreturn variables.executed>
	</cffunction>
	
	<cffunction name="getStack">
		<cfreturn variables.stack>
	</cffunction>
	
	<cffunction name="getTypes">
		<cfreturn variables.types>
	</cffunction>
	
	<cffunction name="hasType">
		<cfargument name="type" type="string" required="true" hint="type to check">
		<cfreturn StructKeyExists(variables.stack, arguments.type)>
	</cffunction>
	
	<cffunction name="hasMainRequest">
		<cfargument name="type" type="string" required="true" hint="type to check">
		<cfreturn hasType("mainrequest")>
	</cffunction>
	
	<cffunction name="isMainRequest">
		<cfreturn get().getType() eq "mainrequest">
	</cffunction>
	
	<cffunction name="maxReached">
		<cfreturn (getLength() GT variables.MAXREQUESTS)>
	</cffunction>
	
	<cffunction name="remove">
		<cfif getLength()>
			<cfset ArrayAppend(variables.executed, getCurrent())>
			<cfset ArrayDeleteAt(variables.stack,1)>
			<cfset setCurrent(get(1))>
			<cfreturn true>
		</cfif>
		<cfset setEmptyContext()>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="setCurrent">
		<cfargument name="context" type="any" hint="context to 'archive'">
		<cfset variables.current = arguments.context>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setEmptyContext">
		<cfset setCurrent(getEmptyContext())>
	</cffunction>
	
	<cffunction name="_dump">
		<h3>Stack</h3>
		<cfloop from="1" to="#Arraylen(variables.stack)#" index="i">
			<cfdump var="#variables.stack[i]._dump()#">	
		</cfloop>	
		<hr />
		<h3>Executed</h3>
		<cfloop from="1" to="#Arraylen(variables.executed)#" index="i">
			<cfdump var="#variables.executed[i]._dump()#">	
		</cfloop>
	</cffunction>
</cfcomponent>