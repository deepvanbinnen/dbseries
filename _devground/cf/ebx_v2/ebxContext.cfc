<cfcomponent extends="ebxContextResult" hint="I represent the parameters for an execution context">
	<cfset variables.type       = "">
	<cfset variables.template   = "">
	<cfset variables.attributes = StructNew()>
	<cfset variables.originals  = StructNew()>
	<cfset variables.contentvar = "">
	<cfset variables.append     = FALSE>
	<cfset variables.executed   = FALSE>
	<cfset variables.act        = "">
	<cfset variables.action    = "">
	<cfset variables.circuit    = "">
	<cfset variables.circuitdir = "">
	<cfset variables.rootPath   = "">
	<cfset variables.execDir    = "">
	<cfset variables.appPath    = "">
	
	<cffunction name="init">
		<cfargument name="type"       type="string"  required="true"  hint="contexttype">
		<cfargument name="action"     type="string"  required="false" default=""              hint="contexttype">
		<cfargument name="attributes" type="struct"  required="false" default="#StructNew()#" hint="custom attribute values">
		<cfargument name="originals"  type="struct"  required="false" default="#StructNew()#" hint="original attribute values">
		<cfargument name="contentvar" type="string"  required="false" default=""              hint="name of variable in which to store result output">
		<cfargument name="append"     type="boolean" required="false" default="false"         hint="flag that indicates appending the output of contentvar">
		<cfargument name="template"   type="string"  required="false" default=""              hint="full mapping path to include template for the context">
		<cfargument name="appPath"    type="string"  required="false" default=""              hint="full mapping path to include template for the context">
		
			<cfset StructAppend(variables, arguments, true)>
		<cfreturn this>
	</cffunction>
	
	<!--- Getters --->
	<cffunction name="get">
		<cfargument name="key" type="string" required="true">
		<cfif StructKeyExists(variables, arguments.key)>
			<cfreturn variables[arguments.key]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getType">
		<cfreturn variables.type>
	</cffunction>
	
	<cffunction name="getTemplate">
		<cfreturn variables.template>
	</cffunction>
	
	<cffunction name="getAppPath">
		<cfreturn variables.appPath>
	</cffunction>
	
	<cffunction name="getAttributes">
		<cfreturn variables.attributes>
	</cffunction>
	
	<cffunction name="getOriginals">
		<cfreturn variables.originals>
	</cffunction>
	
	<cffunction name="getContentVar">
		<cfreturn variables.contentvar>
	</cffunction>
	
	<cffunction name="getAppend">
		<cfreturn variables.append>
	</cffunction>
	
	<cffunction name="getCircuit">
		<cfreturn variables.circuit>
	</cffunction>
	
	<cffunction name="getAction">
		<cfreturn variables.action>
	</cffunction>
	
	<cffunction name="getAct">
		<cfreturn variables.act>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfreturn variables.circuitdir>
	</cffunction>
	
	<cffunction name="getRootPath">
		<cfreturn variables.rootPath>
	</cffunction>
	
	<cffunction name="getExecDir">
		<cfreturn variables.execdir>
	</cffunction>
	
	<cffunction name="isExecuted">
		<cfreturn variables.executed>
	</cffunction>
	
	<!--- Setters --->
	<cffunction name="setExecuted">
		<cfargument name="executed" type="boolean" required="false" default="true">
			<cfset variables.executed = arguments.executed>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setTemplate">
		<cfargument name="template" type="string" required="true">
		<cfset variables.template = arguments.template>				
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setType">
		<cfargument name="type" type="string" required="true">
		<cfset variables.type = arguments.type>				
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setContentVar">
		<cfargument name="contentvar" type="string" required="true">
		<cfset variables.contentvar = arguments.contentvar>				
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setAttributes">
		<cfargument name="attributes" type="struct" required="true">
		<cfset variables.attributes = arguments.attributes>		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setOriginals">
		<cfargument name="originals" type="struct" required="true">
		<cfset variables.originals = arguments.originals>		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setAppend">
		<cfargument name="append" type="boolean" required="true">
		<cfset variables.append = arguments.append>		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setCircuit">
		<cfargument name="circuit" type="string" required="true">
		<cfset variables.circuit = arguments.circuit>		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setAction">
		<cfargument name="action" type="string" required="true">
		<cfset variables.action = arguments.action>		
		<cfreturn this>
	</cffunction>

	<cffunction name="setAct">
		<cfargument name="act" type="string" required="true">
		<cfset variables.act = arguments.act>		
		<cfreturn this>
	</cffunction>

	<cffunction name="setCircuitDir">
		<cfargument name="circuitdir" type="string" required="true">
		<cfset variables.circuitdir = arguments.circuitdir>		
		<cfset setRootPath(RepeatString("../", ListLen(variables.circuitdir, "/")))>
		<!--- <cfset setExecDir()> --->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setAppPath">
		<cfargument name="appPath" type="string" required="true">
		<cfset variables.appPath = arguments.appPath>
		<!--- <cfset setExecDir()> --->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setRootPath">
		<cfargument name="rootPath" type="string" required="true">
		<cfset variables.rootPath = arguments.rootPath>		
		<cfreturn this>
	</cffunction>

	<cffunction name="setExecDir">
		<cfset variables.execdir = getAppPath() & getCircuitDir()>
		<cfreturn this>
	</cffunction>
	
	<!--- Type info --->
	<cffunction name="checkType">
		<cfargument name="type" required="true" type="string">
		<cfreturn getType() eq arguments.type>
	</cffunction>
	
	<cffunction name="hasType">
		<cfreturn NOT checkType("")>
	</cffunction>

	<cffunction name="_dump">
		<cfloop collection="#variables#" item="local.i">
			<cfif IsSimpleValue(variables[local.i])>
				<cfoutput>#local.i#: #variables[local.i]#<br /></cfoutput>
			<cfelseif local.i eq "attributes" OR local.i eq "originals">
				<cfoutput>#local.i#:<br /></cfoutput>
				<cfloop collection="#variables[local.i]#" item="local.j">
					<cfif IsSimpleValue(variables[local.i][local.j])>
						<cfoutput>#local.j#: #variables[local.i][local.j]#<br /></cfoutput>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cffunction>
</cfcomponent>
