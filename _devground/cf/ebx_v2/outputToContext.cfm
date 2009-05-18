<cffunction name="test">
	<cfset var Page = getPageContext().getPage()>
	<!--- <cfset var actualPageField = Page.getClass().getDeclaredField("actualPage")>
	<cfset var actualPage = "">
	<cfset var image = ImageNew("http://www.google.com/images/logo_google_suggest.gif")>
	
	<cfset actualPageField.setAccessible(true)>
	<cfset actualPage = actualPageField.get(Page)>
	
	<!--- These are all exactly the same, we get a 4 times blurred image --->
	<cfset actualPage.ImageBlur(image)>
	<cfset variables.actualPage.ImageBlur(image)>
	<cfset Page.ImageBlur(image)>
	<cfset ImageBlur(image)>
	
	<cfimage action="writetobrowser" source="#image#"> --->
</cffunction>