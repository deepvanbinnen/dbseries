<cfset utils = createObject("component", "cfc.db.utils").init()>

<cfset myvarstring = "user string false aap,id numeric">
<cfset varstring = utils.d2a(myvarstring)>
<cfdump var="#varstring#">

<cfset mystruct = utils.p2s(instring="name=testMethod,rettype=numeric",extended=true)>


<cfdump var="#mystruct#">


<cfset methodstring = "getCounter name,dob=13/10/1977,email=deepak@e-vision.nl numeric">
<cfset methodkeys = "name,params,rettype,retval,locals">
<cfset method = utils.a2s( utils.d2a(methodstring), methodkeys, utils.emptyMethod())>
<cfdump var="#method#">
<cfif method.params neq "">
	<cfset params = utils.p2s(method.params, true)>
	<cfset it = utils.iterator(params)>
	<cfloop condition="#it.whileHasNext()#">
		<cfset p = utils.emptyParam()>
		<cfset p.name     = it.key>
		<cfset p.default  = it.current.value>
		<cfset p.required = (NOT it.current.ispair)>
		<cfdump var="#p#"> 
	</cfloop>
</cfif>

<cfset keys = "name,params,rettype,retval,locals">

<cfdump var="##">


<cfoutput><p>#CHR(43)# #CHR(64)#</p></cfoutput>

<cfsavecontent variable="varstring">
name string
id string false
</cfsavecontent>

<cfsavecontent variable="varprivate">
id string 
internal_id string
session_id string
session_token numeric false 0
counter numeric false 0
</cfsavecontent>

<cfsavecontent variable="varmethods">
@getCounter counter,internal_id= numeric variables.counter
@getNameFromId id string this.name
@getInternalId id= string variables.internal_id
</cfsavecontent>
<cfset mygen = createObject("component","CFCGenerator").init("myComponent", varstring, varprivate, TRIM(varmethods),true,true,"name")>


<cfoutput>
	
<p><cfdump var="#mygen.parsePair("x")#"></p>
<p>Name set: #mygen.getName()#</p>

<p>Process Public getter/setter vars from:</p>
<pre>#mygen.getPublic_gsv()#</pre>
<cfset public_vars = mygen.parseDelimitedString(mygen.getPublic_gsv())>
<cfset private_vars = mygen.parseDelimitedString(mygen.getPrivate_gsv())>

<cfset vardefs = mygen.setScopeVars(public_vars, "this")>
<cfset vardefs = mygen.setScopeVars(private_vars, "variables")>

<cfset other_methods = mygen.parseDelimitedString(mygen.getOther_methods(),"@")>
<cfset mygen.parseMethods(other_methods)>


<cfset x = mygen.getComponentOutput()>
<cfoutput><textarea cols="120" rows="80">#x.body#</textarea></cfoutput>

<!--- <cfdump var="#mygen.getKnownVars()#"> --->

</cfoutput>

<cfdump var="#mygen#">
