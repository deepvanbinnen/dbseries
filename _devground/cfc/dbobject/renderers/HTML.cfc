<cfcomponent extends="cfc.db.utils" output="false">
	<cfset variables.Subst = StructNew()>
	<cfset variables.Subst.regex = "((%([0-9]+)|(%CURRENT%)|(%KEY%))[\\]{0,1})">
	<cfset variables.Subst.pattern = CreateObject("java","java.util.regex.Pattern").Compile(JavaCast("string", variables.Subst.regex))>
	<cfset variables.Subst.matcher = variables.Subst.pattern.Matcher(JavaCast( "string", '' ))>
	<cfset variables.Subst.knownpatterns = StructNew()>
	
	<cfinclude template="Collectors.cfm">
	<cfinclude template="Helpers.cfm">
	<cfinclude template="Substitutors.cfm">
	
	<cffunction name="init">
		<cfset variables.iterators = StructNew()>
		<cfset variables.numiterators = 0>
		<cfreturn super.init()>
	</cffunction>
	
	<cffunction name="iterator">
		<cfargument name="obj" required="true">
		<cfreturn super.iterator(arguments.obj)>
	</cffunction>
	
	<cffunction name="list">
		<cfargument name="collection" required="true" type="any">
		<cfargument name="text" required="false" type="string" default="%0%" hint="the collections 'content-value' will be used (list,array) for the li's tagbody (or an empty string if it can not be determined)">
		
		<cfset var local     = StructNew()>
		<cfset local.coll    = arguments.collection>
		<cfset local.render  = arguments.text>
		
		<cfset local.argmap   = indexArgs(arguments, 3, "keyfields")>
		<cfset local.itemattr = structSubtract(arguments, "id,class")>
		<cfset local.linkattr = structSubtract(arguments, "href=href,linkid=id,linkclass=class")>
		<cfset local.listattr = structSubtract(arguments, "listid=id,listclass=class")>
		
		<cfset local.html      = "">
		
		<cfif NOT StructIsEmpty(local.linkattr)>
			<cfset local.render = getHTML("a", keysToList(local.linkattr), local.render)>
		</cfif>
		<cfset local.render = getHTML("li", keysToList(local.itemattr), local.render)>
		
		<cfset local.html = getCollectionHTML(local.coll, local.render, local.argmap.map, local.argmap.keylist)>
		
		<cfreturn getHTML("ul", keysToList(local.listattr), local.html)>
	</cffunction>
	
	<cffunction name="link">
		<cfargument name="collection" required="true" type="any">
		<cfargument name="href" required="true" type="string">
		<cfargument name="text" required="false" type="string" default="%0" hint="the collections 'content-value' will be used (list,array) for the li's tagbody (or an empty string if it can not be determined)">
		
		<cfset var local     = StructNew()>
		<cfset local.coll    = arguments.collection>
		<cfset local.text    = arguments.text>
		
		<cfset local.argmap   = indexArgs(arguments, 4, "keyfields")>
		<cfset local.linkattr = structSubtract(arguments, "href,rel,class,id")>
		<cfset local.html      = "">
		
		<cfset local.render = getHTML("a", keysToList(local.linkattr), local.text)>
		<cfset local.html = getCollectionHTML(local.coll, local.render, local.argmap.map, local.argmap.keylist)>
		
		<cfreturn local.html>
	</cffunction>
	
	<cffunction name="table">
		<cfargument name="collection" required="true" type="any">
		<cfargument name="colmap"     required="true" type="string">
		<!--- <cfargument name="headers" required="false" type="string" default="%0" hint="the collections 'content-value' will be used (list,array) for the li's tagbody (or an empty string if it can not be determined)"> --->
		
		<cfset var local     = StructNew()>
		<cfset local.coll    = arguments.collection>
		<cfset local.html      = "">
		
		<cfset local.tableattr = structSubtract(arguments, "id,class")>
		
		<cfset local.colmap = arguments.colmap>
		<cfset local.headers = "">
		<cfset local.rowdata = "">
		
		<cfset local.headers_set = false>
		<cfif StructKeyExists(arguments, "headers") AND arguments.headers neq "">
			<cfset local.headers = arguments.headers>
			<cfset local.headers_set = true>
		</cfif>
		
		<cfset local.argmap  = StructNew()>
		<cfset local.argmap.map = StructNew()>
		<cfset local.argmap.keylist = "">
		
		<cfset local.renders = StructNew()>
		<cfset local.renders["th"] = ArrayNew(1)>
		<cfset local.renders["td"] = ArrayNew(1)>
		
		<!--- Setup substitution map --->
		<cfset local.it = iterator(local.colmap)>
		<cfloop condition="#local.it.whileHasNext()#">
			<cfset local.temp = parseKeyVal(local.it.current)>
			<cfif NOT local.headers_set>
				<cfset local.headers = ListAppend(local.headers, local.temp.value)>
			</cfif>
			<cfset local.rowdata = ListAppend(local.rowdata, local.temp.key)>
			<cfset StructInsert(local.argmap.map, local.it.key, local.temp.key)>
			
			<cfset ArrayAppend(local.renders["th"], getHTML("th", "", local.temp.value))>
			<cfset ArrayAppend(local.renders["td"], getHTML("td", "", "%#local.it.key#%"))>
		</cfloop>
		
		<!--- Setup key list to lookup in collection --->
		<cfset local.argmap.keylist = local.rowdata>
		
		<!--- Parse head --->
		<cfset local.thead = getHTML("tr", "", ArrayToList(local.renders["th"],""))>
		<cfset local.thead = getHTML("thead", "", local.thead )>
		
		<!--- Parse body template --->
		<cfset local.tbody = getHTML("tr", "", ArrayToList(local.renders["td"],""))>
		
		<!--- get body data from template and collection --->
		<cfset local.tbody = getCollectionHTML(local.coll, local.tbody, local.argmap.map, local.argmap.keylist)>
		<cfset local.tbody = getHTML("tbody", "", local.tbody )>
		
		<!--- parse out table --->
		<cfset local.html = getHTML("table", "", local.thead & local.tbody)>
		
		<cfreturn local.html>
	</cffunction>
	
	<cffunction name="render">
		<cfargument name="collection"     required="true" type="any">
		<cfargument name="template"       required="true" type="string">
		<cfargument name="collectionkeys" required="false" type="string">
		
		<cfset var local    = StructNew()>
		<cfset local.coll   = arguments.collection>
		
		<cfset local.argmap = indexArgs(arguments, 3, "collectionkeys")>
		<cfset local.html   = "">
		<cfset local.render = arguments.template>
		<cfset local.html   = getCollectionHTML(local.coll, local.render, local.argmap.map, local.argmap.keylist)>
		
		<cfreturn local.html>
	</cffunction>

	<cffunction name="timesnap">
		<cfargument name="msg" required="false">
		<cfif NOT StructKeyExists(variables, "a")>
			<cfset variables.a = getTickCount()>
		</cfif>
		<cfoutput>#getTickCount()-variables.a#ms</cfoutput>
		<cfif StructKeyExists(arguments, "msg")>
			<cfif IsSimpleValue(arguments.msg)>
				<cfoutput><p>#arguments.msg#</p></cfoutput>
			<cfelse>
				<cfdump var="#msg#">
			</cfif>
		</cfif>
		<hr />
	</cffunction>
	
	<cffunction name="tick">
		<cfset variables.a = getTickCount()>
	</cffunction>
	
	<cffunction name="getHTML" hint ="core function for getting source">
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
</cfcomponent>

