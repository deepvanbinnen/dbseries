<cfcomponent output="No" displayname="dynRow" hint="row functions for dynQuery">
	
	<cffunction name="init">
		<cfargument name="qQuery" required="Yes" type="query">
		<cfset this.stEmptyRow = this.createRow(arguments.qQuery)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="createRow" output="No" returntype="struct" hint="creates an empty row object based on this query">
		<cfargument name="qQuery" required="Yes" type="query">
		<cfset var stEmptyRow = StructNew()>
		<cfloop list="#arguments.qQuery.columnlist#" index="col">
			<cfset stEmptyRow[col] = "">
		</cfloop>
		<cfreturn stEmptyRow>
	</cffunction>
	
	<cffunction name="getEmptyRow" output="No" returntype="struct" hint="returns the empty row object">
		<cfreturn Duplicate(this.stEmptyRow)>
	</cffunction>
	
	<cffunction name="setEmptyRowDefaults" output="No" returntype="struct" hint="set default values for the empty row object">
		<cfargument name="stColumnvalues" required="Yes" type="struct">
		<cfloop collection="#arguments.stColumnvalues#" item="sColumnname">
			<cfset this.stEmptyRow[sColumnname] = arguments.stColumnvalues[sColumnname]>
		</cfloop>
		<cfreturn this.getEmptyRow()>
	</cffunction>
	
	
	
	<cffunction name="setRowColumns" output="No" returntype="struct" hint="sets columnvalues given a row object">
		<cfargument name="stRow" required="Yes" type="struct">
		<cfargument name="stColumnvalues" required="Yes" type="struct">
		<cfloop collection="#arguments.stColumnvalues#" item="sColumnname">
			<cfset arguments.stRow = this.setRowColValue(arguments.stRow,sColumnname,arguments.stColumnvalues[sColumnname])>
		</cfloop>
		<cfreturn arguments.stRow>
	</cffunction>
	
	<cffunction name="setRowColValue" output="No" returntype="struct" hint="sets columnvalue in a given row">
		<cfargument name="stRow" required="Yes" type="struct">
		<cfargument name="stColumnname" required="Yes" type="string">
		<cfargument name="stColumnvalue" required="Yes" type="string">
		<cfset arguments.stRow[arguments.stColumnname] = arguments.stColumnvalue>
		<cfreturn arguments.stRow>
	</cffunction>
	
	<cffunction name="copyRow" output="No" returntype="struct" hint="duplicates a given row object">
		<cfargument name="stRow" required="Yes" type="struct">
		<cfreturn Duplicate(arguments.stRow)>
	</cffunction>
	
</cfcomponent>