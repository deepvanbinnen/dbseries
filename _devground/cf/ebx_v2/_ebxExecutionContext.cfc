<cfcomponent>
	<cfset variables.pi = "">
	<cfset variables.parameters = StructNew()>
	<cfset variables.originals  = StructNew()>
	<cfset variables.includes   = ArrayNew(1)>
	<cfset variables.output     = "">
	
	<cffunction name="init">
		<cfargument name="ParserInterface" type="ebxParserInterface">
		<cfargument name="template"   type="string" default="">
		<cfargument name="parameters" type="struct" default="#StructNew()#">
			<cfset variables.pi = arguments.ParserInterface>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="releaseParameters">
		<cfset var local = StructNew()>
		<cfset local.attr = variables.pi.getAttributes()>
		<cfset StructAppend(local.attr, variables.originals, true)>
		<cfset variables.pi.setAttributes(local.attr)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="storeParameters">
		<cfset var local = StructNew()>
		<cfset local.attr   = variables.pi.getAttributes()>
		<cfset local.params = getParameters()>
		<cfloop collection="#local.params#" item="local.param">
			<cfif StructKeyExists(arguments.attr, local.param)>
				<cfset StructInsert(variables.originals, local.param, local.params[local.param], TRUE)>
			</cfif>
		</cfloop>
		<cfset StructAppend(local.attr, local.params, true)>
		<cfset variables.pi.setAttributes(local.attr)>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getIncludes">
		<cfreturn variables.includes>
	</cffunction>
	
	<cffunction name="getOutput">
		<cfreturn variables.output>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn variables.parameters>
	</cffunction>
	
	<cffunction name="setOutput">
		<cfargument name="output" type="string">
		<cfset variables.output = variables.output & arguments.output>
		<cfreturn getOutput()>
	</cffunction>
	
	<cffunction name="setParameters">
		<cfargument name="parameters" type="struct">
			<cfset variables.parameters = arguments.parameters>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setIncludes">
		<cfargument name="includes" type="any">
		<cfif IsArray(includes)>
			<cfset variables.includes.addAll(arguments.includes)>
		<cfelseif IsSimpleValue(arguments.includes)>
			<cfset variables.includes.addAll(ListToArray(arguments.includes))>
		</cfif>
		<cfreturn this>
	</cffunction>
</cfcomponent>