<cfcomponent displayname="FileBrowser" hint="I am an interface for the file system">
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="browse">
		<cfargument name="folder">
		<cfset var local = StructNew()>
		<cfdirectory directory="#folder#" name="local.result">
		<cfreturn local.result>
	</cffunction>
	
	<cffunction name="getdetail">
		<cfargument name="file">
		<cfset var local = StructNew()>
		
		<cfdirectory directory="#folder#" name="local.result" filter="#arguments.file#">
		<cfreturn local.result>
	</cffunction>
	
</cfcomponent>