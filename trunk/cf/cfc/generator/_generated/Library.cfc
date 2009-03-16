<cfcomponent name="Library">
	<cfset variables.api_key = "">
	<cfset variables.auth_token = "">
	<cfset variables.user = "">
	<cfset this.user = "">
	<cfset this.limit = "50">
	<cfset this.page = "1">
	
		
	<cffunction name="init" output="No" returntype="Library">
		<cfargument name="user" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.user = arguments.user>
	
		<cfset _setUser(arguments.user)>
		<cfset setUser(arguments.user)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAlbums" output="No" returntype="Pageable">
		<cfargument name="user" type="string" required="true">
		<cfargument name="limit" type="numeric" required="false" default="#this.limit#">
		<cfargument name="page" type="numeric" required="false" default="#this.page#">
		
		<cfset var local = StructNew()>
		<cfset local.user = arguments.user>
		<cfset local.limit = arguments.limit>
		<cfset local.page = arguments.page>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getArtist" output="No" returntype="Pageable">
		<cfargument name="user" type="string" required="true">
		<cfargument name="limit" type="numeric" required="false" default="#this.limit#">
		<cfargument name="page" type="numeric" required="false" default="#this.page#">
		
		<cfset var local = StructNew()>
		<cfset local.user = arguments.user>
		<cfset local.limit = arguments.limit>
		<cfset local.page = arguments.page>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getTracks" output="No" returntype="Pageable">
		<cfargument name="user" type="string" required="true">
		<cfargument name="limit" type="numeric" required="false" default="#this.limit#">
		<cfargument name="page" type="numeric" required="false" default="#this.page#">
		<cfargument name="search" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.user = arguments.user>
		<cfset local.limit = arguments.limit>
		<cfset local.page = arguments.page>
		<cfset local.search = arguments.search>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="_getApi_key" output="No">
		<cfreturn variables.api_key>
	</cffunction>
	<cffunction name="_setApi_key" output="No">
		<cfargument name="api_key" type="string" required="true">
		<cfset variables.api_key = arguments.api_key>
	</cffunction>
	
	
	<cffunction name="_getAuth_token" output="No">
		<cfreturn variables.auth_token>
	</cffunction>
	<cffunction name="_setAuth_token" output="No">
		<cfargument name="auth_token" type="string" required="true">
		<cfset variables.auth_token = arguments.auth_token>
	</cffunction>
	
	
	<cffunction name="_getUser" output="No">
		<cfreturn variables.user>
	</cffunction>
	<cffunction name="_setUser" output="No">
		<cfargument name="user" type="string" required="true">
		<cfset variables.user = arguments.user>
	</cffunction>
	
	
	<cffunction name="getUser" output="No">
		<cfreturn this.user>
	</cffunction>
	<cffunction name="setUser" output="No">
		<cfargument name="user" type="string" required="true">
		<cfset this.user = arguments.user>
	</cffunction>
	
	
	<cffunction name="getLimit" output="No">
		<cfreturn this.limit>
	</cffunction>
	<cffunction name="setLimit" output="No">
		<cfargument name="limit" type="numeric" required="false">
		<cfset this.limit = arguments.limit>
	</cffunction>
	
	
	<cffunction name="getPage" output="No">
		<cfreturn this.page>
	</cffunction>
	<cffunction name="setPage" output="No">
		<cfargument name="page" type="numeric" required="false">
		<cfset this.page = arguments.page>
	</cffunction>
</cfcomponent>
