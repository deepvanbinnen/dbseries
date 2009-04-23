DBScript.register(function() {
	this.version = "1.0";
	this.name    = "EventHandler";
	this.src     = "eventhandler.js";
	this.gscope  = false;
	
	this.handlers   = {};
	
	DBScript.addFunctionsToContext( {
		toString : function(){
			return this.name;
		}
	
		, addHandler : function(element, event, func, args, index) {
			var element = DBScript.$(element);
			if(!this.handlers[element]){
				this.handlers[element] = {};
			}
			if(!this.handlers[element][event]){
				this.handlers[element][event] = [];
			}
			if(!index){
				this.handlers[element][event].push({func:func, args:[args]});
			}
			else {
				this.handlers[element][event][index] = {func:func, args:[args]};
			}
		}
		
		, getHandlers : function(element, event) {
			var element = DBScript.$(element);
			return this.handlers[element][event];
		}
		
		, getHandler : function(element, event, index) {
			var element = DBScript.$(element);
			return this.handlers[element][event][index];
		}
		
		, execHandlers : function(element, event) {
			var element = DBScript.$(element);
			var handlers = this.handlers[element][event];
			if(handlers){
				for(var index=0;fn<handlers.length;index++){
					this.executeHandler(element, event, index);
				}
			}
		}
		
		, execHandler : function(element, event, index) {
			var element = DBScript.$(element);
			var handler = this.handlers[element][event][index];
			if(handler){
				handler.func.apply(handler.args);
			}
		}
	
	}, this);
});