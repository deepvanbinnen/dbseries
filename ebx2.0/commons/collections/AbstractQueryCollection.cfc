<cfcomponent extends="Collection" hint="Abstract query collection object">
	<cffunction name="_add" output="false" hint="add data to query">
		<cfargument name="data" type="any"    required="true">
		<cfargument name="cols" type="string" required="false">
		<cfargument name="key"  type="string" required="false" default="">

		<cfset var local = StructNew()>

		<cfif IsArray(arguments.data) AND ArrayLen(arguments.data) eq ListLen(arguments.cols)>
			<cfset _setQueryRow(arguments.data, arguments.cols)>
		<cfelseif IsStruct(arguments.data)>
			<cfset _setQueryRow( argumentCollection = structAsQueryRowArrays( arguments.data ))>
		<cfelseif IsSimpleValue(arguments.data)>
			<cfset _setQueryRow(_listAsArray(arguments.data, arguments.key))>
		</cfif>

		<cfreturn this>
	</cffunction>

	<cffunction name="_addAll" output="false" hint="add all data to array">
		<cfargument name="data" type="any" required="true">

		<cfset var local = StructNew()>
		<cfif IsQuery(arguments.data)>
			<cfloop query="arguments.data">
				<cfset _setQueryRow(_queryAsQueryRowArrays(arguments.data, currentrow)) />
			</cfloop>
		<cfelseif IsStruct(arguments.data)>
			<cfset _add(arguments.data)>
		<cfelseif IsArray(arguments.data) AND ArrayLen(arguments.data)>
			<cfloop	from="1" to="#ArrayLen(arguments.data)#" index="local.i">
				<cfif IsStruct(arguments.data[local.i])>
					<cfset _add(arguments.data[local.i])>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn this>
	</cffunction>

	<cffunction name="_createPointer" returntype="any" hint="create a pointer for this collection">
		<cfargument name="columns" required="false"  type="string" hint="The columnlist in the pointer" />
		<cfif NOT StructKeyExists(arguments, "columns")>
			<cfset arguments.columns = _getKeys() />
		</cfif>
		<cfreturn ObjectCreate("cfc.commons.collections.QueryPointer").init( _getCollection(), arguments.columns )>
	</cffunction>

	<cffunction name="_createIterator" output="false" hint="create the iterator for this collection">
		<cfreturn ObjectCreate("cfc.commons.collections.QueryIterator").init( createPointer() )>
	</cffunction>

	<cffunction name="_get">
		<cfargument name="index"   required="true"  type="numeric" default="1" hint="The columnlist in the pointer" />
		<cfargument name="keylist" required="false"  type="string" />

		<cfif NOT StructKeyExists(arguments, "keylist")>
			<cfset arguments.keylist = _getKeys() />
		</cfif>
		<cfif ListLen(arguments.keylist) EQ 1>
			<cfreturn _getCell(arguments.keylist, arguments.index) />
		<cfelse>
			<cfreturn _rowAsStruct(row=arguments.index, cols=arguments.keylist) />
		</cfif>
	</cffunction>

	<cffunction name="_getByIndex">
		<cfargument name="indexkey" type="numeric" required="false" default="#size()#" hint="rownumber defaults to last row">
		<cfargument name="keys"     type="any"     required="false" default="#getKeys()#" hint="list of columns or struct with columnnames mapped to aliasnames">

		<cfset var local = StructCreate(result = "")>
		<cfif arguments.indexkey LTE size()>
			<cfset local.iter = iterator(arguments.keys)>
			<cfif local.iter.getLength() GT 1>
				<cfset local.result = StructCreate()>
				<cfloop condition="#local.iter.whileHasNext()#">
					<cfset StructInsert(local.result, local.iter.getCurrent(), getCell(local.iter.getKey(), arguments.indexkey), TRUE)>
				</cfloop>
				<cfif StructIsEmpty(local.result)>
					<cfset local.result = "">
				</cfif>
			<cfelse>
				<cfset local.result =  getCell(arguments.keys, arguments.indexkey)>
			</cfif>
		</cfif>

		<cfreturn local.result>
	</cffunction>

	<cffunction name="_getCell" hint="gets a cell from the collection">
		<cfargument name="column" required="true" type="string">
		<cfargument name="row"    required="false" type="numeric" default="#size()#">

		<cfset var local = StructNew() />
		<cfif arguments.row LTE size() AND hasKey(arguments.column)>
			<cfset local.data = getData() />
			<cfreturn local.data[arguments.column][arguments.row]>
		</cfif>
		<cfreturn "" />
	</cffunction>

	<cffunction name="_getKeys">
		<cfreturn getData().columnlist>
	</cffunction>

	<cffunction name="_hasKey">
		<cfargument name="key" type="string" required="true" hint="check if column exists">

		<cfreturn ListFindNoCase(getKeys(), arguments.key)>
	</cffunction>

	<cffunction name="_hasIndex" output="false" returntype="boolean" hint="verify if index is valid, this does not check if value at index might be null!">
		<cfargument name="index" type="numeric" required="true" />
		<cfreturn arguments.index GT 0 AND arguments.index LTE getData().recordcount />
	</cffunction>

	<cffunction name="_lastIndexOf" output="false" hint="finds the last index of an element, this is a JAVA hack!">
		<cfargument name="value" type="any" required="true" />
		<cfreturn getData().lastIndexOf(arguments.value)>
	</cffunction>

	<cffunction name="_indexOf" output="false" hint="finds the index for a value, this is a JAVA hack!">
		<cfargument name="value" type="any" required="true" />
		<cfreturn getData().indexOf(arguments.value)>
	</cffunction>

	<cffunction name="_isEmpty" output="false" hint="check emptyness data">
		<cfreturn getData().recordcount EQ 0 />
	</cffunction>

	<cffunction name="_remove" hint="finds the index for a value, this is a JAVA hack!">>
		<cfargument name="indexkey" type="string" required="true">

		<cfif IsNumeric(arguments.indexkey) AND arguments.indexkey LTE getData().recordcount>
			<cfset getData().RemoveRows(arguments.indexkey-1, 1)>
		</cfif>

		<cfreturn this />
	</cffunction>

	<cffunction name="_removeAll" output="false" hint="Removes all by value. This is a JAVA hack!">
		<cfargument name="data" type="array" required="true" />
			<cfset getData().removeAll( arguments.data )>
		<cfreturn this>
	</cffunction>

	<cffunction name="_removeElementAt" output="false" hint="Removes by index.">
		<cfargument name="index" type="numeric" required="true" />
			<cfset ArrayDeleteAt(getData(), arguments.index) />
		<cfreturn this>
	</cffunction>

	<cffunction name="_removeElementsAt" output="true" hint="Removes by list of indices.">
		<cfargument name="indexlist" type="string" required="true" hint="list of indexes to remove" />
		<cfargument name="delimiter" type="string" required="false" default="," />

		<cfset var local = StructNew()>
		<!---
			Since the remove operation modifies the array
			this might cause the index to be another element
			than the expected one.

			To prevent issues with this behaviour start removal
			by index from the end of the array so that the index item
			to remove is actually the one you did mean to remove.

			Example:
			orgArr = ['a','b','c','d','e','f'] // the original array
			removeIndexes = (3,5) // indexes to remove
			destArr = ['a','b','d','f'] // the destination array (what the result should be)

			just processing the list causes:
			1) orgArr with index 3 removed is: ['a','b','d','e','f']
			2) orgArr with index 5 removed is: ['a','b','d','e']
			3) thus destArr=['a','b','d','e'] is wrong!

			after resorting the list descending, processing causes:
			1) orgArr with highest index 5 removed is: ['a','b','c','d','f']
			2) orgArr with next highest index 3 removed is: ['a','b','d','f']
			3) thus destArr=['a','b','d','f'] is correct!

		--->
		<cfset local.list = ListSort(arguments.indexlist, "numeric", "desc", arguments.delimiter)>
		<cfloop list="#local.list#" index="local.index">
			<cfif IsNumeric(local.index) AND local.index GT 0 AND local.index LTE ArrayLen( getData() )>
				<cfset ArrayDeleteAt( getData(), local.index )>
			</cfif>
		</cfloop>

		<cfreturn this>
	</cffunction>

	<cffunction name="_retainAll" output="false" hint="this is a JAVA hack!">
		<cfargument name="data" type="array" required="true" />
		<cfreturn getData().retainAll(arguments.data)>
	</cffunction>

	<cffunction name="_retainElementsAt" output="false" hint="this is a JAVA hack!">
		<cfargument name="indexlist" type="string" required="true" />
		<cfargument name="delimiter" type="string" required="false" default="," />

		<cfset var local = StructNew()>
		<cfset local.arr = getData() />
		<cfset local.retain = ArrayNew(1) />
		<cfloop list="#local.indexlist#" index="local.index" delimiters="#arguments.delimiter#">
			<cfif IsNumeric(local.index) AND local.index GT 0 AND local.index LTE ArrayLen( getData() )>
				<cfset ArrayAppend(local.retain, local.arr[local.index] ) />
			</cfif>
		</cfloop>
		<cfset getData().retainAll(local.retain) />
		<cfreturn this>
	</cffunction>

	<cffunction name="_set">
		<cfargument name="data" type="any"     required="true">
		<cfargument name="cols" type="string"  required="false">
		<cfargument name="row"  type="numeric" required="false" default="0">
		<cfargument name="delimiter" type="string" required="false" default=",">

		<cfif NOT StructKeyExists(arguments, "cols")>
			<cfset arguments.cols = getKeys() />
		</cfif>

		<cfif IsArray(arguments.data) AND ArrayLen(arguments.data) eq ListLen(arguments.cols)>
			<cfset _setQueryRow(arguments.data, arguments.cols, arguments.row) />
		<cfelseif IsStruct(arguments.data)>
			<cfset _setQueryRow( argumentCollection = structAsQueryRowArrays( arguments.data ), row=arguments.row) />
		<cfelseif IsSimpleValue(arguments.data)>
			<cfset _setQueryRow(_listAsArray(arguments.data, arguments.key), arguments.cols, arguments.row) />
		</cfif>

		<cfreturn this>
	</cffunction>

	<cffunction name="_size">
		<cfreturn getData().recordcount>
	</cffunction>

	<cffunction name="_slice" hint="take a slice out of a list">
		<cfargument name="list"  required="true" type="string">
		<cfargument name="start" required="false" type="numeric" default="0">
		<cfargument name="end"   required="false" type="numeric" default="#ListLen(arguments.list)#">

		<cfset var local = StructNew()>
		<cfset local.arr = ListToArray(arguments.list)>
		<cfif arguments.end GT ListLen(arguments.list)>
			<cfset arguments.end = ArrayLen(local.arr)>
		</cfif>
		<cfreturn ArrayToList(local.arr.subList(arguments.start, arguments.end))>
	</cffunction>

	<cffunction name="_setQueryRow" output="false" hint="set query row">
		<cfargument name="data" type="array" required="true">
		<cfargument name="cols" type="array" required="false" default="#getKeys()#">
		<cfargument name="row"  type="numeric" required="false" default="0">

		<cfif ArrayLen(arguments.data) EQ ArrayLen(arguments.cols)>
			<cfif arguments.row eq 0>
				<cfset QueryAddRow( getData() )>
				<cfset arguments.row = getData().recordcount>
			</cfif>
			<cfif arguments.row LTE getData().recordcount>
				<cfloop from="1" to="#ArrayLen(arguments.data)#" index="local.i">
					<cfif NOT hasKey( arguments.cols[local.i] )>
						<cfset QueryAddColumn(getData(), arguments.cols[local.i], ArrayNew(1))>
					</cfif>
					<cfset QuerySetCell(getData(), arguments.cols[local.i], arguments.data[local.i], arguments.row)>
				</cfloop>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="_queryAsQueryRowArrays" output="false" hint="returns struct with keys and values as arrays. keys are in result.cols and values are in result.data">
		<cfargument name="data" type="query"  re quired="true">
		<cfargument name="row"  type="numeric" required="true">

		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		<cfset local.result.data = ArrayNew(1)>
		<cfset local.result.cols = ArrayNew(1)>
		<cfif arguments.row LTE arguments.data.recordcount AND arguments.row GT 0>
			<cfloop collection="#arguments.data.columnlist#" item="local.key">
				<cfset ArrayAppend(local.result.cols, local.key)>
				<cfset ArrayAppend(local.result.data, arguments.data[local.key][arguments.row]) />
			</cfloop>
		</cfif>

		<cfreturn local.result />
	</cffunction>

	<cffunction name="_rowAsArray" output="false" hint="row as array usefull for duplicating">
		<cfargument name="row"   type="numeric" required="true">
		<cfargument name="query" type="query" required="false" default="#getData()#">

		<cfset var local = StructNew()>
		<cfset local.result = ArrayNew(1)>
		<cfloop list="#arguments.query.columnlist#" index="local.col">
			<cfset ArrayAppend(local.result, arguments.query[local.col][arguments.row])>
		</cfloop>

		<cfreturn local.result>
	</cffunction>

	<cffunction name="_rowAsStruct" output="false" hint="row as array">
		<cfargument name="row"  type="numeric" required="true">
		<cfargument name="query" type="query" required="false">
		<cfargument name="cols"  type="string" required="false">

		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		<cfif NOT StructKeyExists(arguments, "query")>
			<cfset arguments.query = getData() />
		</cfif>
		<cfif NOT StructKeyExists(arguments, "cols")>
			<cfset arguments.cols = arguments.query.columnlist />
		</cfif>
		<cfloop list="#arguments.cols#" index="local.col">
			<cfset StructInsert(local.result, local.col, arguments.query[local.col][arguments.row], true) />
		</cfloop>

		<cfreturn local.result>
	</cffunction>


	<cffunction name="_structAsQueryRowArrays" output="false" hint="returns struct with keys and values as arrays. keys are in result.cols and values are in result.data">
		<cfargument name="data" type="struct" required="true">

		<cfset var local = StructNew()>
		<cfset local.result = StructNew()>
		<cfset local.result.data = ArrayNew(1)>
		<cfset local.result.cols = ArrayNew(1)>
		<cfloop collection="#arguments.data#" item="local.key">
			<cfset ArrayAppend(local.result.cols, local.key)>
			<cfset ArrayAppend(local.result.data, arguments.data[local.key])>
		</cfloop>

		<cfreturn local.result />
	</cffunction>
</cfcomponent>