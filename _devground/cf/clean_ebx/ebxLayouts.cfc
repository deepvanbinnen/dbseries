<cfcomponent hint="ebx layouts" extends="AbstractSettings">
	<cfset variables.contentType = "text/html"><!--- Mime type of "Execution" output --->
	
	<cfset addColumn("contentType")>
	
	<cffunction name="init">
		<cfargument name="appPath"     type="string" required="false" default="">
		<cfargument name="rootFolder"  type="string" required="false" default="">
		<cfargument name="contentType" type="string" required="false" default="#variables.contentType#">
		
		<cfset variables.contentType = arguments.contentType>
		
		<cfreturn super.init(arguments.appPath, arguments.rootFolder)>
	</cffunction>
	
	
	<cffunction name="add">
		<cfargument name="name" type="string" required="true">
		<cfargument name="path" type="string" required="true">
		<cfargument name="contentType" type="string" required="false" default="text/html">
		
		<cfif NOT _update(arguments.name, arguments.path, arguments.contentType)>
			<cfset _add(arguments.name, arguments.path, arguments.contentType)>
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addAll">
		<cfargument name="layouts" type="struct" required="true">
		<cfargument name="contentType" type="string" required="false" default="text/html">
		
		<cfset var local = StructNew()>
		<cfloop collection="#arguments.layouts#" item="local.layout">
			<cfset add(local.circuit, arguments.layouts[local.layout], arguments.contentType)>
		</cfloop>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_add">
		<cfargument name="name" type="string" required="true">
		<cfargument name="path" type="string" required="false" default="">
		<cfargument name="contentType" type="string" required="true">
		
		<cfset super._add(arguments.name, arguments.path)>
		<cfset _setContentType(arguments.contentType, getLength())>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="_update">
		<cfargument name="name"        type="string" required="true">
		<cfargument name="path"        type="string" required="false" default="">
		<cfargument name="contentType" type="string" required="false" default="">
		
		<cfif super._update(arguments.name, arguments.path)>
			<cfif arguments.contentType neq "">
				 <cfset _setContentType(arguments.contentType, getLength())>
			</cfif>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="_setContentType">
		<cfargument name="contentType" type="string" required="true">
		<cfargument name="record"      type="numeric" required="true">
		
		<cfset QuerySetCell(getAll(), "contentType", arguments.contentType, arguments.record)>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>