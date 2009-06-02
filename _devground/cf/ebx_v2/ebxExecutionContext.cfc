<cfcomponent hint="I represent the parameters for an execution context">
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
	<cfset variables.type       = "">

	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
		<cfargument name="type" type="string" required="false" default="" hint="contexttype">
			<cfset variables.pi     = arguments.ParserInterface>
			<cfset setType(arguments.type)>
		<cfreturn this>
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
	
	<cffunction name="getType">
		<cfreturn variables.type>
	</cffunction>
	
	<cffunction name="hasErrors">
		<cfreturn variables.errors>
	</cffunction>
	
	<cffunction name="hasType">
		<cfreturn getType() neq "">
	</cffunction>
	
	<cffunction name="isExecutable">
		<cfreturn variables.executable>
	</cffunction>
	
	<cffunction name="isInclude">
		<cfreturn getType() eq "include">
	</cffunction>
	
	<cffunction name="isEmptyRequest">
		<cfreturn getType() eq "" OR getType() eq "empty">
	</cffunction>
	
	<cffunction name="isRequest">
		<cfreturn getType() eq "request" OR isMainRequest()>
	</cffunction>
	
	<cffunction name="isMainRequest">
		<cfreturn getType() eq "mainrequest">
	</cffunction>
	
	<cffunction name="parseRequest">
		<cfif getAction() neq "">
			<cfset setRequest(createObject("component", "ebxRequest").init(variables.pi, getAction(), getAttributes()))>
		</cfif>
	</cffunction>
	
	<cffunction name="setAction">
		<cfargument name="action" type="string" required="true">
		<cfargument name="parse"  type="boolean" required="false" default="true">
		<cfset variables.action = arguments.action>
		<cfif arguments.parse>
			<cfset parseRequest()>
		</cfif>
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
		<cfset setOutput(variables.result.output)>
		<!--- <cfif NOT hasErrors()>
			<cfset setOutput(variables.result.output)>
		</cfif>		 --->
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setTemplate">
		<cfargument name="template" type="string" required="true">
		<cfset variables.template = arguments.template>				
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setType">
		<cfargument name="type" type="string" required="true">
		<cfset variables.type = arguments.type>
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
		<cfloop list="action,append,attributes,contentvar,originals,request,result,template,type" index="local.item">
			<cftry>
				<cfset StructInsert(local.struct, local.item, variables[local.item])>
				<cfcatch type="any">
					<cfdump var="#cfcatch#">
				</cfcatch>
						
			</cftry>
		</cfloop>
		<cfreturn local.struct>
	</cffunction>
	
	
	<cffunction name="_qdump">
		<cfoutput>#getType()# : #getTemplate()# / #getAction()# :<hr /> #getOutput()#<hr /></cfoutput>
	</cffunction>
	
	
	
</cfcomponent>
