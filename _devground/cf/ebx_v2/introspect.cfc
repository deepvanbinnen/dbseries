<cfcomponent displayname="introspect" hint="">
	<cfset this.context  = getPageContext()>
	<cfset this.servlet  = this.context.getServletContext()>
	<cfset this.request  = this.context.getRequest()>
	<cfset this.response = this.context.getResponse()>
	<cfset this.writer   = this.context.getOut()>
	
	<cffunction name="init">
		<cfreturn this>
	</cffunction>

	<cffunction name="getContextPath">
		<cfreturn this.servlet.getContextPath()>
	</cffunction>
	
	<cffunction name="getServletPath">
		<cfreturn this.request.getServletPath()>
	</cffunction>
	
	<cffunction name="getRequestURL">
		<cfreturn this.request.getRequestURL()>
	</cffunction>
	
	<cffunction name="getPathTranslated">
		<cfreturn this.request.getPathTranslated()>
	</cffunction>
	
	
	<cffunction name="flush">
		<cfreturn this.writer.flush()>
	</cffunction>
	
	<cffunction name="clearBuffer">
		<cfreturn this.writer.clearBuffer()>
	</cffunction>
	
	<cffunction name="_dumpCurr">
		<cfoutput>
			Context path: #getContextPath()#<br />
			Request URL: #getRequestURL()#<br />
			Servlet path: #getServletPath()#
		</cfoutput>
	</cffunction>

</cfcomponent>