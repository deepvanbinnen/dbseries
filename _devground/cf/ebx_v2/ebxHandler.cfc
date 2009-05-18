<cfcomponent extends="ebxCore" displayname="ebxRequestContext" hint="I am the request context">
	<cfset variables.ebx         = "">
	
	<cfset variables.stack       = ArrayNew(1)><!--- the last request in stack is the main request --->
	<cfset variables.MAXREQUESTS = 10><!--- maximum requests the stack can handle --->
	<cfset variables.request     = "">
	
	<cffunction name="init">
		<cfargument name="ebx">
			<cfset variables.ebx = arguments.ebx>
			<cfset variables.ebx.setDebug("Initializing ebxRequestContext", 0)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getRequest">
		<cfif hasRequests()>
			<cfreturn variables.stack[1]>
		</cfif>
	</cffunction>

	
	<cffunction name="getRequests">
		<cfreturn variables.stack>
	</cffunction>

	<cffunction name="hasRequests">
		<cfreturn ArrayLen(variables.stack)>
	</cffunction>
	
	<!--- Request related --->
	<cffunction name="addRequest">
		<cfargument name="request" hint="the current request">
		
		<cfset var local = StructNew()>
		
		<cfif ArrayLen(variables.stack) GT variables.MAXREQUESTS>
			<cfset setDebug("Max reached: #variables.MAXREQUESTS#", 0)>
		</cfif>
		
		<cfset ArrayPrepend(variables.stack,arguments.request)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="removeRequest">
		<cfif ArrayLen(variables.stack) GT 0>
			<cfset ArrayDeleteAt(variables.stack,1)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
</cfcomponent>