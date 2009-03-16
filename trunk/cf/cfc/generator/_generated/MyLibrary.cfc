<cfcomponent name="MyLibrary">
	<cfset variables.api_key = "">
	<cfset variables.auth_token = "">
	<cfset variables.japie = "">
	<cfset this.user = "">
	<cfset this.page = "1">
	<cfset this.limit = "50">
	
		
	<cffunction name="init" output="No" returntype="MyLibrary">
		<cfargument name="user" type="string" required="true">
		<cfargument name="limit" type="numeric" required="false" default="#this.limit#">
		<cfargument name="japie" type="numeric" required="false" default="#variables.japie#">
		
		<cfset var local = StructNew()>
		<cfset local.user = arguments.user>
		<cfset local.limit = arguments.limit>
		<cfset local.japie = arguments.japie>
	
		<cfset setUser(arguments.user)>
		<cfset setLimit(arguments.limit)>
		<cfset _setJapie(arguments.japie)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getTracks" output="No" returntype="XML">
		<cfargument name="user" type="string" required="true">
		<cfargument name="limit" type="numeric" required="false" default="#this.limit#">
		<cfargument name="page" type="numeric" required="false" default="#this.page#">
		
		<cfset var local = StructNew()>
		<cfset local.user = arguments.user>
		<cfset local.limit = arguments.limit>
		<cfset local.page = arguments.page>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getAlbums" output="No" returntype="XML">
		<cfargument name="user" type="string" required="true">
		<cfargument name="limit" type="numeric" required="false" default="">
		<cfargument name="page" type="numeric" required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.user = arguments.user>
		<cfset local.limit = arguments.limit>
		<cfset local.page = arguments.page>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getArtists" output="No" returntype="XML">
		<cfargument name="user" type="string" required="true">
		<cfargument name="limit" type="numeric" required="false" default="">
		<cfargument name="page" type="numeric" required="false" default="">
		
		<cfset var local = StructNew()>
		<cfset local.user = arguments.user>
		<cfset local.limit = arguments.limit>
		<cfset local.page = arguments.page>
		
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
	
	
	<cffunction name="_getJapie" output="No">
		<cfreturn variables.japie>
	</cffunction>
	<cffunction name="_setJapie" output="No">
		<cfargument name="japie" type="numeric" required="true">
		<cfset variables.japie = arguments.japie>
	</cffunction>
	
	
	<cffunction name="getUser" output="No">
		<cfreturn this.user>
	</cffunction>
	<cffunction name="setUser" output="No">
		<cfargument name="user" type="string" required="true">
		<cfset this.user = arguments.user>
	</cffunction>
	
	
	<cffunction name="getPage" output="No">
		<cfreturn this.page>
	</cffunction>
	<cffunction name="setPage" output="No">
		<cfargument name="page" type="numeric" required="false">
		<cfset this.page = arguments.page>
	</cffunction>
	
	
	<cffunction name="getLimit" output="No">
		<cfreturn this.limit>
	</cffunction>
	<cffunction name="setLimit" output="No">
		<cfargument name="limit" type="numeric" required="false">
		<cfset this.limit = arguments.limit>
	</cffunction>
</cfcomponent>
