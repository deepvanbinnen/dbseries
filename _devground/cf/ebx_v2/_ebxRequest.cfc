<cfcomponent displayname="ebxRequest" hint="I am the main ebx request and handle the execution of the default/given fuseaction">
	<cfset variables.pi     = "">
		
	<cfset variables.act        = "">
	<cfset variables.fullact    = "">
	<cfset variables.circuit    = "">
	<cfset variables.circuitdir = "">
	<cfset variables.rootPath   = "">
	<cfset variables.execDir    = "">
	
	<cfset variables.executable  = false>

	
	<cffunction name="init">
		<cfargument name="ParserInterface" required="true" type="ebxParserInterface">
		<cfargument name="action"     required="true" type="string">
			<cfset variables.pi = arguments.ParserInterface>
			<cfset parseAction(arguments.action)>
		<cfreturn this>
	</cffunction>	
	
	<cffunction name="get">
		<cfargument name="property" type="string" required="true">
		<cfif StructKeyExists(variables, property)>
			<cfreturn variables[property]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getAct">
		<cfreturn variables.act>
	</cffunction>
	
	<cffunction name="getAction">
		<cfreturn variables.fullact>
	</cffunction>
	
	<cffunction name="getAttributes">
		<cfreturn variables.parameters>
	</cffunction>

	<cffunction name="getCircuit">
		<cfreturn variables.circuit>
	</cffunction>
	
	<cffunction name="getCircuitDir">
		<cfreturn variables.circuitdir>
	</cffunction>
	
	<cffunction name="getExecDir">
		<cfreturn variables.execdir>
	</cffunction>
	
	<cffunction name="getOutput">
		<cfreturn variables.output>
	</cffunction>
	
	<cffunction name="getRootPath">
		<cfreturn variables.rootPath>
	</cffunction>
	
	<cffunction name="isExecutable">
		<cfreturn variables.executable>
	</cffunction>
	
	<cffunction name="isValidCircuit">
		<cfreturn variables.pi.hasCircuit(getCircuit())>
	</cffunction>
	
	<cffunction name="parseAction">
		<cfargument name="action" type="string" required="true">
		
		<cfset var local = StructNew()>
		<cfset setAction(arguments.action)>
		<cfif ListLen(getAction(), ".") eq 2>
			<cfset setAct(ListLast(getAction(), "."))>
			<cfset setCircuit(ListFirst(getAction(), "."))>
			<cfif isValidCircuit()>
				<cfset parseCircuit()>
				<cfset setExecutable(true)>
			</cfif>
		<cfelse>
			<cfset setExecutable(false)>
		</cfif>
	</cffunction>
	
	<cffunction name="parseCircuit">
		<cfset variables.circuitdir = variables.pi.getCircuitDir(variables.circuit)> 
		<cfset variables.execdir    = variables.pi.getAppPath() & getCircuitDir()>
		<cfset variables.rootPath   = RepeatString("../", ListLen(getCircuitDir(), "/"))>
	</cffunction>
	
	<cffunction name="setAct">
		<cfargument name="act" type="string" required="true">
		<cfset variables.act = arguments.act>
	</cffunction>
	
	<cffunction name="setAction">
		<cfargument name="action" type="string" required="true">
		<cfset variables.fullact = arguments.action>
	</cffunction>

	<cffunction name="setCircuit">
		<cfargument name="circuit" type="string" required="true">
		<cfset variables.circuit = arguments.circuit>
	</cffunction>
	
	<cffunction name="setExecutable">
		<cfargument name="flag" type="boolean" required="true">
		<cfset variables.executable = arguments.flag>
		<cfreturn isExecutable()>
	</cffunction>
	
	<cffunction name="setOutput">
		<cfargument name="output" type="string" required="true">
		<cfset variables.output = arguments.output>
	</cffunction>
	
	<cffunction name="setAttributes">
		<cfargument name="attributes" type="struct" required="false" default="#StructNew()#">
		<cfset variables.attributes = arguments.attributes>
	</cffunction>

	<cffunction name="_dump">
		<cfloop collection="#variables#" item="local.i">
			<cfif IsSimpleValue(variables[local.i])>
				<cfoutput>#local.i#: #variables[local.i]#<br /></cfoutput>
			</cfif>
		</cfloop>
	</cffunction>
</cfcomponent>