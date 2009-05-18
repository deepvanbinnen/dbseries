<cfcomponent output="false">
	<cfset variables.ebx         = "">
	<cfset variables.stack  = ArrayNew(1)>
	<cfset variables.MAXREQUESTS = 10><!--- maximum requests the stack can handle --->
	<cfset variables.request     = "">
	
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
		<cfset variables.pc  = createObject("component", "ebxPageContext")>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addRequest">
		<cfargument name="request" hint="the current request">
		
		<cfset var local = StructNew()>
		<cfif ArrayLen(variables.stack) GT variables.MAXREQUESTS>
			<!--- <cfset setDebug("Max reached: #variables.MAXREQUESTS#", 0)> --->
			<cfoutput>MAX REACHED!</cfoutput>
		</cfif>
		
		<cfset ArrayPrepend(variables.stack,arguments.request)>
		<cfif ArrayLen(variables.stack) eq 1>
			<cfset setOriginalRequest()>
		</cfif>
		<cfset setCurrentRequest()>
		<cfset setTargetRequest(getRequest())>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="createRequest">
		<cfargument name="action">
		<cfargument name="parameters" default="#StructNew()#">
		
		<cfreturn createObject("component", "ebxRequest").init(variables.ebx, arguments.action, arguments.parameters)>
	</cffunction>
	
	<cffunction name="do">
		<cfargument name="action"     required="true" type="string"   hint="the action to execute">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var local = execdo(arguments.action)>
		<cfif NOT local.result.errors>
			<cfif arguments.contentvar neq "">
				<cfset _setContentVar(arguments.contentvar, local.result.output, arguments.append)>
			<cfelse>
				<cfset variables.pc.ebx_write(local.result.output)>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="execdo">
		<cfargument name="action"  required="true" type="string" hint="full qualified action">
		
		<cfset var local = StructNew()>
		<cfset local.request = createRequest(arguments.action)>
		<cfif local.request.isExecutable()>
			<cfset addRequest(local.request)>
			<cfset local.switchfile = local.request.getCircuitDir() & getParameter("switchfile")>
			<cfset local.result     = _include(local.switchfile)>
		</cfif>
		
		<cfreturn local>
	</cffunction>
	
	<cffunction name="execute">
		<cfargument name="parselayoutsfile"  required="false" type="boolean" default="true" hint="parse layoutsfile?">
		
		<cfset var local = StructNew()>
		<cfset local.act         = getAttribute(getParameter("actionvar"), getParameter("defaultact"))>
		<cfset local.mainrequest = execdo(local.act)>
		
		<cfif NOT local.mainrequest.result.errors>
			<cfset this.layout  = local.mainrequest.result.output>
			<cfif arguments.parselayoutsfile>
				<cfset local.temp = include(getParameter("layoutsfile"))>
				<cfif NOT local.temp.errors>
					<cfset this.includelayout   = this.layoutdir & this.layoutfile>
					<cfif this.includelayout neq "">
						<cfset local.temp = _include(this.includelayout)>
						<cfif NOT local.temp.errors>
							<cfset variables.pc.ebx_write(local.temp.output)>
							<cfreturn local.mainrequest>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		<cfelse>
			<cfdump var="#local.mainrequest.result#">
		</cfif>
		<cfset variables.pc.ebx_write(this.layout)>
		
		<cfreturn local.mainrequest>
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
		<cfreturn variables.pc.ebx_get("attributes", StructNew())>
	</cffunction>
	
	<cffunction name="getMainAction">
		<cfreturn getAttribute(getParameter("actionvar"), getParameter("defaultact"))>
	</cffunction>
	
	<cffunction name="getOriginalRequest">
		<cfif hasRequests()>
			<cfreturn variables.stack[ArrayLen(variables.stack)]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getParameter">
		<cfargument name="name" required="true">
		<cfargument name="default" required="true" default="">
		<cfreturn variables.ebx.getParameter(arguments.name, arguments.default)>
	</cffunction>
	
	<cffunction name="getParameters">
		<cfreturn variables.ebx.getParameters()>
	</cffunction>
	
	<cffunction name="getRequest">
		<cfif hasRequests()>
			<cfreturn variables.stack[1]>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getRequestVariable">
		<cfargument name="request">	
		<cfargument name="prop">
		
		<cfif IsStruct(arguments.request) AND StructKeyExists(arguments.request, "get")>
			<cfreturn arguments.request.get(arguments.prop)>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="getStack">
		<cfreturn variables.stack>
	</cffunction>
	
	<cffunction name="hasCircuit">
		<cfargument name="name" required="true">
		<cfreturn variables.ebx.hasCircuit(arguments.name)>
	</cffunction>
	
	<cffunction name="hasRequests">
		<cfreturn ArrayLen(variables.stack)>
	</cffunction>
	
	<cffunction name="initialise">
		<cfargument name="scopecopylist"     required="false" type="string"  default="url,form" hint="list of scopes to copy to attributes">
		<cfargument name="parsesettingsfile" required="false" type="boolean" default="true"     hint="parse settingsfile?">
		
		<cfset var result = StructNew()>
		<cfset result.attr   = getAttributes()>
		<cfloop list="#arguments.scopecopylist#" index="result.item">
			<cfset StructAppend(result.attr, getAttribute(result.item, StructNew()))>
		</cfloop>
		<cfset setAttributes(result.attr)>
		
		<cfif arguments.parsesettingsfile>
			<cfset result.settings = include(getParameter("settingsfile"))>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="include">
		<cfargument name="template"   required="true" type="string">
		<cfargument name="params"     required="false" type="struct"  default="#StructNew()#" hint="local params">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">

		<cfset var result = _include(arguments.template)>
		<cfif NOT result.errors>
			<cfif arguments.contentvar neq "">
				<cfset _setContentVar(arguments.contentvar, result.output, arguments.append)>
			<cfelse>
				<cfset variables.pc.ebx_write(result.output)>
			</cfif>
		</cfif>
		<cfreturn result>
	</cffunction>
	
	<cffunction name="removeRequest">
		<cfif ArrayLen(variables.stack) GT 0>
			<cfset ArrayDeleteAt(variables.stack,1)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="setAttribute">
		<cfargument name="name"      required="true">
		<cfargument name="value"     required="true" default="">
		<cfargument name="overwrite" required="true" default="false">
		
		<cfset _setContentVar("attributes.#arguments.name#",  arguments.value, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="setAttributes">
		<cfargument name="attributes" required="true">
		<cfargument name="overwrite"  required="true" default="false">
		<cfset _setContentVar("attributes", arguments.attributes, arguments.overwrite)>
	</cffunction>
	
	<cffunction name="setOriginalRequest">
		<!--- <cfset this.originalRequest     = getOriginalRequest()> --->
		<cfset this.originalAction      = getRequestVariable(getOriginalRequest(), "fullact")>
		<cfset this.originalCircuit     = getRequestVariable(getOriginalRequest(), "circuit")>
		<cfset this.originalAct         = getRequestVariable(getOriginalRequest(), "act")>
		<cfset this.originalCircuitdir  = getRequestVariable(getOriginalRequest(), "circuitdir")>
		<cfset this.originalRootpath    = getRequestVariable(getOriginalRequest(), "rootpath")>
		<cfset this.originalExecdir     = getRequestVariable(getOriginalRequest(), "execdir")>
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
	
	<cffunction name="setTargetRequest">
		<cfargument name="request">	
		<!--- <cfset this.targetRequest       = arguments.request> --->
		<cfset this.targetAction        = getRequestVariable(arguments.request, "fullact")>
		<cfset this.targetCircuit       = getRequestVariable(arguments.request, "circuit")>
		<cfset this.targetAct           = getRequestVariable(arguments.request, "act")>
		<cfset this.targetCircuitdir    = getRequestVariable(arguments.request, "circuitdir")>
		<cfset this.targetRootpath      = getRequestVariable(arguments.request, "rootpath")>
		<cfset this.targetExecdir       = getRequestVariable(arguments.request, "execdir")>
	</cffunction>
	
	<cffunction name="setCurrentRequest">
		<!--- <cfset this.thisRequest         = getRequest()> --->
		<cfset this.thisAction          = getRequestVariable(getRequest(), "fullact")>
		<cfset this.thisCircuit         = getRequestVariable(getRequest(), "circuit")>
		<cfset this.act                 = getRequestVariable(getRequest(), "act")>
		<cfset this.circuitdir          = getRequestVariable(getRequest(), "circuitdir")>
		<cfset this.rootpath            = getRequestVariable(getRequest(), "rootpath")>
		<cfset this.execdir             = getRequestVariable(getRequest(), "execdir")>
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
		<cfreturn variables.pc.ebx_include(getAppPath() & arguments.template)>
	</cffunction>
	
	<cffunction name="_setContentVar">
		<cfargument name="contentvar" required="false" type="string"  default="" hint="variable that catches output">
		<cfargument name="value"      required="false" type="any"  default="" hint="the request result">
		<cfargument name="append"     required="false" type="boolean" default="false" hint="wheater to append contentvars output">
		
		<cfset var local = StructNew()>
		<cfset local.newvalue = arguments.value>
		<cfif arguments.append>
			<cfset local.temp   = variables.pc.ebx_get(arguments.contentvar, "")>
			<cfset local.newvalue = local.temp & local.newvalue>
		</cfif>
		<cfset variables.pc.ebx_put(arguments.contentvar, local.newvalue)>
	</cffunction>
	
</cfcomponent>