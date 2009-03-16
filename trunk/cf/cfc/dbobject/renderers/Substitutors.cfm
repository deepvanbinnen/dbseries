	<cffunction name="substituteValues">
		<cfargument name="value"    required="true" type="string" default="">
		<cfargument name="substitute" required="false" type="struct" default="#StructNew()#">
		
		<cfset var local  = StructNew()>
		<cfset local.subs = arguments.substitute>
		<cfset local.val  = arguments.value>
			
		<cfif Find("%", local.val) AND NOT StructIsEmpty(local.subs)>
			<cfset local.val = subsitute(local.val, local.subs)>
		</cfif>
		<cfreturn local.val>
	</cffunction>
	
	<cffunction name="subsitute">
		<cfargument name="str" type="string">
		<cfargument name="rep">
		
		<!--- <cfset var myregex = "(%([0-9]+|CURRENT|KEY)%)[\\]{0,1}"> --->
		<cfset var myregex = "(%([0-9a-zA-Z]+)%)[\\]{0,1}">
		<cfset var pattern = CreateObject("java","java.util.regex.Pattern").Compile(JavaCast("string", myregex))>
		<cfset var matcher = pattern.Matcher(JavaCast( "string", '' ))>
		
		<cfset matcher.reset(arguments.str)>
		<cfloop condition="matcher.Find()">
			<cfif StructKeyExists(rep, matcher.Group('2'))>
				<cftry>
					<cfset str = str.replaceAll(JavaCast("string",matcher.Group('1')), JavaCast("string",rep[matcher.Group('2')]))>
					<cfcatch type="any">
						<cfoutput>Error in replace: (#matcher.Group('1')#,#rep[matcher.Group('2')]#</cfoutput>
						<cfdump var="#str.toString()#">
						<cfdump var="#cfcatch#">
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
		<cfreturn str>
	</cffunction> 
		
	
	
	<cffunction name="substValsFromObj">
		<cfargument name="subst" required="true" type="struct">
		<cfargument name="obj"   required="true" type="struct">
		
		<cfset var local = StructNew()>
		<cfset local.out = StructNew()>
		<cfset local.obj  = arguments.obj>
		
		<cfset local.out.list  = "">
		<cfset local.out.subst  = arguments.subst>
		
		<cfif ArrayLen(arguments) gt 2>
			<cfset local.out.list  = arguments[3]>
			<cfset local.it = iterator(local.out.list)>
			<cfloop condition="#local.it.whileHasNext()#">
				<cfif StructKeyExists(local.obj, local.it.current)>
					<cfset local.out.subst[local.it.key] = local.obj[local.it.current]>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset local.it = iterator(local.out.subst)>
			<cfloop condition="#local.it.whileHasNext()#">
				<cfif StructKeyExists(local.obj, local.it.current)>
					<cfset local.out.list = ListAppend(local.out.list, local.it.current)>
					<cfset local.out.subst[local.it.key] = local.obj[local.it.current]>
				</cfif>
			</cfloop>
		</cfif>	
		<cfreturn local.out>
	</cffunction>