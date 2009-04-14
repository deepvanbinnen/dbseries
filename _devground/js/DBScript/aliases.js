DBScript.register(function () {
	this.version = "1.0";
	this.name    = "Alias";
	this.src     = "";
	this.gscope  = false; // if true appends class functions to global scope so that they can be called directly
	
	DBScript.addFunctionsToContext({
		  getName : function(){alert(this.name);}	
		, getAlias : function(){alert(a);}
	}, this.constructor.prototype);
});

	
