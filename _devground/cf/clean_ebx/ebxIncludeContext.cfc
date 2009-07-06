<cfcomponent extends="ebxAbstractContext">
	<cffunction name="init" returntype="any">
		<cfargument name="parser"   required="true" type="ebxParser" hint="context-action">
		<cfargument name="type"     required="true" type="string" hint="context-action">
		<cfargument name="template" required="true" type="string" hint="context-action">
		
		<cfreturn super.init(parser=arguments.parser, type="include", template=arguments.template)>
	</cffunction>
</cfcomponent>