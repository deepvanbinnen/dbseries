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
Filename: ebx.cfc
Date: Mon Jun 15 00:10:04 CEST 2009
Author: Bharat Deepak Bhikharie
Project info: http://code.google.com/p/dbseries/wiki/ebx
--->

<cfcomponent extends="PropertyInterface" output="false" displayname="ebx" hint="I define and keep settingparameters and can generate a parser.">
	<!--- global flag --->
	<cfset variables.initialised = FALSE>
	<!--- declare parameters --->
	<cfset variables.parameters       = createObject("component", "ebxParameters").init(this)>
	<!--- Used when action has 3 dots
	Define a map of "internal circuit" to "public parser variable" (e.g request.ebx.appPath,..) 
	that contain the current execution directory.
	--->
	<cfset variables.internal = StructNew()>
	<cfset variables.internal.settings = "configdir">
	<cfset variables.internal.layouts  = "configdir">
	<cfset variables.internal.plugins  = "configdir">
	
	<cfset variables.internal.include  = "circuitdir">
	<cfset variables.internal.layout   = "layoutdir">
	
	<cffunction name="init" returntype="ebx" hint="reads and sets all parameters from arguments" >
		<cfargument name="appPath"      required="true"  type="string"  default="" hint="coldfusion mapping to the root of the box">
		<cfargument name="defaultact"   required="false" type="string"  default="" hint="default action to excute if non is specified">
		<cfargument name="actionvar"    required="false" type="string"  default="act" hint="variable name that has the main action to execute">
		<cfargument name="circuitsfile" required="false" type="string"  default="ebx_circuits.cfm" hint="maps to the file that contains circuit settings">
		<cfargument name="pluginsfile"  required="false" type="string"  default="ebx_plugins.cfm" hint="maps to the file that contains plugin settings">
		<cfargument name="layoutsfile"  required="false" type="string"  default="ebx_layouts.cfm" hint="maps to the file that contains layout settings">
		<cfargument name="settingsfile" required="false" type="string"  default="ebx_settings.cfm" hint="maps to the file that contains global settings">
		<cfargument name="switchfile"   required="false" type="string"  default="ebx_switch.cfm" hint="maps to the file that contains global settings">
		<cfargument name="circuits"     required="false" type="struct"  default="#StructNew()#"    hint="ebox circuits">
		<cfargument name="plugins"      required="false" type="struct"  default="#StructNew()#"    hint="ebox circuits">
		<cfargument name="layouts"      required="false" type="struct"  default="#StructNew()#"    hint="ebox circuits">
		<cfargument name="forms2attrib" required="false" type="boolean" default="true" hint="convert formvariables to attributes">
		<cfargument name="url2attrib"   required="false" type="boolean" default="true" hint="convert urlvariables to attributes">
		<cfargument name="precedence"   required="false" type="string"  default="form" hint="if form and url variables are converted to attributes, which takes precedence?">
		<cfargument name="debuglevel"   required="false" type="numeric" default="0" hint="error level for debugmessages">
		
			<cfset setParameters(arguments, true)>
			<!--- TO DO: create methods to add, remove and update circuits
			If you have an 'old' version of ebx, you should call setup from the requesting page 
			to finalise the setup. This only works if your instance variable is in a scope accesible by the cfc
			
		    TO DO: find an intelligent way to load ebx_circuits file; 
			--->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAppPath" returntype="string" hint="return the application mapping path">
		<cfreturn getProperty("appPath")>
	</cffunction>
	
	<cffunction name="getCircuits" returntype="struct" hint="return the circuits from the settings">
		<cfreturn getParameter("circuits", StructNew())>
	</cffunction>
	
	<cffunction name="setCircuits" returntype="any" hint="set circuits from struct return instance">
		<cfargument name="circuits" required="true" type="struct" hint="struct containing circuit to directory mappings">
		<cfreturn setParameter("circuits", arguments.circuits)>
	</cffunction>
	
	<cffunction name="getCircuit"  returntype="string" hint="return the circuit directory from given circuit">
		<cfargument name="circuit" required="true" type="string" hint="circuit to get directory for">
		<cfset var local = StructNew()>
		
		<cfif hasCircuit(arguments.circuit)>
			<!--- We need this extra step --->
			<cfset local.circuits = getCircuits()>
			<cfreturn local.circuits[arguments.circuit]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="hasCircuit" returntype="boolean" hint="validates a circuit by name">
		<cfargument name="name"   required="true" type="string" hint="circuit to validate">
		<cfreturn StructKeyExists(getParameter("circuits"), arguments.name)>
	</cffunction>
	
	<cffunction name="addCircuit"  returntype="boolean" hint="return true if adding circuit succeeds">
		<cfargument name="circuit" required="true" type="string" hint="circuit to add">
		<cfargument name="path"    required="true" type="string" hint="circuit path">
		
		<cfset var local = StructNew()>
		
		<cfif NOT hasCircuit(arguments.circuit)>
			<cfset StructInsert(getParameter("circuits"), arguments.circuit, arguments.path)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	
	<cffunction name="getInternal"  returntype="string" hint="return the directory from given internal circuit">
		<cfargument name="internal" required="true" type="string" hint="internal circuit to get directory for">
		<cfif hasInternal(arguments.internal)>
			<cfreturn variables.internal[arguments.internal]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="hasInternal"  returntype="boolean" hint="validates an internal circuit">
		<cfargument name="internal" required="true" type="string"  hint="internal circuit to validate">
		<cfreturn StructKeyExists(variables.internal, arguments.internal)>
	</cffunction>
	
	<cffunction name="getParser" returntype="ebxParser" hint="return a new instantiated parser">
		<cfargument name="attributes" required="false" type="struct"  default="#StructNew()#" hint="attributes to use in the parser">
		<cfargument name="scopecopy"  required="false" type="string"  default="url,form"      hint="list of scopes to copy to attributes">
		<cfargument name="nosettings" required="false" type="boolean" default="false"         hint="do not parse settingsfile">
		<cfargument name="nolayout"   required="false" type="boolean" default="false"         hint="do not parse layout">
		
		<cfreturn createObject("component", "ebxParser").init(this, arguments.attributes, arguments.scopecopy, arguments.nosettings, arguments.nolayout)>
	</cffunction>
	
	<cffunction name="getParameter" returntype="any" hint="get a parameter by name otherwise return default value">
		<cfargument name="name"     required="true"  type="string" hint="name of the parameter">
		<cfargument name="default"  required="false" type="any"    default="" hint="default value if parameter does not exist">
		<cfreturn variables.parameters.getParameter(arguments.name, arguments.default)>
	</cffunction>
	
	<cffunction name="setParameter"  returntype="ebx" hint="set a parameter and its public scope variant">
		<cfargument name="name"      required="true" type="string"  hint="name of the parameter">
		<cfargument name="value"     required="true" type="any"     default="" hint="value for the parameter">
		<cfargument name="overwrite" required="true" type="boolean" default="false" hint="by default does not overwrite existing parameters">
		
		<cfset variables.parameters.setParameter(arguments.name, arguments.value, arguments.overwrite)>
		<cfset setProperty(arguments.name, arguments.value, true, arguments.overwrite)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getParameters" returntype="struct" hint="get all parameters">
		<cfreturn variables.parameters.getParameters()>
	</cffunction>
	
	<cffunction name="setParameters" returntype="ebx" hint="set all parameters, but does not remove existing parameters">
		<cfargument name="parameters" required="true" type="struct"  hint="new parameter values">
		<cfargument name="overwrite"  required="true" type="boolean" default="false" hint="by default does not overwrite existing parameters">
		
		<cfset variables.parameters.setParameters(arguments.parameters, arguments.overwrite)>
		<cfset setProperties(arguments.parameters, true, arguments.overwrite)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setup" returntype="ebx" hint="include the circuitsfile and pluginsfile to set the circuits and plugins">
		<cfargument name="parsecircuitfile" required="false" type="boolean" default="true" hint="parse circuitsfile?">
		<cfargument name="parsepluginsfile" required="false" type="boolean" default="true" hint="parse pluginsfile?">
		
		<cfset var result = StructNew()>
		<cfset result.pagecontext = createObject("component", "ebxPageContext")>
		<cfif arguments.parsecircuitfile>
			<cfset result.output = result.pagecontext.ebx_include(getAppPath() & getParameter("circuitsfile"))>
			<cfif NOT result.output.errors>
				<cfset setParameter("circuits", this.circuits, true)>
			<cfelse>
				<cfdump var="#result.cfcatch#">	
			</cfif>
		</cfif>
		<cfif arguments.parsepluginsfile>
			<cfset result.output = result.pagecontext.ebx_include(getAppPath() & getParameter("pluginsfile"))>
			<cfif NOT result.output.errors>
				<cfset setParameter("plugins", this.plugins, true)>
			<cfelse>
				<cfdump var="#result.cfcatch#">	
			</cfif>
		</cfif>
		<cfset this.state = "ready">
		<cfreturn this>
	</cffunction>
	
</cfcomponent>