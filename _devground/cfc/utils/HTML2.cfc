<cfcomponent>
	<cfset variables.keywrapchar = "%">
	<cfset variables.keyregex    = "(#variables.keywrapchar#([0-9a-zA-Z_]+)#variables.keywrapchar#)[\\]{0,1}">
	<cfset variables.pattern     = CreateObject("java","java.util.regex.Pattern").Compile(JavaCast("string", keyregex))>
	
	
	<cffunction name="rxReplaceWithStruct" hint="takes a string and struct and replaces StructKeys with corresponding values in the string, where %structkey% is wrapped in %">
		<cfargument name="str" type="string" hint="string in which to replace structkeys with corresponding values">
		<cfargument name="rep" type="struct" hint="struct with key value translations">
		
		<!--- <cfset var myregex = "(%([0-9]+|CURRENT|KEY)%)[\\]{0,1}"> --->
		<cfset var Local = StructNew()>
		<cfset Local.str = arguments.str>
		<cfset Local.rep = arguments.rep>
		
		<cfset Local.matcher = variables.pattern.Matcher(JavaCast( "string", Local.str ))>
		<cfloop condition="Local.matcher.Find()">
			<cfif StructKeyExists(rep, Local.matcher.Group('2'))>
				<cftry>
					<cfset Local.str = Local.str.replaceAll(JavaCast("string",Local.matcher.Group('1')), JavaCast("string", Local.rep[Local.matcher.Group('2')]))>
					<cfcatch type="any">
						<!--- <cfoutput>Error in replace: (#Local.matcher.Group('1')#,#Local.rep[Local.matcher.Group('2')]#</cfoutput>
						<cfdump var="#Local.str.toString()#">
						<cfdump var="#cfcatch#"> --->
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
		<cfreturn Local.str>
	</cffunction>
	
	<cffunction name="collectionToStruct">
		<cfargument name="collection" type="any" hint="any collection">
		<cfargument name="keylist" type="string" hint="any collection">
		
		<cfset var Local = StructNew()>
		<cfset Local.setOf = CreateObject("component", "dbseries.cf.cfc.commons.SetOf").init()>
		
		
		<cfset Local.out = StructNew()>
		
		<cfset Local.it =  CreateObject("component", "dbseries.cf.cfc.commons.Iterator").init(arguments.keylist)>
		<cfloop condition="#Local.it.whileHasNext()#">
			<cfswitch expression="#Local.it.getIterableType()#">
				<cfcase value="string">
					<cfset StructInsert(Local.out, local.it.index, local.it.current)>
				</cfcase>
				<cfcase value="struct">
					<cfset StructInsert(Local.out, local.it.key, local.it.current)>
				</cfcase>
				<cfcase value="array">
					<cfif IsObject(local.it.current)>
					
					</cfif>
					<cfset StructInsert(Local.out, local.it.key, local.it.current)>
				</cfcase>
				
			</cfswitch>
			<cfoutput>#Local.it.current#</cfoutput>
		</cfloop>
		
		<cfreturn "a">
		
	</cffunction>

</cfcomponent>