<!--- 
Copyright 2009 Bharat Deepak Bhikharie

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

<!--- 
Filename: ebxPageContext.cfc
Date: Mon Jun 15 00:10:04 CEST 2009
Author: Bharat Deepak Bhikharie
Project info: http://code.google.com/p/dbseries/wiki/ebx
--->

<cfcomponent displayname="ebxPageContext" hint="I handle inclusion of templates and retrieve or assign variables">
	<cffunction name="ebx_include" returntype="struct" hint="include template in the page">
		<cfargument name="template" required="true" type="string" hint="full mapping path to the include file">
		
		<cfset var local = StructNew()>
		<cfset local.template = arguments.template>
		<cfset local.output   = "">
		<cfset local.errors   = false>
		<cfset local.caught   = "">
		
		<cftry>
			<cfsavecontent variable="local.output">
				<cftry>
					<cfinclude template="#local.template#">
					<cfoutput><!-- DEBUG: #arguments.template# --></cfoutput>
					<cfcatch type="any">
						<cfoutput><p>#cfcatch.message#<br />#cfcatch.detail#</p></cfoutput>
						<cfset local.errors = true>
						<cfset local.caught = cfcatch>
						<!--- <cfrethrow> --->
					</cfcatch>
				</cftry>
			</cfsavecontent>
			<cfset local.output = TRIM(local.output)>
			<cfcatch type="any">
				<cfif NOT local.errors>
					<cfset local.errors = true>
				</cfif>
			</cfcatch>
		</cftry>
		
		<cfreturn local>
	</cffunction>

	<cffunction name="ebx_write" returntype="ebxPageContext" hint="write output to the page">
		<cfargument name="output" required="true" type="string" hint="the output to write">
			
			<cfset writeOutput(arguments.output)>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="ebx_put" returntype="ebxPageContext" hint="set variable in the page">
		<cfargument name="name"      type="string"  required="true" hint="variable name">
		<cfargument name="value"     type="any"     required="true" hint="variable value">
			
			<cfset SetVariable(arguments.name, arguments.value)>
			
		<cfreturn this>
	</cffunction>
	
	<cffunction name="ebx_get" returntype="any" hint="get variable in the page">
		<cfargument name="name"      type="string"  required="true"  hint="variable name">
		<cfargument name="value"     type="any"     required="false" default="" hint="value if variable isn't defined. Does not actually set the variable!">
	
		<cfif IsDefined(arguments.name)>
			<cfif IsDefined("GetVariable")>
				<!--- OpenBD 1.1 --->
				<cfreturn GetVariable(arguments.name)>
			<cfelse>
				<cfreturn Evaluate(arguments.name)>
			</cfif>
		</cfif>
		
		<cfreturn arguments.value>
	</cffunction>
</cfcomponent>