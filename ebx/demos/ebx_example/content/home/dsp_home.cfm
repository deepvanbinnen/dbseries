<h1>WHAT IT IS</h1>

<p>e-Box is a request parser highly inspired by the Fusebox framework (http://www.fusebox.org) and originated from finding a way to use fusebox methodology in a non-fusebox environment.  </p>

<p>It's default behaviour is to extract a full-qualified action from known attributes, parse the action, look up the relative directory 
from which to include the switchfile, include the switchfile and finally parse that output through a layoutfile.
</p>
<p>The box has similar behaviour of Fusebox5 features "do" and "include", which means you can customise attributes and store/assign output per action/include.
</p>
<p>A postplugin array can be filled during request with custom files to include after execution of the mainrequest.
</p>
<p>The form- and url scopes are converted to attributes on initialisation of the request, but this behaviour can be overridden.
</p>

<h2>INSTALLATION</h2>
<p>Copy the CFCs to a location where the CFCs can be accessed by ColdFusion as components.
Copy the contents of "empty-box" to your own  directory</p> 

<h2>NOTES:</h2> 
<ul>
	<li>It is important that the ebx-instance matches the structname used in ebx_circuits. (e.g. request.ebx vs request.ebx.circuits)</li>
	<li>The instance of the parser must be placed in a scope accesible by the cfc in order to update the instance properties correctly</li> 
</ul>


