<cfcomponent hint="ebx factory">
	<cfset this.mapping       = "">
	<cfset this.defaultmethod = "init">
	
	<cffunction name="init" hint="create object">
		<cfargument name="mapping"       type="string" required="true"  default="">
		<cfargument name="defaultmethod" type="string" required="false" default="#this.defaultmethod#">
		
		<cfset this.mapping       = arguments.mapping>
		<cfset this.defaultmethod = arguments.defaultmethod>
	</cffunction>
	
	<cffunction name="create" hint="create object">
		<cfargument name="cfc"    type="string" required="true">
		<cfargument name="method" type="string" required="false" default="">
		<cfargument name="params" type="struct" required="false" default="#StructNew()#">
		
		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		<cfset local.result.data = createObject("component", getMapping(arguments.cfc))>
		
		
		<cfif arguments.method neq "">
			<cfreturn call(local.result.data, arguments.method, arguments.params)>
		</cfif>
		
		<cfreturn local.result.data>
	</cffunction>
	
	<cffunction name="call" hint="create object">
		<cfargument name="cfc"    type="any"    required="true">
		<cfargument name="method" type="string" required="true">
		<cfargument name="params" type="struct" required="false" default="#StructNew()#">
		
		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
				
		<cftry>
			<cfinvoke component="#arguments.cfc#" method="#arguments.method#" argumentcollection="#arguments.params#" returnvariable="local.result"></cfinvoke>
			<cfcatch type="any">
				<cfset local.result.data = cfcatch>
			</cfcatch>
		</cftry>
		
		
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getMapping" hint="get cfc mapping">
		<cfargument name="cfc"    type="string" required="false" default="">
		
		<cfif arguments.cfc neq "">
			<cfif this.mapping neq "">
				<cfreturn this.mapping & "." & arguments.cfc>
			<cfelse>
				<cfreturn arguments.cfc>
			</cfif>
		<cfelse>
			<cfreturn this.mapping>
		</cfif>
	</cffunction>

</cfcomponent>