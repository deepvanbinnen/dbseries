<cfcomponent displayname="ebxPageContext" hint="I provide an interface for the java pagecontext object and handle inclusion of templates/assignment of variables">
	<cfset variables.ebx  = "">
	<cfset variables.pc   = "">
	<cfset variables.output  = "">
	
	<cffunction name="init">
		<cfargument name="ebx" type="any" required="true" hint="Main ebx instance">
		<cfargument name="pageContext" type="any" required="true" hint="Pagecontext object for the HTTP-request">
		
		<cfset variables.ebx = arguments.ebx>
		<cfset variables.pc  = arguments.pageContext>
		
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="ebxAssign" method="package">
		<cfargument name="name"      type="string"  required="true" hint="variablename">
		<cfargument name="value"     type="any"     required="true" hint="value">
		<cfargument name="overwrite" type="boolean" required="true" default="false">
		<cfargument name="append"    type="boolean" required="true" default="false">
		
		<cfset var local = StructNew()>
		<cftry>
			<cfif IsDefined(arguments.name)>
				<cfset variables.ebx.setDebug("Variable exists '#arguments.name#'", 0)>
				<cfset local.variable = getVariable(arguments.name)>
				<cfif NOT arguments.overwrite>
					<cfset variables.ebx.setDebug("Overwriting allowed for: '#arguments.name#'", 0)>
					<cfif arguments.append>
						<cfset variables.ebx.setDebug("Append detected #IsSimpleValue(local.variable)#", 0)>
						<cfif IsSimpleValue(local.variable)>
							<cfset local.newvalue = local.variable & arguments.value>
							<cfset SetVariable(arguments.name, local.newvalue)>
							<cfset variables.ebx.setDebug("Overwriting variable '#arguments.name#' with: #local.newvalue#", 0)>
						<cfelseif IsArray(local.variable)>
							<cfset SetVariable(arguments.name, ArrayAppend(local.variable,arguments.value))>
							<cfset variables.ebx.setDebug("Appending array variable '#arguments.name#'", 0)>
						</cfif>
					</cfif>
					<cfreturn false>
				</cfif>
			</cfif>
			<cfset variables.ebx.setDebug("Setting variable '#arguments.name#' to #arguments.value#", 0)>
			<cfset SetVariable(arguments.name, arguments.value)>
			<cfcatch type="any">
				<cfset variables.ebx.setDebug("Fatal error while assigning", 0)>
				<cfset variables.ebx.setFatalError(cfcatch)>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="ebxFetch" method="package">
		<cfargument name="name"      type="string"  required="true" hint="variablename">
		<cfargument name="value"     type="any"     required="true" hint="value">
		<cfif IsDefined(arguments.name)>
			<cfreturn getVariable(arguments.name)>
		</cfif>
		<cfreturn arguments.value>
	</cffunction>
	
	<cffunction name="ebxInclude" method="package">
		<cfargument name="template" type="string" hint="full mapping path to include template">
		
		<cfset var local = StructNew()>
		<cfset local.output = "">
		
		<cftry>
			<cfset variables.ebx.setDebug("Including: #arguments.template#", 0)>
			<cfset local.output = include(template, "")>
			
			<cfcatch type="any">
				<cfset local.output = "#cfcatch.tagname#: #cfcatch.template# at line #cfcatch.line# #cfcatch.message# - #cfcatch.detail#<br />#arguments.template#">
				<cfset variables.ebx.setDebug(local.output)>
				<cfset variables.ebx.setFatalError(cfcatch)>
			</cfcatch>
		</cftry>

		<cfreturn local.output>
	</cffunction>

	<cffunction name="_dumpPC" method="package">
		<!--- <cfset var Page = getPageContext().getPage()>
		<cfoutput><cfdump var="#Page#"></cfoutput> --->
		<cfreturn variables.ebx.pc>
	</cffunction>
	
	<cffunction name="include" method="package">
		<cfargument name="template" type="string" hint="include template">
		<cfargument name="pathto"   type="string" hint="path to include template" default="#variables.ebx.getCurrentDir()#">
		<cfargument name="flush"    type="boolean" hint="don't catch output" default="false">
		<cfargument name="pc"    required="false" hint="don't catch output" default="#variables.pc#">
		
		<cfset var local = StructNew()>
		<cfset local.output = "">
		<cfset variables.ebx.setDebug(arguments.pc, 0)>
		
		<cfif arguments.pc eq "">
			<cfset variables.ebx.setDebug("Empty pagecontext... reverting to those of variables", 0)>
			<cfset arguments.pc = variables.pc>
		<cfelse>
			<cfset variables.ebx.setDebug("Got pagecontext #arguments.template#", 0)>
		</cfif>
		<!--- <cfset variables.pc.getResponse().setContentType("text/html")> --->
		<cftry>
			<cfset variables.ebx.setDebug("Start processing: #arguments.pathto & arguments.template#", 1)>
			<cfset local.it = arguments.pc.getRequest().getParameterNames()>
			<!--- <cfloop condition="#local.it.hasMoreElements()#">
				<cfset local.p = arguments.pc.getRequest().getParameter(local.it.nextElement())>
				<cfdump var="#local.p#">
			</cfloop>
			 --->
			<cfset local.x = arguments.pc.include(pathto & arguments.template)>
			
			<cfset local.p = arguments.pc.getResponse()>
			
			<!--- <cfset local.it = arguments.pc.getRequest().getLocales()>
			<cfloop condition="#local.it.hasMoreElements()#">
				<cfdump var="#local.it.nextElement()#">
			</cfloop> --->
			
			<cfdump var="#arguments.pc.getOut()#">
			
			<cfdump var="#arguments.pc.getOut().flush()#">
			
			<cfdump var="#arguments.pc.getRequest()#">
			
			
			<!--- <cfdump var="#local.p.getResponse().finish()#"> --->
			<cfdump var="#local.p.getResponse().getClass().getName()#">
			<cfdump var="#arguments.pc.getRequest().getLocalName()#">
			REQ: <cfdump var="#local.p.getResponse().getOutputStream()#">aaa
			
			
			<cfset variables.ebx.setDebug("Output for #arguments.pathto & arguments.template#: " & arguments.pc.getOut().getString())>
			<cfcatch type="any">
				<cfset local.output = arguments.pc.getOut().getString()>
				<cfset variables.ebx.setDebug("Caught an error processing: #arguments.pathto & arguments.template#", 0)>
				<cfset variables.ebx.setDebug( cfcatch.toString(), 0)>
				<!--- <cfset variables.pc.getOut().clearBuffer()> --->
				<!--- <cfset local.output = cfcatch.toString()> --->
			</cfcatch>
		</cftry>
		<cftry>
			<cfif NOT arguments.flush>
				<cfset local.output = arguments.pc.getOut().getString()>
				<cfset arguments.pc.getOut().clearBuffer()>
			<cfelse>
				<cfset variables.ebx.setDebug( "Flushing output", 0)>
			</cfif>
			
			<cfcatch type="any">
				<cfset local.output = cfcatch.toString()>
				<cfset arguments.pc.getOut().clearBuffer()>
			</cfcatch>
		</cftry>
		<cfreturn local.output>
	</cffunction>
	
	<cffunction name="currentOut" method="package">
		<cfreturn variables.pc.getOut().getString()>
	</cffunction>
	
	<cffunction name="getPC" method="package">
		<cfreturn variables.pc>
	</cffunction>
	
	<cffunction name="printnull" method="package">
		<cfargument name="output" type="string" hint="include template">
		<cfargument name="pc" type="any" hint="include template" required="false" default="#variables.pc#">
		
		<cfif arguments.pc eq "">
			<cfset variables.ebx.setDebug("Empty pagecontext... reverting to those of variables", 0)>
			<cfset arguments.pc = variables.pc>
		<cfelse>
			<cfset variables.ebx.setDebug("Got pagecontext for output: #arguments.output#", 0)>
		</cfif>
		
		<!--- <cfset arguments.pc.getOut().print(arguments.output)> --->
		<cfset arguments.pc.getOut().flush()>
	</cffunction>
	
	<cffunction name="print" method="package">
		<cfargument name="output" type="string" hint="include template">
		<cfset variables.pc.getOut().print(arguments.output)>
		<cfset variables.pc.getOut().flush()>
	</cffunction>
	
	<cffunction name="flush" method="package">
		<cfargument name="pc" type="any" hint="include template" required="false" default="#variables.pc#">
		<cfif arguments.pc eq "">
			<cfset variables.ebx.setDebug("Empty pagecontext... reverting to those of variables", 0)>
			<cfset arguments.pc = variables.pc>
		<cfelse>
			<cfset variables.ebx.setDebug("Got pagecontext #arguments.template#", 0)>
		</cfif>
		<cfset arguments.pc.getOut().flush()>
	</cffunction>
	
</cfcomponent>