<cfcomponent displayname="ebxPageContext" hint="I provide an interface for the java pagecontext object and handle inclusion of templates/assignment of variables">
	<cffunction name="ebx_include" hint="includes file in the page">
		<cfargument name="template" required="true" type="string" hint="full mapping path to the include file">
		
		<cfset var result = StructNew()>
		<cfset result.output = "">
		<cfset result.errors = false>
		<cfset result.caught = "">
		
		<cftry>
			<cfsavecontent variable="result.output">
				<cftry>
					<cfinclude template="#arguments.template#">
					<cfoutput><!-- DEBUG: #arguments.template# --></cfoutput>
					<cfcatch type="any">
						<cfdump var="#cfcatch#">
						<cfset result.output = "#cfcatch.message# -#cfcatch.detail#">
						<cfset result.errors = true>
						<cfset result.caught = cfcatch>
						<!--- <cfrethrow> --->
					</cfcatch>
				</cftry>
			</cfsavecontent>
			<cfset result.output = TRIM(result.output)>
			<cfcatch type="any">
				<cfif NOT result.errors>
					<cfset result.errors = true>
				</cfif>
			</cfcatch>
		</cftry>
		
		<cfreturn result>
	</cffunction>

	<cffunction name="ebx_write" hint="writes output to the page">
		<cfargument name="output" required="true" type="string" hint="the output to write">
		<cfoutput>#arguments.output#</cfoutput>
	</cffunction>
	
	<cffunction name="ebx_put" hint="sets variable in the page">
		<cfargument name="name"      type="string"  required="true" hint="variablename">
		<cfargument name="value"     type="any"     required="true" hint="value">
		<cfset SetVariable(arguments.name, arguments.value)>
	</cffunction>
	
	<cffunction name="ebx_get" hint="gets variable in the page">
		<cfargument name="name"      type="string"  required="true"  hint="variablename">
		<cfargument name="value"     type="any"     required="false" default="" hint="value if it doesn't exist">
		<cfif IsDefined(arguments.name)>
			<cfreturn GetVariable(arguments.name)>
		</cfif>
		<cfreturn arguments.value>
	</cffunction>
	
</cfcomponent>