<cfcomponent>
	<cfset variables.output = "">
	<cfset variables.caught = StructNew()>
	<cfset variables.errors = false>

	<cffunction name="getResult" returntype="struct">
		<cfset var local = StructNew()>
		
		<cfset StructInsert(local, "output", getOutput())>
		<cfset StructInsert(local, "errors", getErrors())>
		<cfset StructInsert(local, "caught", getCaught())>
		
		<cfreturn local>
	</cffunction>

	<cffunction name="setResult" returntype="ebxContextResult">
		<cfargument name="result" type="struct"  required="true">
		
		<cfif StructKeyExists(arguments.result, "output")>
			<cfset setOutput(arguments.result.output)>
		</cfif>
		
		<cfif StructKeyExists(arguments.result, "errors")>
			<cfset setErrors(arguments.result.errors)>
		</cfif>
		
		<cfif StructKeyExists(arguments.result, "caught")>
			<cfset setCaught(arguments.result.caught)>
		</cfif>
	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getOutput" returntype="string">
		<cfreturn variables.output>
	</cffunction>
	
	<cffunction name="getCaught" returntype="any">
		<cfreturn variables.caught>
	</cffunction>
	
	<cffunction name="getErrors" returntype="string">
		<cfreturn variables.errors>
	</cffunction>
	
	<cffunction name="hasErrors" returntype="string">
		<cfreturn getErrors()>
	</cffunction>

	<cffunction name="setOutput" returntype="any">
		<cfargument name="output" type="string" required="true">
			<cfset variables.output = arguments.output>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setCaught" returntype="any">
		<cfargument name="caught" type="any" required="true">
			<cfset variables.caught = arguments.caught>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setErrors" returntype="any">
		<cfargument name="errors" type="boolean" required="true">
			<cfset variables.errors = arguments.errors>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>