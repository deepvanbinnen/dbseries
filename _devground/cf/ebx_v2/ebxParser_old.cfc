<cfcomponent extends="PropertyInterface">
	<cfset variables.ebx         = "">
	<cfset variables.interfaces  = StructNew()>
	<cfset variables.lastresult  = StructNew()>
	
	<cfset this.originalAction      = "">
	<cfset this.originalCircuit     = "">
	<cfset this.originalAct         = "">
	<cfset this.originalCircuitdir  = "">
	<cfset this.originalRootpath    = "">
	<cfset this.originalExecdir     = "">
	
	<cfset this.targetAction        = "">
	<cfset this.targetCircuit       = "">
	<cfset this.targetAct           = "">
	<cfset this.targetCircuitdir    = "">
	<cfset this.targetRootpath      = "">
	<cfset this.targetExecdir       = "">
	
	<cfset this.thisAction          = "">
	<cfset this.thisCircuit         = "">
	<cfset this.act                 = "">
	<cfset this.circuitdir          = "">
	<cfset this.rootpath            = "">
	<cfset this.execdir             = "">
	
	<cffunction name="init">
		<cfargument name="ebx">
			<cfset var local = StructNew()>
			<cfset variables.ebx = arguments.ebx>
			<cfset variables.interfaces.pagectx = createObject("component", "ebxPageContext")>
			<cfset variables.interfaces.handler = createObject("component", "ebxHandler").init(this)>
			<cfset variables.interfaces.events  = createObject("component", "ebxEvents").init(this)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="do">
		<cfargument name="action"     required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		
		<cfset var local = StructNew()>
		<cfset getEventInterface().OnExecuteDo(arguments.action)>
		<cfif arguments.contentvar neq "">
			<cfset _setContentVar(arguments.contentvar, getLastResult().output, arguments.append)>
		<cfelse>
			<cfset variables.interfaces.pagectx.ebx_write(getLastResult().output)>
		</cfif>

		<!--- <cfset var local = execdo(arguments.action)>
		<cfif NOT local.result.errors>
			<cfif arguments.contentvar neq "">
				<cfset _setContentVar(arguments.contentvar, local.result.output, arguments.append)>
			<cfelse>
				<cfset variables.interfaces.pagectx.ebx_write(local.result.output)>
			</cfif>
		</cfif> --->
	</cffunction>
	
	<cffunction name="execdo">
		<cfargument name="action"  required="true" type="string" hint="full qualified action">
		
		<cfset var local = StructNew()>
		<cfset getEventInterface().OnExecuteDo(getMainAction())>
		
		
		<!--- <cfset local.request = variables.interfaces.handler.createRequest(arguments.action)>
		<cfif local.request.isExecutable()>
			<cfset variables.interfaces.handler.addRequest(local.request)>
			<cfset local.switchfile = local.request.getCircuitDir() & getParameter("switchfile")>
			<cfset local.result     = _include(local.switchfile)>
		</cfif> --->
		
		<cfreturn local>
	</cffunction>
	
	<cffunction name="execute">
		<cfargument name="parselayoutsfile"  required="false" type="boolean" default="true" hint="parse layoutsfile?">
		
		<cfset var local   = StructNew()>
		<cfset getEventInterface().OnExecute(getMainAction())>
		<!--- 
		<cfif NOT local.mainrequest.result.errors>
			
			<cfif arguments.parselayoutsfile>
				<cfset local.temp = _include(getParameter("layoutsfile"))>
				<cfif NOT local.temp.errors>
					<cfset this.includelayout   = this.layoutdir & this.layoutfile>
					<cfif this.includelayout neq "">
						<cfset local.temp = _include(this.includelayout)>
						<cfif NOT local.temp.errors>
							<cfset variables.interfaces.pagectx.ebx_write(local.temp.output)>
							<cfreturn local.mainrequest>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		<cfelse>
			<cfsavecontent variable="this.layout"><cfoutput>#local.mainrequest.result.output#</cfoutput></cfsavecontent>
		</cfif> --->
		<cfset this.layout = getLastResult().output>
		<cfset variables.interfaces.pagectx.ebx_write(this.layout)>
		
		<cfreturn TRUE>
	</cffunction>

	<cffunction name="getAppPath">
		<cfreturn variables.ebx.getAppPath()>
	</cffunction>
	
	<cffunction name="getAttribute">
		<cfargument name="name"  required="true"  type="string">
		<cfargument name="value" required="false" type="any"  default="" hint="default value">
		<cfset var result = getAttributes()>
		<cfif StructKeyExists(result, arguments.name)>
			<cfreturn result[arguments.name]>
		</cfif>
		<cfreturn arguments.value>
	</cffunction>
	
	<cffunction name="getAttributes">
		<cfargument name="attributes" required="false" type="struct"  default="#StructNew()#" hint="default attributes">
		<cfreturn variables.interfaces.pagectx.ebx_get("attributes", arguments.attributes)>
	</cffunction>
	
	<cffunction name="getEbx">
		<cfreturn variables.ebx>
	</cffunction>
	
	<cffunction name="getEventInterface">
		<cfreturn variables.interfaces.events>
	</cffunction>

	<cffunction name="getHandlerInterface">
		<cfreturn variables.interfaces.handler>
	</cffunction>
	
	<cffunction name="getIncludeSwitch">
		<cfreturn getProperty("circuitdir") & getParameter("switchfile")>
	</cffunction>
	
	<cffunction name="getLastResult">
		<cfreturn variables.lastresult>
	</cffunction>
	
	<cffunction name="getPageContextInterface">
		<cfreturn variables.interfaces.pagectx>
	</cffunction>
	
	<cffunction name="getMainAction">
		<cfreturn getAttribute(getParameter("actionvar"), getParameter("defaultact"))>
	</cffunction>
	
	<cffunction name="getParameter">
		<cfargument name="name" required="true">
		<cfargument name="default" required="true" default="">
		<cfreturn variables.ebx.getParameter(arguments.name, arguments.default)>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn variables.ebx.getParameters()>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" required="true">
		<cfreturn variables.ebx.hasCircuit(arguments.name)>
	</cffunction>
	
	<cffunction name="initialise">
		<cfargument name="attributes"     required="false" type="struct"  default="#StructNew()#" hint="default attributes">
		<cfargument name="scopecopy"      required="false" type="string"  default="url,form" hint="list of scopes to copy to attributes">
		<cfargument name="parse_settings" required="false" type="boolean" default="true"     hint="parse settingsfile?">
		
			<cfset getEventInterface().OnBoxInit(arguments)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="include">
		<cfargument name="template"   required="true" type="string">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">

		<cfset var result = StructNew()>
		<cfset getEventInterface().OnBoxInclude(this.execdir & arguments.template)>
		<cfif NOT getLastResult().errors>
			<cfif arguments.contentvar neq "">
				<cfset _setContentVar(arguments.contentvar, getLastResult().output, arguments.append)>
			<cfelse>
				<cfset variables.interfaces.pagectx.ebx_write(getLastResult().output)>
			</cfif>
		<cfelse>
			<cfset variables.interfaces.pagectx.ebx_write("FOUT! #arguments.template#")>
		</cfif>
		<cfreturn getLastResult()>
	</cffunction>
	
	
	<cffunction name="setAttribute">
		<cfargument name="name"      required="true">
		<cfargument name="value"     required="true" default="">
		<cfargument name="overwrite" required="true" default="false">
		
		<cfset _setContentVar("attributes.#arguments.name#",  arguments.value, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="setAttributes">
		<cfargument name="attributes" required="true" type="struct" default="#StructNew()#">
		<cfargument name="overwrite"  required="true" default="false">
		<cfset _setContentVar("attributes", arguments.attributes, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="setCurrentRequest">
		<cfargument name="request">
		<!--- <cfset this.thisRequest         = getRequest()> --->
		<cfset this.thisAction          = arguments.request.get("fullact")>
		<cfset this.thisCircuit         = arguments.request.get("circuit")>
		<cfset this.act                 = arguments.request.get("act")>
		<cfset this.circuitdir          = arguments.request.get("circuitdir")>
		<cfset this.rootpath            = arguments.request.get("rootpath")>
		<cfset this.execdir             = arguments.request.get("execdir")>
	</cffunction>
	
	<cffunction name="setLastResult">
		<cfargument name="lastresult">
		<cfset variables.lastresult = arguments.lastresult>
		<cfreturn getLastResult()>
	</cffunction>
	
	<cffunction name="setOriginalRequest">
		<!--- <cfset this.originalRequest     = getOriginalRequest()> --->
		<cfargument name="request">	
		<cfset this.originalAction      = arguments.request.get("fullact")>
		<cfset this.originalCircuit     = arguments.request.get("circuit")>
		<cfset this.originalAct         = arguments.request.get("act")>
		<cfset this.originalCircuitdir  = arguments.request.get("circuitdir")>
		<cfset this.originalRootpath    = arguments.request.get("rootpath")>
		<cfset this.originalExecdir     = arguments.request.get("execdir")>
	</cffunction>
	
	<cffunction name="setTargetRequest">
		<cfargument name="request">	
		<!--- <cfset this.targetRequest       = arguments.request> --->
		<cfset this.targetAction        = arguments.request.get("fullact")>
		<cfset this.targetCircuit       = arguments.request.get("circuit")>
		<cfset this.targetAct           = arguments.request.get("act")>
		<cfset this.targetCircuitdir    = arguments.request.get("circuitdir")>
		<cfset this.targetRootpath      = arguments.request.get("rootpath")>
		<cfset this.targetExecdir       = arguments.request.get("execdir")>
	</cffunction>
	
	<cffunction name="setParameter">
		<cfargument name="name"      required="true">
		<cfargument name="value"     required="true" default="">
		<cfargument name="overwrite" required="true" default="false">
		<cfset variables.ebx.setParameter(arguments.name, arguments.value, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="setParameters">
		<cfargument name="parameters" required="true">
		<cfargument name="overwrite"  required="true" default="false">
		<cfset variables.ebx.setParameters(arguments.parameters, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="_dump">
		<cfloop collection="#variables#" item="local.i">
			<cfif IsSimpleValue(variables[local.i])>
				<cfoutput>#local.i#: #variables[local.i]#<br /></cfoutput>
			</cfif>
		</cfloop>
		<cfloop collection="#this#" item="local.i">
			<cfif IsSimpleValue(this[local.i])>
				<cfoutput>#local.i#: #this[local.i]#<br /></cfoutput>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="_include">
		<cfargument name="template"   required="true" type="string">
		<cfreturn variables.interfaces.pagectx.ebx_include(getAppPath() & arguments.template)>
	</cffunction>
	
	<cffunction name="_setContentVar">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="value"      required="false" type="any"  default="" hint="the request result">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var local = StructNew()>
		<cfset local.newvalue = arguments.value>
		<cfif arguments.append>
			<cfset local.temp   = variables.interfaces.pagectx.ebx_get(arguments.contentvar, "")>
			<cfset local.newvalue = local.temp & local.newvalue>
		</cfif>
		<cfset variables.interfaces.pagectx.ebx_put(arguments.contentvar, local.newvalue)>
	</cffunction>
	
</cfcomponent>