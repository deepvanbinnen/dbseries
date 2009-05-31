<cfcomponent hint="I represent the parameters for an execution context">
	<!--- 
	= OnceAndOnlyOnce =
	
	"One of the main goals (if not the main goal) when ReFactoring code.
	Each and every declaration of behavior should appear OnceAndOnlyOnce"
	
	from http://c2.com/cgi/wiki?OnceAndOnlyOnce
	--->
	<cfset variables.pi         = "">
	<cfset variables.action     = "">
	<cfset variables.append     = FALSE>
	<cfset variables.attributes = StructNew()>
	<cfset variables.caught     = StructNew()>
	<cfset variables.contentvar = "">
	<cfset variables.errors     = FALSE>
	<cfset variables.executable = FALSE>
	<cfset variables.originals  = StructNew()>
	<cfset variables.output     = "">
	<cfset variables.request    = "">
	<cfset variables.result     = "">
	<cfset variables.template   = "">

	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
			<cfset variables.pi = arguments.ParserInterface>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="execute">
		<cfset setResult(variables.pi.include(getTemplate()))>
		<cfreturn hasErrors()>
	</cffunction>
	
	<cffunction name="getAction">
		<cfreturn variables.action>
	</cffunction>
	
	<cffunction name="getAppend">
		<cfreturn variables.append>
	</cffunction>
	
	<cffunction name="getAttributes">
		<cfreturn variables.attributes>
	</cffunction>
	
	<cffunction name="getCaught">
		<cfreturn variables.caught>
	</cffunction>
	
	<cffunction name="getContentVar">
		<cfreturn variables.contentvar>
	</cffunction>
	
	<cffunction name="getOriginals">
		<cfreturn variables.originals>
	</cffunction>
	
	<cffunction name="getOutput">
		<cfreturn variables.output>
	</cffunction>
	
	<cffunction name="getRequest">
		<cfreturn variables.request>
	</cffunction>

	<cffunction name="getResult">
		<cfreturn variables.result>
	</cffunction>
	
	<cffunction name="getTemplate">
		<cfreturn variables.template>
	</cffunction>
	
	<cffunction name="hasErrors">
		<cfreturn variables.errors>
	</cffunction>
	
	<cffunction name="isExecutable">
		<cfreturn variables.executable>
	</cffunction>
	
	<cffunction name="setAction">
		<cfargument name="action" type="string" required="true">
		<cfset variables.action = arguments.action>
		<cfset setRequest(createObject("component", "ebxRequest").init(variables.pi, getAction(), getAttributes()))>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setAppend">
		<cfargument name="append" type="boolean" required="true">
		<cfset variables.append = arguments.append>				
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setAttributes">
		<cfargument name="attributes" type="struct" required="true">
		<cfset variables.attributes = arguments.attributes>
		<cfset storeOriginals()>		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setCaught">
		<cfargument name="caught" type="any" required="true">
		<cfset variables.caught = arguments.caught>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setContentVar">
		<cfargument name="contentvar" type="string" required="true">
		<cfset variables.contentvar = arguments.contentvar>				
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setErrors">
		<cfargument name="errors" type="boolean" required="true">
		<cfset variables.errors = arguments.errors>				
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setExecutable">
		<cfargument name="executable" type="boolean" required="true">
		<cfset variables.executable = arguments.executable>				
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setOutput">
		<cfargument name="output" type="string" required="true">
		<cfset variables.output = arguments.output>				
		<cfreturn true>
	</cffunction>

	<cffunction name="setOriginals">
		<cfargument name="originals" type="struct" required="true">
		<cfset variables.originals = arguments.originals>				
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setRequest">
		<cfargument name="request" type="ebxRequest" required="true">
		<cfset variables.request = arguments.request>
		<cfset setExecutable(variables.request.isExecutable())>
		<cfreturn isExecutable()>
	</cffunction>
	
	<cffunction name="setResult" hint="set the result from an include">
		<cfargument name="result" type="struct" required="true">
		<cfset variables.result = arguments.result>
		<cfset setCaught(variables.result.caught)>
		<cfset setErrors(variables.result.errors)>
		<cfif NOT hasErrors()>
			<cfset setOutput(variables.result.output)>
		</cfif>		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setTemplate">
		<cfargument name="Template" type="string" required="true">
		<cfset variables.template = arguments.template>				
		<cfreturn true>
	</cffunction>
	
	<cffunction name="storeOriginals" returntype="boolean" hint="stores current attribute values only if they already exist">
		<cfset var local = StructNew()>
		<cfset local.attr = variables.pi.getAttributes()>
		<cfset local.curr = getAttributes()>
		<cfset local.copy = StructNew()>
		
		<cfloop collection="#local.curr#" item="local.param">
			<cfif variables.pi.hasAttribute(local.param)>
				<cfset StructInsert(local.copy, local.param, variables.pi.getAttribute(local.param), TRUE)>
			</cfif>
		</cfloop>
		<cfreturn setOriginals(local.copy)>
	</cffunction>
	
	<cffunction name="_dump">
		<cfset var local = StructNew()>
		<cfset local.struct = StructNew()>
		<cfloop list="action,append,attributes,contentvar,originals,request,result,template" index="local.item">
			<cftry>
				<cfset StructInsert(local.struct, local.item, variables[local.item])>
				<cfcatch type="any">
					<cfdump var="#cfcatch#">
				</cfcatch>
						
			</cftry>
		</cfloop>
		<cfreturn local.struct>
	</cffunction>
	
	
	
	
	
</cfcomponent>
