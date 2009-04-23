DBScript.register(function () {
	this.version = "1.0";
	this.name    = "Alias";
	this.src     = "";
	this.gscope  = false; // if true appends class functions to global scope so that they can be called directly
	
	var self = this;
	
	self._setName = function(name) {
		self._name = name;
	}
	
	self._getName = function() {
		alert(self._name);
	}
	
	DBScript.addFunctionsToContext({
		getName : function(){
		    this._getName();
		}	
		, setName : function(name){
			this._setName(name);
		}
	}, this);
});

	
