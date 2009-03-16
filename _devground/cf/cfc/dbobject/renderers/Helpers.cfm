<cffunction name="parseKeyVal">
		<cfargument name="value"  required="false" type="string" default="">
		
		<cfset var local = StructNew()>
		<cfset local.key = arguments.value>
		<cfset local.value = arguments.value>
		
		<cfif ListLen(local.value,"=") gt 1>
			<cfset local.key = ListFirst(local.value,"=")>
			<cfset local.value = ListLast(local.value,"=")>
		</cfif>
		<cfreturn local>
	</cffunction>
	
	<cffunction name="keysToList">
		<cfargument name="argstruct" required="true" type="struct">
		<cfargument name="attrkeys"  required="false" type="string" default="#StructKeyList(arguments.argstruct)#">
		<cfargument name="qualifier" required="false" type="string" default='"'>
		
		<cfset var local  = StructNew()>
		<cfset local.it   = iterator(arguments.attrkeys)>
		<cfset local.args = arguments.argstruct>
		<cfset local.val  = "">
		
		<cfloop condition="#local.it.whileHasNext()#">
			<cfif StructKeyExists(local.args, local.it.current) AND IsSimpleValue(local.it.current)>
				<cfset local.val = ListAppend(local.val, local.it.current & "=" & ListQualify(local.args[local.it.current],arguments.qualifier), " ")>
			</cfif>
		</cfloop>
		<cfreturn local.val>
	</cffunction>
	
	<cffunction name="indexNumberedArgs">
		<cfargument name="collection" required="true" type="any">
		<cfargument name="mergelist"  required="false" type="boolean" default="false">
		
		<cfset var local = StructNew()>
		<cfset local.it  = iterator(arguments.collection)>
		<cfset local.mergelist  = arguments.mergelist>
		<cfset local.tmp = ArrayNew(1)>
		
		<cfset local.args = StructNew()>
		<cfset local.args.map  = StructNew()>
		<cfset local.args.keylist = "">
		
		<cfloop condition="#local.it.whileHasNext()#">
			<cfif IsNumeric(local.it.key)>
				<cfset ArraySet(local.tmp, local.it.key, local.it.key, local.it.current)>	
			</cfif>
		</cfloop>
		
		<cfif local.mergelist>
			<cfset local.tmp = ListToArray(ArrayToList(local.tmp))>
		</cfif>
		<cfset local.it = iterator(local.tmp)>
		<cfloop condition="#local.it.whileHasNext()#">
			<cfset StructInsert(local.args.map, local.it.key, local.it.current, true)>
			<cfset local.args.keylist = ListAppend(local.args.keylist, local.it.current)>
		</cfloop>
		
		<cfreturn local.args>
	</cffunction>
	
	<cffunction name="indexNamedArgs">
		<cfargument name="namedlist"  required="true" type="string">
		
		<cfset var local = StructNew()>
		<cfset local.it  = iterator(arguments.namedlist)>
		<cfset local.args = StructNew()>
		<cfset local.args.map  = StructNew()>
		<cfset local.args.keylist = arguments.namedlist>
		
		<cfloop condition="#local.it.whileHasNext()#">
			<cfset StructInsert(local.args.map, local.it.key, local.it.current, true)>
		</cfloop>
		
		<cfreturn local.args>
	</cffunction>
	
	<cffunction name="indexArgs">
		<cfargument name="argmap"   required="true" type="any">
		<cfargument name="idxstart" required="true" type="numeric" default="0">
		<cfargument name="idxfield" required="false" type="string" default="">
		
		<cfset var out = StructNew()>
		<cfset var local = StructNew()>
		
		<cfset local.argmap   = arguments.argmap>
		<cfset local.idxstart = arguments.idxstart>
		<cfset local.idxfield = arguments.idxfield>
		
		<cfset out.map     = StructNew()>
		<cfset out.keylist = "">
		<cfset out.type    = "">
		
		<cfif numberedArguments(local.argmap, local.idxstart)>
			<cfset out = indexNumberedArgs(local.argmap, true)>
			<cfset out.type = "numbered">
		<cfelseif StructKeyExists(local.argmap, local.idxfield)>
			<cfset out = indexNamedArgs(local.argmap[local.idxfield])>
			<cfset out.type = "named">
		</cfif>
		<cfreturn out>
	</cffunction>
	
	<cffunction name="numberedArguments">
		<cfargument name="argmap"   required="true" type="any">
		<cfargument name="idxstart" required="true" type="numeric" default="0">
		
		<cfreturn StructKeyExists(arguments.argmap, arguments.idxstart)>
	</cffunction>
	
	<cffunction name="structSubtract">
		<cfargument name="struct"  required="true" type="any">
		<cfargument name="keys"    required="true" type="any">
		
		<cfset var local    = StructNew()>
		<cfset local.struct = arguments.struct>
		<cfset local.out    = StructNew()>
		
		<cfset local.it = iterator(arguments.keys)>
		<cfloop condition="#local.it.whileHasNext()#">
			<cfset local.temp = parseKeyVal(local.it.current)>
			<cfif StructKeyExists(local.struct, local.temp.key)>
				<cfset StructInsert(local.out, local.temp.value, local.struct[local.temp.key], true)>
			</cfif>
		</cfloop>
	
		<cfreturn local.out>				
	</cffunction>
	