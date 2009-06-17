<cfoutput>
	<p>If you have questions or suggestions, please use the form to send us your feedback:</p>
	<form action="#xfa.contact#" method="post">
		<label for="name">Name</label><br />
		<input type="text" name="name" id="name" /><br />
		<label for="email">Email</label><br />
		<input type="text" name="email" id="email" /><br />
		<label for="text">Remarks</label><br />
		<textarea name="text" cols="60" rows="7"></textarea><br />
		<input type="submit" id="send" value="Send" />
	</form>
</cfoutput>