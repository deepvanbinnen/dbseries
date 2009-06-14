<cfoutput>
	<form method="post" action="#xfa.login#">
		<input type="hidden" name="returl" value="#xfa.returl#">
		<label for="name">Username</label><br />
		<input type="text" name="name" id="name" /><br />
		<label for="pass">Password</label><br />
		<input type="password" name="pass"     id="pass" /><br />
		<input type="submit"   name="btnlogin" id="name" />
	</form>
</cfoutput>