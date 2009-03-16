	<cffunction name="getHTML">
		<cfargument name="tagname"   required="true"  type="string">
		<cfargument name="attribs"   required="false" type="string" default="">
		<cfargument name="tagbody"   required="false" type="string" default="">
		
		<cfset var html = "">
		<cfset var tag  = LCASE(arguments.tagname)>
		<cfset var body = arguments.tagbody>
		<cfset var attr = arguments.attribs>
		
		<cfset html = "<" & tag>
		<cfif attr neq "">
			<cfset html = html & " " & attr>
		</cfif>
		<cfif body neq "">
			<cfset html = html & ">" & body & "</" & tag & ">">
		<cfelse>
			<cfset html = html & " />">
		</cfif>
		<cfreturn html>
	</cffunction>
	
	<cffunction name="getCollectionHTML">
		<cfargument name="collection" required="true" type="any">
		<cfargument name="render"     required="true" type="any">
		<cfargument name="substmap"   required="true" type="any">
		<cfargument name="colkeys"    required="true" type="any">
		
		<cfset var local      = StructNew()>
		<cfset local.coll     = arguments.collection>
		<cfset local.render   = arguments.render>
		<cfset local.substmap = arguments.substmap>
		<cfset local.colkeys  = arguments.colkeys>
		<cfset local.html = "">
		
		<cfswitch expression="#getCollectionType(local.coll).type#">
			<cfcase value="query,component">
				<cfset local.it = iterator(local.coll)>
				<cfloop condition="#local.it.whileHasNext()#">
					<cfset local.temp             = substValsFromObj(local.substmap, local.it.current, local.colkeys)>
					<cfset local.colkeys          = local.temp.list>
					<cfset local.substmap         = local.temp.subst>
					<cfset local.substmap.key     = local.it.index>
					<cfset local.substmap.current = local.it.index>
					<cfset local.html = local.html & substituteValues(local.render, local.substmap)>
				</cfloop>
			</cfcase>

			<cfcase value="string,array">
				<cfset local.it = iterator(local.coll)>
				<cfloop condition="#local.it.whileHasNext()#">
					<cfset local.substmap.current = local.it.index>
					<cfset local.substmap.key     = local.it.key>
					<cfset local.substmap.value   = local.it.current>
					<cfset local.substmap["0"]    = substituteValues(local.it.current, local.substmap)>
					<cfset local.html = local.html & substituteValues(local.render, local.substmap)>
				</cfloop>
			</cfcase>
			
			<cfcase value="struct">
				<cfset local.temp  = substValsFromObj(local.substmap, local.coll, local.colkeys)>
				<cfset local.colkeys          = local.temp.list>
				<cfset local.substmap         = local.temp.subst>
				<cfset local.html = local.html & substituteValues(local.render, local.substmap)>
				<!--- <cfset local.it = iterator(local.coll)>
				<cfloop condition="#local.it.whileHasNext()#">
					<cfset local.substmap.current = local.it.index>
					<cfset local.substmap.key     = local.it.key>
					<cfset local.substmap.value   = local.it.current>
					<cfset local.substmap["0"]    = substituteValues(local.it.current, local.substmap)>
					<cfset local.html = local.html & substituteValues(local.render, local.substmap)>
				</cfloop> --->
			</cfcase>
		</cfswitch>
		
		<cfreturn local.html>
	</cffunction>