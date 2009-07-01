<cfcomponent extends="AbstractDBIteratorDecorator" hint="object that handles creation of iterators">
	<cffunction name="init" returntype="any"  hint="initialise creation object for iterators">
		<cfif ArrayLen(arguments) GT 1>
			<cfreturn create(arguments[1], arguments[2])>
		<cfelseif ArrayLen(arguments) GT 0>
			<cfreturn create(arguments[1])>
		<cfelse>
			<cfreturn initialise("DBNullIterator")>
		</cfif>
	</cffunction>
	
	<cffunction name="create" returntype="any" hint="create iterator based on collection's datatype">
		<cfargument name="collection" type="any"    required="true"  hint="the collection to create an iterator for">
		<cfargument name="listdelim"  type="string" required="false" default="," hint="the delimiter used for 'SimpleValue' lists, pass in empty string to create a string iterator using Mid()">
	
		<cfif IsArray(arguments.collection)>
			<cfreturn initialise("DBArrayIterator", getArgs(collection=arguments.collection))>
		<cfelseif IsQuery(arguments.collection)>
			<cfreturn initialise("DBQueryIterator", getArgs(collection=arguments.collection))>
		<cfelseif IsStruct(arguments.collection)>
			<cfreturn initialise("DBStructIterator", getArgs(collection=arguments.collection))>
		<cfelseif IsSimpleValue(arguments.collection) AND arguments.listdelim neq "">
			<cfreturn initialise("DBListIterator", getArgs(collection=arguments.collection, listdelim=arguments.listdelim))>
		<cfelseif IsSimpleValue(arguments.collection)>
			<cfreturn initialise("DBStringIterator", getArgs(collection=arguments.collection))>
		<cfelse>
			<cfabort showerror="Unable to create iterator">	
		</cfif>
	</cffunction>
	
	<cffunction name="initialise" returntype="any" hint="instantiate iterator and return it through the decorator">
		<cfargument name="iteratorCFC" type="string" required="true"  hint="iteratror CFC name">
		<cfargument name="initArgs"    type="struct" required="false" default="#StructNew()#"  hint="the argument used to call init">
		
		<cfreturn super.init(this, createObject("component", iteratorCFC).init(argumentCollection = initArgs) )>
	</cffunction>
	
	<cffunction name="getArgs" returntype="any" hint="return given arguments as struct">
		<cfreturn arguments>
	</cffunction>
	
	
</cfcomponent>