<cfcomponent name="dbSQL" hint="create usefull SQL statements for use with dbobject">
	<cfset variables.dbtable   = "">
	<cfset variables.dbo       = "">
	
	<cffunction name="init">
		<cfargument name="dbtable" required="true" type="dbtable">
		<cfset variables.dbtable   = arguments.dbtable>
		<cfset variables.dbo       = variables.dbtable.getDBO()>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="execSQL">
		<cfset var local = StructNew()>
		
		<cfquery name="Local.q" datasource="#variables.dbo.getDS()#">
		SELECT #variables.dbtable.getSelect()#
		FROM   #getFROM()#
		</cfquery>
		
		<cfreturn local.q>
	</cffunction>
	
	<cffunction name="getFROM">
		<cfset var Local = StructNew()>
		
		<cfset local.joins = variables.dbtable.getJoins()>
		<cfset local.from = variables.dbtable.getName()>
		
		<cfloop from="1" to="#ArrayLen(local.joins)#" index="local.i" step="3">
			<cfsavecontent variable="local.from">
				<cfoutput>
						#local.from# LEFT JOIN #local.joins[local.i]#
					ON #local.joins[local.i+1]# = #local.joins[local.i+2]#
				</cfoutput>
			</cfsavecontent>
		</cfloop>
		<cfreturn local.from>
	</cffunction>
	
	
	
</cfcomponent>