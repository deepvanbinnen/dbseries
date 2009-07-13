<cfcomponent>
	
	
	
	<cffunction name="_dump" access="public" output="false" returntype="struct">
		<cfset var i = "">
		<cfset var j = "">
		<cfset var tmp ="">
		<cfset var ret = structnew()>
		<cfloop collection="#this#" item="i">
			<cfif lcase(left(i, 3)) EQ "get">
				<cfinvoke component="#this#" method="#i#" returnvariable="tmp"/>
				<!--- if its an object, call its _dump() method --->
				<cfif isObject(tmp)>
					<cfset tmp = tmp._dump()>
				<!--- if its an array, call each elements dump method in turn --->
				<cfelseif _isCFC(tmp) AND structkeyexists(tmp[1], "_dump")>
					<cfloop from="1" to="#arraylen(tmp)#" index="j">
						<cfset tmp[j] = tmp[j]._dump()>
					</cfloop>
				</cfif>
				<cfset ret[replacenocase(i, "get", "")] = tmp>
			</cfif>
		</cfloop>
		<cfreturn ret />
	</cffunction>
	
</cfcomponent>