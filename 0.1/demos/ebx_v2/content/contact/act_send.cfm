<cfsavecontent variable="mailtext">
	<cfoutput>
		<cfloop list="#form.fieldnames#" index="field">
			#field#:<br />
			#form[field]#<br />
		</cfloop>
	</cfoutput>
</cfsavecontent>

<cfoutput>#mailtext#</cfoutput>