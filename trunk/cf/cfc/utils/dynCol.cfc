<cfcomponent output="No" displayname="dynCol" hint="Column functions for dynRow">

	<cffunction name="init">
		<cfreturn this>
	</cffunction>

	<cffunction name="setColumns" output="No" returntype="struct" hint="sets columnvalues given a row object">
		<cfargument name="stRow" required="Yes" type="struct">
		<cfargument name="stColumnvalues" required="Yes" type="struct">
		<cfloop collection="#arguments.stColumnvalues#" item="sColumnname">
			<cfset arguments.stRow = this.setRowColValue(arguments.stRow,sColumnname,arguments.stColumnvalues[sColumnname])>
		</cfloop>
		<cfreturn arguments.stRow>
	</cffunction>
	
	<cffunction name="setColumn" output="No" returntype="struct" hint="sets columnvalue in a given row">
		<cfargument name="stRow" required="Yes" type="struct">
		<cfargument name="stColumnname" required="Yes" type="string">
		<cfargument name="stColumnvalue" required="Yes" type="string">
		<cfset arguments.stRow[arguments.stColumnname] = arguments.stColumnvalue>
		<cfreturn arguments.stRow>
	</cffunction>
	
</cfcomponent>