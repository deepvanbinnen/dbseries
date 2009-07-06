<cfcomponent>
	<cfset variables.outtype = "">
	<cfset variables.intype = "">
	<cfset variables.component = "">
	<cfset variables.method = "">
	<cfset variables.parameter = "">
	
	<cffunction name="init">
		<cfargument name="outtype"   required="true" type="string">
		<cfargument name="intype"    required="true" type="string">
		<cfargument name="component" required="true" type="any">
		<cfargument name="method"    required="true" type="string">
		<cfargument name="parameter" required="true" type="string">
		
		<cfset variables.outtype = arguments.outtype>
		<cfset variables.intype = arguments.intype>
		<cfset variables.component = arguments.component>
		<cfset variables.method = arguments.method>
		<cfset variables.parameter = arguments.parameter>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getOutType">
		<cfreturn variables.outtype>
	</cffunction>
	
	<cffunction name="getInType">
		<cfreturn variables.intype>
	</cffunction>
	
	<cffunction name="getComponent">
		<cfreturn variables.component>
	</cffunction>
	
	<cffunction name="getMethod">
		<cfreturn variables.method>
	</cffunction>
	
	<cffunction name="getParameter">
		<cfreturn variables.parameter>
	</cffunction>
	
</cfcomponent>