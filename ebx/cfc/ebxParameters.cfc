<cfcomponent displayname="ebxParameters" hint="I provide an interface for parameters">
	<cfset variables.ebx  = "">
	<cfset variables.params = StructNew()>
	
	<cffunction name="init" returntype="ebxParameters" hint="initialise parameters">
		<cfargument name="ebx"        required="true" type="ebx" hint="ebx instance">
		<cfargument name="parameters" required="false" type="struct" default="#StructNew()#" hint="initial parameters">
		
		<cfset variables.ebx = arguments.ebx>
		<cfset setParameters(arguments.parameters)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getParameter" returntype="any" hint="gets parameter or returns the given default value">
		<cfargument name="name"   required="true"  type="string"                  hint="parameter to get">
		<cfargument name="value"  required="false" type="any"     default=""      hint="parameter's default value " >
		<cfargument name="create" required="false" type="boolean" default="false" hint="add parameter if it doesn't exist">
		
		<cfif NOT hasParameter(arguments.name)>
			<cfif arguments.create>
				<cfset setParameter(arguments.name, arguments.value)>
			<cfelse>
				<cfreturn arguments.value>
			</cfif>
		</cfif>
		<cfreturn variables.params[arguments.name]>
	</cffunction>
	
	<cffunction name="getParameters" returntype="struct" hint="get parameterstruct">
		<cfreturn variables.params>
	</cffunction>
	
	<cffunction name="hasParameter" returntype="boolean" hint="check if a parameter exists">
		<cfargument name="name" required="true" type="string" hint="the parameter to lookup">
		<cfreturn StructKeyExists(variables.params,arguments.name)>
	</cffunction>
	
	<cffunction name="setParameter" returntype="any" hint="set parameter, by default overwrites existing parameter and return instance">
		<cfargument name="name"      required="true"  type="string"  hint="parameter name">
		<cfargument name="value"     required="true"  type="any"     hint="parameter value">
		<cfargument name="overwrite" required="false" type="boolean" default="true" hint="overwrite existing parameter?">
		
		<cfset StructInsert(variables.params,arguments.name,arguments.value,arguments.overwrite)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setParameters" returntype="any" hint="sets parameters from struct and return instance">
		<cfargument name="parameters" required="true"  type="struct"  hint="parameter values">
		<cfargument name="overwrite"  required="false" type="boolean" default="false" hint="overwrite existing parameters?">
		
		<cfset StructAppend(variables.params,arguments.parameters,arguments.overwrite)>
		
		<cfreturn this>
	</cffunction>
</cfcomponent>