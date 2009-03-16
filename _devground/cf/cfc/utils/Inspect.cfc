<cfcomponent name="Inspect">
	<cfset variables.object     = "">
	<cfset variables.methods    = ArrayNew(1)>
	<cfset variables.methodlist = "">
	
	<cffunction name="init">
		<cfargument name="object" required="true" type="any">
		<cfset variables.object = arguments.object>
		<cfset _setMethods()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMethodList">
		<cfreturn variables.methodlist>
	</cffunction>
	
	<cffunction name="getMethods">
		<cfreturn variables.methods>
	</cffunction>
	
	<cffunction name="setMethods">
		<cfargument name="meta" required="true" type="any">
		<cfset variables.methods = arguments.meta.getMethods()>
	</cffunction>
	
	<cffunction name="_setMethods">
		<cfset var meta = getMetaData(variables.object)>
		<cftry>
			<cfset setMethods(meta)>
			<cfloop from="1" to="#ArrayLen(variables.methods)#" index="i">
				<cfset variables.methodlist = ListAppend(variables.methodlist, variables.methods[i].getName())>
				<!--- <cfdump var="#mt#"> 
				<cfif mt.getName() eq "listIterator">
					<cfoutput>Name: #mt.getName()#<br /></cfoutput>
					<cfset p = mt.getParameterTypes()>
					<cfloop from="1" to="#ArrayLen(p)#" index="j">
						<cfoutput>#p[j].toString()#</cfoutput>
					</cfloop>
					<cfdump var="#mt.getParameterTypes()#">
				</cfif>	 --->
			</cfloop>
			<cfcatch  type="any"></cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>