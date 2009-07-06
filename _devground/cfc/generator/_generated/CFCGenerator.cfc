<cfcomponent name="CFCGenerator">
	<cfset variables.methods = "#ArrayNew(1)#">
	<cfset variables.method = "#StructNew()#">
	<cfset variables.retvar = "#StructNew()#">
	<cfset variables.rettype = "#StructNew()#">
	<cfset variables.params = "#ArrayNew(1)#">
	<cfset variables.param = "#StructNew()#">
	<cfset variables.varstruct = "#StructNew()#">
	<cfset variables.vararray = "#ArrayNew(1)#">
	<cfset variables.varstring = "">
	<cfset variables.body = "#ArrayNew(1)#">
	<cfset variables.component = "#StructNew()#">
	<cfset variables.componentbody = "">
	<cfset variables.template = "">
	<cfset this.KNOWN_DELIMTERS = "10,32,44,124,43,64">
	<cfset this.name = "">
	<cfset this.extends = "">
	<cfset this.declvars = "#ArrayNew(1)#">
	<cfset this.methods = "#ArrayNew(1)#">
	<cfset this.templates = "#StructNew()#">
	<cfset this.knownvars = "#StructNew()#">
	<cfset this.public_gsv = "">
	<cfset this.private_gsv = "">
	<cfset this.other_methods = "">
	<cfset this.create_init = "true">
	<cfset this.auto_set_init = "true">
	<cfset this.init_argv = "">
	
		
	<cffunction name="init" output="No" returntype="CFCGenerator">
		<cfargument name="name" type="string" required="true">
		<cfargument name="public_gsv" type="string" required="false" default="#this.public_gsv#">
		<cfargument name="private_gsv" type="string" required="false" default="#this.private_gsv#">
		<cfargument name="other_methods" type="string" required="false" default="#this.other_methods#">
		<cfargument name="create_init" type="boolean" required="false" default="#this.create_init#">
		<cfargument name="auto_set_init" type="boolean" required="false" default="#this.auto_set_init#">
		<cfargument name="init_argv" type="string" required="false" default="#this.init_argv#">
		
		<cfset var local = StructNew()>
		<cfset local.name = arguments.name>
		<cfset local.public_gsv = arguments.public_gsv>
		<cfset local.private_gsv = arguments.private_gsv>
		<cfset local.other_methods = arguments.other_methods>
		<cfset local.create_init = arguments.create_init>
		<cfset local.auto_set_init = arguments.auto_set_init>
		<cfset local.init_argv = arguments.init_argv>
	
		<cfset setName(arguments.name)>
		<cfset setPublic_gsv(arguments.public_gsv)>
		<cfset setPrivate_gsv(arguments.private_gsv)>
		<cfset setOther_methods(arguments.other_methods)>
		<cfset setCreate_init(arguments.create_init)>
		<cfset setAuto_set_init(arguments.auto_set_init)>
		<cfset setInit_argv(arguments.init_argv)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="parseDelimitedString" output="No" returntype="array">
		<cfargument name="instring" type="any" required="true">
		<cfargument name="delimiter" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		<cfset local.delimiter = arguments.delimiter>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="guessDelimiter" output="No" returntype="string">
		<cfargument name="instring" type="any" required="true">
		<cfargument name="delimiter" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		<cfset local.delimiter = arguments.delimiter>
		
		<cfreturn local.delimiter>
	</cffunction>
	
	<cffunction name="parseMethod" output="No" returntype="struct">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="parseParams" output="No" returntype="array">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="parseParam" output="No" returntype="struct">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="createVar" output="No" returntype="struct">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="addScopeVar" output="No" returntype="any">
		<cfargument name="varstruct" type="struct" required="true">
		<cfargument name="scopename" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.varstruct = arguments.varstruct>
		<cfset local.scopename = arguments.scopename>
		
		<cfreturn >
	</cffunction>
	
	<cffunction name="getScopeVar" output="No" returntype="struct">
		<cfargument name="varname" type="any" required="true">
		<cfargument name="scopename" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.varname = arguments.varname>
		<cfset local.scopename = arguments.scopename>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="parseTemplate" output="No" returntype="string">
		<cfargument name="template" type="string" required="true">
		<cfargument name="replacement" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.template = arguments.template>
		<cfset local.replacement = arguments.replacement>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="addMethod" output="No" returntype="array">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.methods>
	</cffunction>
	
	<cffunction name="addParam" output="No" returntype="array">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.params>
	</cffunction>
	
	<cffunction name="createGetterSetter" output="No" returntype="array">
		<cfargument name="varstruct" type="struct" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.varstruct = arguments.varstruct>
		
		<cfreturn local.gettersetter>
	</cffunction>
	
	<cffunction name="createInit" output="No" returntype="array">
		<cfargument name="varstruct" type="struct" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.varstruct = arguments.varstruct>
		
		<cfreturn local.gettersetter>
	</cffunction>
	
	<cffunction name="createSetVariable" output="No" returntype="array">
		<cfargument name="varstruct" type="struct" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.varstruct = arguments.varstruct>
		
		<cfreturn local.gettersetter>
	</cffunction>
	
	<cffunction name="createMethod" output="No" returntype="struct">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="createParam" output="No" returntype="struct">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="guessVariable" output="No" returntype="struct">
		<cfargument name="name" type="string" required="true">
		<cfargument name="scope" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.name = arguments.name>
		<cfset local.scope = arguments.scope>
		
		<cfreturn local.variable>
	</cffunction>
	
	<cffunction name="determineDefault" output="No" returntype="string">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.instring>
	</cffunction>
	
	<cffunction name="determineRequired" output="No" returntype="string">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.instring>
	</cffunction>
	
	<cffunction name="determineDatatype" output="No" returntype="string">
		<cfargument name="instring" type="any" required="true">
		
		<cfset var local = StructNew()>
		<cfset local.instring = arguments.instring>
		
		<cfreturn local.instring>
	</cffunction>
	
	<cffunction name="_getMethods" output="No">
		<cfreturn variables.methods>
	</cffunction>
	<cffunction name="_setMethods" output="No">
		<cfargument name="methods" type="array" required="false">
		<cfset variables.methods = arguments.methods>
	</cffunction>
	
	
	<cffunction name="_getMethod" output="No">
		<cfreturn variables.method>
	</cffunction>
	<cffunction name="_setMethod" output="No">
		<cfargument name="method" type="struct" required="false">
		<cfset variables.method = arguments.method>
	</cffunction>
	
	
	<cffunction name="_getRetvar" output="No">
		<cfreturn variables.retvar>
	</cffunction>
	<cffunction name="_setRetvar" output="No">
		<cfargument name="retvar" type="struct" required="false">
		<cfset variables.retvar = arguments.retvar>
	</cffunction>
	
	
	<cffunction name="_getRettype" output="No">
		<cfreturn variables.rettype>
	</cffunction>
	<cffunction name="_setRettype" output="No">
		<cfargument name="rettype" type="struct" required="false">
		<cfset variables.rettype = arguments.rettype>
	</cffunction>
	
	
	<cffunction name="_getParams" output="No">
		<cfreturn variables.params>
	</cffunction>
	<cffunction name="_setParams" output="No">
		<cfargument name="params" type="array" required="false">
		<cfset variables.params = arguments.params>
	</cffunction>
	
	
	<cffunction name="_getParam" output="No">
		<cfreturn variables.param>
	</cffunction>
	<cffunction name="_setParam" output="No">
		<cfargument name="param" type="struct" required="false">
		<cfset variables.param = arguments.param>
	</cffunction>
	
	
	<cffunction name="_getVarstruct" output="No">
		<cfreturn variables.varstruct>
	</cffunction>
	<cffunction name="_setVarstruct" output="No">
		<cfargument name="varstruct" type="struct" required="false">
		<cfset variables.varstruct = arguments.varstruct>
	</cffunction>
	
	
	<cffunction name="_getVararray" output="No">
		<cfreturn variables.vararray>
	</cffunction>
	<cffunction name="_setVararray" output="No">
		<cfargument name="vararray" type="array" required="false">
		<cfset variables.vararray = arguments.vararray>
	</cffunction>
	
	
	<cffunction name="_getVarstring" output="No">
		<cfreturn variables.varstring>
	</cffunction>
	<cffunction name="_setVarstring" output="No">
		<cfargument name="varstring" type="string" required="false">
		<cfset variables.varstring = arguments.varstring>
	</cffunction>
	
	
	<cffunction name="_getBody" output="No">
		<cfreturn variables.body>
	</cffunction>
	<cffunction name="_setBody" output="No">
		<cfargument name="body" type="array" required="false">
		<cfset variables.body = arguments.body>
	</cffunction>
	
	
	<cffunction name="_getComponent" output="No">
		<cfreturn variables.component>
	</cffunction>
	<cffunction name="_setComponent" output="No">
		<cfargument name="component" type="struct" required="false">
		<cfset variables.component = arguments.component>
	</cffunction>
	
	
	<cffunction name="_getComponentbody" output="No">
		<cfreturn variables.componentbody>
	</cffunction>
	<cffunction name="_setComponentbody" output="No">
		<cfargument name="componentbody" type="string" required="false">
		<cfset variables.componentbody = arguments.componentbody>
	</cffunction>
	
	
	<cffunction name="_getTemplate" output="No">
		<cfreturn variables.template>
	</cffunction>
	<cffunction name="_setTemplate" output="No">
		<cfargument name="template" type="string" required="false">
		<cfset variables.template = arguments.template>
	</cffunction>
	
	
	<cffunction name="getKnown_delimters" output="No">
		<cfreturn this.KNOWN_DELIMTERS>
	</cffunction>
	<cffunction name="setKnown_delimters" output="No">
		<cfargument name="KNOWN_DELIMTERS" type="string" required="false">
		<cfset this.KNOWN_DELIMTERS = arguments.KNOWN_DELIMTERS>
	</cffunction>
	
	
	<cffunction name="getName" output="No">
		<cfreturn this.name>
	</cffunction>
	<cffunction name="setName" output="No">
		<cfargument name="name" type="string" required="true">
		<cfset this.name = arguments.name>
	</cffunction>
	
	
	<cffunction name="getExtends" output="No">
		<cfreturn this.extends>
	</cffunction>
	<cffunction name="setExtends" output="No">
		<cfargument name="extends" type="string" required="false">
		<cfset this.extends = arguments.extends>
	</cffunction>
	
	
	<cffunction name="getDeclvars" output="No">
		<cfreturn this.declvars>
	</cffunction>
	<cffunction name="setDeclvars" output="No">
		<cfargument name="declvars" type="struct" required="false">
		<cfset this.declvars = arguments.declvars>
	</cffunction>
	
	
	<cffunction name="getMethods" output="No">
		<cfreturn this.methods>
	</cffunction>
	<cffunction name="setMethods" output="No">
		<cfargument name="methods" type="struct" required="false">
		<cfset this.methods = arguments.methods>
	</cffunction>
	
	
	<cffunction name="getTemplates" output="No">
		<cfreturn this.templates>
	</cffunction>
	<cffunction name="setTemplates" output="No">
		<cfargument name="templates" type="struct" required="false">
		<cfset this.templates = arguments.templates>
	</cffunction>
	
	
	<cffunction name="getKnownvars" output="No">
		<cfreturn this.knownvars>
	</cffunction>
	<cffunction name="setKnownvars" output="No">
		<cfargument name="knownvars" type="struct" required="false">
		<cfset this.knownvars = arguments.knownvars>
	</cffunction>
	
	
	<cffunction name="getPublic_gsv" output="No">
		<cfreturn this.public_gsv>
	</cffunction>
	<cffunction name="setPublic_gsv" output="No">
		<cfargument name="public_gsv" type="string" required="false">
		<cfset this.public_gsv = arguments.public_gsv>
	</cffunction>
	
	
	<cffunction name="getPrivate_gsv" output="No">
		<cfreturn this.private_gsv>
	</cffunction>
	<cffunction name="setPrivate_gsv" output="No">
		<cfargument name="private_gsv" type="string" required="false">
		<cfset this.private_gsv = arguments.private_gsv>
	</cffunction>
	
	
	<cffunction name="getOther_methods" output="No">
		<cfreturn this.other_methods>
	</cffunction>
	<cffunction name="setOther_methods" output="No">
		<cfargument name="other_methods" type="string" required="false">
		<cfset this.other_methods = arguments.other_methods>
	</cffunction>
	
	
	<cffunction name="getCreate_init" output="No">
		<cfreturn this.create_init>
	</cffunction>
	<cffunction name="setCreate_init" output="No">
		<cfargument name="create_init" type="boolean" required="false">
		<cfset this.create_init = arguments.create_init>
	</cffunction>
	
	
	<cffunction name="getAuto_set_init" output="No">
		<cfreturn this.auto_set_init>
	</cffunction>
	<cffunction name="setAuto_set_init" output="No">
		<cfargument name="auto_set_init" type="boolean" required="false">
		<cfset this.auto_set_init = arguments.auto_set_init>
	</cffunction>
	
	
	<cffunction name="getInit_argv" output="No">
		<cfreturn this.init_argv>
	</cffunction>
	<cffunction name="setInit_argv" output="No">
		<cfargument name="init_argv" type="string" required="false">
		<cfset this.init_argv = arguments.init_argv>
	</cffunction>
</cfcomponent>
