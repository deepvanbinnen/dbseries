<cfcomponent displayname="ebxParameters" hint="I provide an interface for parameters">
	<cfset variables.ebx  = "">
	<cfset variables.params = StructNew()>
	
	<cffunction name="init">
		<cfargument name="ebx"        required="true">
		<cfargument name="parameters" required="false" type="struct" default="#StructNew()#">
		
		<cfset variables.ebx = arguments.ebx>
		<cfset setParameters(arguments.parameters)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getParameter" output="false" hint="gets parameter or returns the given default value">
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
	
	<cffunction name="getParameters" output="false" hint="get parameterstruct">
		<cfreturn variables.params>
	</cffunction>
	
	<cffunction name="hasParameter" output="false" hint="check if a parameter exists">
		<cfargument name="name" required="true" type="string" hint="the parameter to lookup">
		<cfreturn StructKeyExists(variables.params,arguments.name)>
	</cffunction>
	
	<cffunction name="setParameter" output="false" hint="set parameter, by default overwrites existing parameters">
		<cfargument name="name"      required="true"  type="string"  hint="parametername">
		<cfargument name="value"     required="true"  type="any"     hint="parametervalue">
		<cfargument name="overwrite" required="false" type="boolean" default="true" hint="overwrite parameter?">
		
		<cfset StructInsert(variables.params,arguments.name,arguments.value,arguments.overwrite)>
	</cffunction>
	
	<cffunction name="setParameters" output="false" hint="sets box-parameters from struct">
		<cfargument name="parameters" required="true"  type="struct">
		<cfargument name="overwrite"  required="false" type="boolean" default="false" hint="overwrite parameter">
		
		<cfset StructAppend(variables.params,arguments.parameters,arguments.overwrite)>
	</cffunction>
</cfcomponent>