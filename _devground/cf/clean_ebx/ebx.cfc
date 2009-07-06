<cfcomponent hint="ebx" extends="ebxFactory">
	<cfset variables.mapping = "dbseries.trunk.ebx.cfc.clean">
	<cfset super.init(mapping=variables.mapping)>
	
	<cffunction name="init">
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
		
		<cfset variables.parameters = create("ebxParameters", "init", arguments)>

		<cfset variables.circuits   = create("ebxCircuits")>
		<cfset addCircuits(arguments.circuits)>
		
		<cfset variables.plugins    = create("ebxPlugins")>
		<cfset addPlugins(arguments.plugins)>
		
		<cfset variables.layouts    = create("ebxLayouts", "init",  args(contentType="text/html"))>
		<cfset addLayouts(arguments.layouts)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getParser">
		<cfreturn create("ebxParser", "init", args(ebx=this))>
	</cffunction>
	
	<!--- Circuits --->
	<cffunction name="addCircuit">
		<cfargument name="circuit" type="string" required="true">
		<cfargument name="path"    type="string" required="true">
		
		<cfset variables.circuits.add(arguments.circuit, arguments.path)>
		<cfset updateCircuits()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addCircuits">
		<cfargument name="circuits" type="struct" required="true">
		
		<cfset variables.circuits.addAll(arguments.circuits)>
		<cfset updateCircuits()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getCircuit">
		<cfargument name="circuit" type="string" required="true">
		<cfreturn variables.circuits.get(arguments.circuit).data>
	</cffunction>
	
	<cffunction name="getCircuits">
		<cfreturn variables.circuits.getAll()>
	</cffunction>
	
	<!--- Plugins --->
	<cffunction name="addPlugin">
		<cfargument name="plugin" type="string" required="true">
		<cfargument name="path"    type="string" required="true">
		
		<cfset variables.plugins.add(arguments.plugin, arguments.path)>
		<cfset updatePlugins()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addPlugins">
		<cfargument name="plugins" type="struct" required="true">
		
		<cfset variables.plugins.addAll(arguments.plugins)>
		<cfset updatePlugins()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPlugin">
		<cfargument name="plugin" type="string" required="true">
		
		<cfreturn variables.plugins.get(arguments.plugin)>
	</cffunction>
	
	<cffunction name="getPlugins">
		<cfreturn variables.plugins.getAll()>
	</cffunction>
	
	<!--- Layouts --->
	<cffunction name="addLayout">
		<cfargument name="layout" type="string" required="true">
		<cfargument name="path"    type="string" required="true">
		
		<cfset variables.layouts.add(arguments.layout, arguments.path)>
		<cfset updateLayouts()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addLayouts">
		<cfargument name="layouts" type="struct" required="true">
		
		<cfset variables.layouts.addAll(arguments.layouts)>
		<cfset updateLayouts()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getLayout">
		<cfargument name="layout" type="string" required="true">
		
		<cfreturn variables.layouts.get(arguments.layout)>
	</cffunction>
	
	<cffunction name="getLayouts">
		<cfreturn variables.layouts.getAll()>
	</cffunction>
	
	<!--- Parameters --->
	<cffunction name="addParameter">
		<cfargument name="parameter" type="string" required="true">
		<cfargument name="data"      type="any" required="true">
		
		<cfreturn variables.parameters.setParameter(arguments.parameter, arguments.data)>
	</cffunction>
	
	<cffunction name="addParameters">
		<cfargument name="parameters" type="struct" required="true">
		<cfreturn variables.parameters.setParameters(arguments.parameters)>
	</cffunction>
	
	<cffunction name="getParameter">
		<cfargument name="parameter" type="string" required="true">
		<cfargument name="value"  required="false" type="any"     default=""      hint="parameter's default value " >
		
		<cfreturn variables.parameters.getParameter(arguments.parameter, arguments.value)>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn variables.parameters.getParameters()>
	</cffunction>
	
	<cffunction name="setParameter" returntype="any" hint="sets parameters from struct and return instance">
		<cfargument name="parameter" required="true"  type="string"  hint="parameter values">
		<cfargument name="value"     required="true" type="any"     default=""      hint="parameter's default value " >
		<cfargument name="overwrite" required="false" type="boolean" default="false" hint="overwrite existing parameters?">
		
		<cfset variables.parameters.setParameter(name=arguments.parameter, value=arguments.value, overwrite=arguments.overwrite)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="updateParameter" returntype="any" hint="sets parameters from struct and return instance">
		<cfargument name="parameter" required="true"  type="string"  hint="parameter values">
		<cfargument name="value"     required="true" type="any"     default=""      hint="parameter's default value " >
		
		<cfset setParameter(arguments.parameter, arguments.value, true)>
		
		<cfreturn this>
	</cffunction>
	
	<!--- Helpers --->
	<cffunction name="args">
		<cfreturn arguments>
	</cffunction>
	
	<cffunction name="updateCircuits">
		<cfset updateParameter("circuits", getCircuits())>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="updatePlugins">
		<cfset updateParameter("plugins", getPlugins())>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="updateLayouts">
		<cfset updateParameter("layouts", getLayouts())>
		<cfreturn this>
	</cffunction>
	
	
</cfcomponent>