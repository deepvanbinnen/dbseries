<cfcomponent displayname="views" hint="I output views for data">
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getList">
		<cfargument name="data">
		<cfargument name="keys">
		<cfargument name="labels">
		<cfargument name="link">
		
		<cfset var local = StructNew()>
		<cfset local.result = "">
		
		<cfsavecontent variable="local.result">
			<table border="1">
				<thead>
					<tr>
						<cfloop from="1" to="#ArrayLen(arguments.labels)#" index="i">
							<cfoutput><td>#arguments.labels[i]#</td></cfoutput>
						</cfloop>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="arguments.data">
					<tr>
						<cfloop from="1" to="#ArrayLen(arguments.keys)#" index="i">
							<td>#arguments.data[arguments.keys[i]][currentrow]#</td>
						</cfloop>
						<td><a href="#link##id#">detail</a></td>
					</tr>
					</cfoutput>
				</tbody>
			</table>
		</cfsavecontent>

		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getDetail">
		<cfargument name="data">
		<cfargument name="keys">
		<cfargument name="labels">
		
		<cfset var local = StructNew()>
		<cfset local.result = "">
		
		<cfsavecontent variable="local.result">
			<cfoutput query="arguments.data">
				<dl>
				<cfloop from="1" to="#ArrayLen(arguments.labels)#" index="i">
					<dt>#arguments.labels[i]#</dt>
					<dd>#arguments.data[arguments.keys[i]][currentrow]#</dd>
				</cfloop>
				</dl>		
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.result>
	</cffunction>
	
</cfcomponent>