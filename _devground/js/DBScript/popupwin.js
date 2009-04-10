var PopupWindow = function(){
	this.version = "1.0";
	this.name    = "PopupWindow";
	this.src     = "";
	this.gscope  = false; // if true appends class functions to global scope so that they can be called directly
};

PopupWindow.prototype = {
	windows : null
	
	, toString : function(){
			return this.name;
	}

	, onWinLoad : function(){
		// any call which should execute after the DOM has been loaded goes here
		DBScript.Events.addEvent(DBScript.Classes.$C("inline-popup-link", "A"), "click", DBScript.PopupWindow.show);
		DBScript.Events.addEvent(DBScript.Classes.$C("inline-popup-close", "A"), "click", DBScript.PopupWindow.hide);
	}
	
	, show : function(e){
		var trg = DBScript.Events.getTargetElement(e);
		var popupDiv = DBScript.PopupWindow.elementFromHref(trg.href);
		if(popupDiv) DBScript.Classes.swapClass(popupDiv, "hidden", "visible");
	}
	
	, hide : function(e){
		var trg = DBScript.Events.getTargetElement(e);
		var popupDiv = DBScript.PopupWindow.elementFromHref(trg.href);
		if(popupDiv) DBScript.Classes.swapClass(popupDiv, "visible", "hidden");
	}
	
	, elementFromHref : function(href) {
		var element_id = href.split("#");
		element_id.shift();
		return DBScript.Dollar.$(element_id.join());
	}
};
DBScript.register(PopupWindow);