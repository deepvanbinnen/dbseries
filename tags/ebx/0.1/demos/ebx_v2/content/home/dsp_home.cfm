WHAT IT IS
----------------------------------------------------------------
e-Box is a request parser highly inspired by the Fusebox framework (http://www.fusebox.org) and originated from finding a way to use fusebox methodology in a non-fusebox environment.  

It's default behaviour is to extract a full-qualified action from known attributes, parse the action, look up the relative directory 
from which to include the switchfile, include the switchfile and finally parse that output through a layoutfile.

The box has similar behaviour of Fusebox5 features "do" and "include", which means you can customise attributes and store/assign output per action/include.

A postplugin array can be filled during request with custom files to include after execution of the mainrequest.

The form- and url scopes are converted to attributes on initialisation of the request, but this behaviour can be overridden.

COPYRIGHT AND LICENCE
----------------------------------------------------------------
See LICENSE file that came with the source. 

AUTHOR
----------------------------------------------------------------
This software was written by Bharat Deepak Bhikharie.  

INSTALLATION
----------------------------------------------------------------
Copy the CFCs to a location where the CFCs can be accessed by ColdFusion as components.
Copy the contents of "empty-box" to your own   

NOTES: 
 * It is important that the ebx-instance matches the structname used in ebx_circuits. (e.g. request.ebx vs request.ebx.circuits) 
 * The instance of the parser must be placed in a scope accesible by the cfc in order to update the instance properties correctly. 
 
EXAMPLES AND DEMO
----------------------------------------------------------------
Look at the demos source for examples.

CHANGELOG
----------------------------------------------------------------
Version 0.1  Jun 14, 2009
* Initial public setup
* Provided hints for all methods and arguments
* Licensing



