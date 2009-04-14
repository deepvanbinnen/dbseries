DBScript.register(function() {
	this.version = "1.0";
	this.name    = "Keyboard";
	this.src     = "keyboard.js";
	this.gscope  = false;
	
	var self = this;
	
	DBScript.addFunctionsToContext( {
		init : function() {}
	
	}, this.constructor.prototype);
}, false, "Keyboard");