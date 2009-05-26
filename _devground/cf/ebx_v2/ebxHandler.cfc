<cfcomponent displayname="ebxRequestContext" hint="I am the request context">
	<cfset variables.pi     = "">
	<cfset variables.parser = "">
	
	<cfset variables.stack       = ArrayNew(1)><!--- the last request in stack is the main request --->
	<cfset variables.MAXREQUESTS = 10><!--- maximum requests the stack can handle --->
	<cfset variables.request     = "">
	
	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
			<cfset variables.pi = arguments.ParserInterface>
			<cfset variables.parser = variables.pi.getParser()>
		<cfreturn this>
	</cffunction>
	
	<!--- Request related --->
	<cffunction name="addRequest">
		<cfargument name="request" hint="the current request">
		
		<cfif maxRequestsReached()>
			<cfreturn false>
		</cfif>
		<cfset ArrayPrepend(variables.stack, arguments.request)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="createRequest">
		<cfargument name="action" type="string" required="true">
		<cfargument name="parameters" type="struct" required="false" default="#StructNew()#">
		
		<cfreturn createObject("component", "ebxRequest").init(variables.pi, arguments.action, arguments.parameters)>
	</cffunction>
	
	<cffunction name="getOriginalRequest">
		<cfif hasRequests()>
			<cfreturn variables.stack[hasRequests()]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getRequest">
		<cfif hasRequests()>
			<cfreturn variables.stack[1]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getRequestVariable">
		<cfargument name="request">	
		<cfargument name="prop">
		
		<cfif IsStruct(arguments.request) AND StructKeyExists(arguments.request, "get")>
			<cfreturn arguments.request.get(arguments.prop)>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getRequests">
		<cfreturn variables.stack>
	</cffunction>
	
	<cffunction name="maxRequestsReached">
		<cfreturn (hasRequests() GT variables.MAXREQUESTS)>
	</cffunction>

	<cffunction name="hasRequests">
		<cfreturn ArrayLen(variables.stack)>
	</cffunction>
	
	<cffunction name="isOriginalRequest">
		<cfreturn hasRequests() eq 1>
	</cffunction>
	
	<cffunction name="removeRequest">
		<cfif hasRequests(variables.stack)>
			<cfset ArrayDeleteAt(variables.stack,1)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
</cfcomponent>