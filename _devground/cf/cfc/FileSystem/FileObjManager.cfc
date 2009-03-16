<cfcomponent name="FileObjManager">
	<cfset variables.absroot = "">
	<cfset variables.webroot = "">
	
	<cfset this.files   = ArrayNew(1)>
	<cfset this.fmap    = StructNew()>
	<cfset this.folders = ArrayNew(1)>
	<cfset this.selected = "">
	<cfset this.folder   = "/">
	<cfset this.filters  = "*">
		
	<cffunction name="init" output="No" returntype="FileObjManager">
		<cfargument name="absroot"  type="any" required="true">
		<cfargument name="webroot"  type="any" required="true">
		<cfargument name="folder"   type="string" required="false" default="#this.folder#">
		<cfargument name="selected" type="string" required="false" default="#this.selected#">
		
		<cfset var local = StructNew()>
		<cfset _setAbsRoot(arguments.absroot)>
		<cfset _setWebRoot(arguments.webroot)>
		<cfset _setFolder(arguments.folder)>
		<cfset _setFiles()>
		
		<cfif arguments.selected neq "">
			<cfset _setSelected(arguments.selected)>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getFolderRoot" output="No">
		<cfreturn _getAbsroot() & getFolder()>
	</cffunction>
	
	<cffunction name="getWebRoot" output="No">
		<cfreturn _getWebRoot() & getFolder()>
	</cffunction>
	
	<cffunction name="getFolder" output="No">
		<cfreturn _cleanFolderString(this.folder)>
	</cffunction>
	
	<cffunction name="getFolderUp" output="yes">
		<cfset var local = StructNew()>
		<cfset local.folder = getFolder()>
		<cfif local.folder neq "/">
			<cfset local.folder = ListToArray(local.folder,"/")>
			<cfset ArrayDeleteAt(local.folder, ArrayLen(local.folder))>
			<cfreturn _cleanFolderString(ArrayToList(local.folder,"/"))>
		</cfif>
		<cfreturn "">
	</cffunction>
	
	<cffunction name="setFolder" output="No">
		<cfargument name="folder" type="string" required="false" default="/">
		<cfreturn _setFolder(arguments.folder)>
	</cffunction>
	
	<cffunction name="getFilters" output="No">
		<cfreturn this.filters>
	</cffunction>
	
	<cffunction name="setFilter" output="No">
		<cfargument name="filter" type="string" required="true">
		<cfset _addFilter(arguments.filter)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_addFilter" output="No">
		<cfargument name="filter" type="string" required="false" default="">
		<cfif arguments.filter eq "">
			<cfset this.filters = "*">
		<cfelseif this.filters eq "*">
			<cfset this.filters = arguments.filter>
		<cfelseif NOT ListFind(this.filters,arguments.filter)>
			<cfset this.filters = ListAppend(this.filters,arguments.filter)>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_cleanFolderString" output="No">
		<cfargument name="folder" type="string" required="false" default="/">
		<cfset var local = StructNew()>
		<cfset local.folder = arguments.folder>
		<cfif local.folder eq "">
			<cfset local.folder = "/">
		<cfelseif LEFT(local.folder,"1") neq "/">
			<cfset local.folder = "/" & local.folder>
		</cfif>
		<cfif RIGHT(local.folder,"1") neq "/">
			<cfset local.folder = local.folder & "/">
		</cfif>
		<cfreturn local.folder>
	</cffunction>
	
	<cffunction name="uploadFile" output="No">
		<cfargument name="formfield" type="string" required="true" hint="the NAME of the formfield">
		<cffile action="upload" filefield="#arguments.formfield#" destination="#getFolderRoot()#" nameconflict="makeunique">
		<cfset refresh()>
		<cfset _setSelected(cffile.ServerFile)>
	</cffunction>
	
	<cffunction name="getFile" output="No">
		<cfargument name="name" type="any" required="true">
		<cfreturn this.files[this.fmap[arguments.name]]>
	</cffunction>
	
	<cffunction name="getFiles" output="No">
		<cfreturn this.files>
	</cffunction>
	
	<cffunction name="size">
		<cfreturn ArrayLen(this.files)>
	</cffunction>
	
	<cffunction name="refresh">
		<cfset this.files   = ArrayNew(1)>
		<cfset this.fmap    = StructNew()>
		<cfset this.folders = ArrayNew(1)>
		<cfset _setFiles()>
	</cffunction>
	
	<cffunction name="getSelected" output="No">
		<cfreturn this.selected>
	</cffunction>
	
	<cffunction name="hasSelection" output="No">
		<cfreturn IsObject(this.selected)>
	</cffunction>
	
	<cffunction name="_setFolder" output="No">
		<cfargument name="folder" type="string" required="false" default="/">
		<cfset this.folder = _cleanFolderString(arguments.folder)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_setFiles" output="yes">
		<cfset var local = StructNew()>
		<cfset local.directoryContent = _getFilteredListing()>
		<cfloop query="local.directoryContent">
			<cfset ArrayAppend(this.files, createObject("component", "FileObj").init(getFolderRoot(), name, (type eq "dir"), size, getWebroot()))>
			<cfset StructInsert(this.fmap, name, this.size())>
			<cfset ArrayAppend(this.folders, name)>
		</cfloop>
	</cffunction>
	
	<cffunction name="_getFilteredListing" output="yes">
		<cfset var qDirContent = "">
		<cfset var qDirQuery = "">
		<cfset var qFileQuery = "">
		
		<cfdirectory action="list" name="qDirContent" directory="#getFolderRoot()#" sort="type,name">
		<cfquery name="qDirQuery" dbtype="query">
		SELECT *
		FROM qDirContent
		WHERE (type = 'Dir')
		</cfquery>
		
		<cfquery name="qFileQuery" dbtype="query">
		SELECT *
		FROM qDirContent
		WHERE (type = 'File')
		</cfquery>
		
		<cfquery name="qDirContent" dbtype="query">
			SELECT *
			FROM qDirQuery
		UNION
			SELECT *
			FROM qFileQuery
		ORDER BY
			type, name
		</cfquery>
		<cfreturn qDirContent>
	</cffunction>
	
	<cffunction name="_setSelected" output="No">
		<cfargument name="selectedfile" type="any" required="true">
		<cfset this.selected = getFile(arguments.selectedfile)>
	</cffunction>
	
	<cffunction name="_getAbsRoot" output="No">
		<cfreturn variables.absroot>
	</cffunction>
	
	<cffunction name="_setAbsRoot" output="No">
		<cfargument name="absroot" type="any" required="true">
		<cfset variables.absroot = arguments.absroot>
	</cffunction>
	
	<cffunction name="_getWebRoot" output="No">
		<cfreturn variables.webroot>
	</cffunction>
	
	<cffunction name="_setWebRoot" output="No">
		<cfargument name="webroot" type="any" required="true">
		<cfset variables.webroot = arguments.webroot>
	</cffunction>
	
	
</cfcomponent>
