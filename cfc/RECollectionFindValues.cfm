<!--- 
Author: Bharat Deepak Bhikharie
Date: 14-07-2009
Tested on: OpenBlueDragon 1.1

After seeing Ben Nadel's function to search an array or struct for value filtered on regex, 
recreated it using DBIterator which takes an arbitrary collection.
Added depth and maxdepth to constrain the search.

Related post: 
http://www.bennadel.com/blog/1635-REStructFindValue-Adding-Regular-Expression-Searching-To-StructFindValue-.htm
--->

<cffunction name="reCollectionFindValues" output="false" returntype="array" hint="recursively regex-search collection for matching values">
	<cfargument name="collection" type="any"     required="true"  hint="target collection">
	<cfargument name="pattern"    type="string"  required="true"  hint="regex pattern">
	<cfargument name="scope"      type="string"  required="false" hint="return single match or all matches, defaults to all" default="all">
	<cfargument name="maxdepth"   type="numeric" required="false" hint="maximum depth for search (exclusive) default to -1 which keeps digging" default="-1">
	<cfargument name="path"       type="string"  required="false" hint="matched item's path in original collection" default="">
	<cfargument name="depth"      type="numeric" required="false" hint="current depth for original search" default="0">
	
	<!--- Create iterator for collection --->
	<cfset var it = createObject("component", "dbseries.trunk.cfc.DBIterator.DBIterator").init(arguments.collection)>
	<cfset var local = StructNew()>
	
	<cfset local.result = ArrayNew(1)>
	<!--- depth check --->
	<cfif arguments.maxdepth eq -1 OR arguments.depth LT arguments.maxdepth>
		<!--- loop and find --->
		<cfloop condition="#it.whileHasNext()#">
			<!--- set path --->
			<cfset local.path  = arguments.path & "[""" & it.key & """]">
			<!--- check simplevalue --->
			<cfif isSimpleValue(it.current)>
				<!--- match value --->
				<cfif REFindNoCase(arguments.pattern, it.current)>
					<!--- add result --->
					<cfset local.item = StructNew()>
					<cfset local.item.key   = it.key>
					<cfset local.item.value = it.current>
					<cfset local.item.owner = it.getCollection()>
					<cfset local.item.path  = local.path>
					<cfset ArrayAppend(local.result, local.item)>
					<!--- break if scope is one, because we have found the One ;) --->
					<cfif arguments.scope eq 'one'>
						<cfbreak>
					</cfif>
				</cfif>
			<cfelse>
				<!--- break if scope is one and we have a result --->
				<cfif arguments.scope eq 'one' AND ArrayLen(local.result)>
					<cfbreak>
				</cfif>
				<!--- Concat searchresults for collection-value with results  --->
				<cfset local.result.addAll(reCollectionFindValues(it.current, arguments.pattern, arguments.scope, arguments.maxdepth, local.path, arguments.depth+1))>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn local.result>
</cffunction>

<!--- Ben's original struct --->
<cfset myData = StructNew()>
<cfset myData.hotGirls = ArrayNew(1)>
<cfset myData.hotGirls[1] = StructNew()>
<cfset myData.hotGirls[1].name = "Tricia">
<cfset myData.hotGirls[1].hair = "Brunette">
<cfset myData.hotGirls[2] = StructNew()>
<cfset myData.hotGirls[2].name = "Kim">
<cfset myData.hotGirls[2].hair = "Blonde">
<cfset myData.hotGirls[3] = StructNew()>
<cfset myData.hotGirls[3]["athleticGirls"] = ArrayNew(1)>
<cfset myData.hotGirls[3]["athleticGirls"]["1"] = StructNew()>
<cfset myData.hotGirls[3]["athleticGirls"]["1"].name = "Tricia">
<cfset myData.hotGirls[3]["athleticGirls"]["1"].hair = "Brunette">
<cfset myData.hotGirls[3]["athleticGirls"]["2"] = StructNew()>
<cfset myData.hotGirls[3]["athleticGirls"]["2"].name = "Jen">
<cfset myData.hotGirls[3]["athleticGirls"]["2"].hair = "Black">
<cfset myData.hotGirls[4] = StructNew()>
<cfset myData.hotGirls[4].name = "Michelle">
<cfset myData.hotGirls[4].hair = "Brunette">

<strong>Original Structure:</strong><br />
<cfdump var="#myData#" />
 
<br /><br />

<strong>Results:</strong><br />
<cfset results = reCollectionFindValues(myData, "brunette|brown|black", "all", 4) />
<cfdump var="#results#" />
