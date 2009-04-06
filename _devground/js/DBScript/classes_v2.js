var DBScript;
if(!DBScript)
	throw("DBScript not found!");
	
ClassHandler = function(){
	this.version = "2.0";
	this.name    = "Classes";
	this.src     = "classes_v2.js";
	this.gscope  = true;
};

ClassHandler.prototype = {
	toString : function(){
		return this.name;
	}
	
	,
	onWinLoad : function(){
		var getElementsByClassName;
		if(!getElementsByClassName)
			getElementsByClassName = $C;
	}
	
	,
	addClass : function (elmArray, className) {
	   	var elmArray = $$(elmArray);
	   	var element, i;
	   	for(i=0;i<elmArray.length,element=elmArray[i];i++){
	   		if (!hasClass(element, className)) {
		      if (element.className) element.className += " " + className;
		      else element.className = className;
		   }
	   }
	}

	,
	removeClass : function(elmArray, className) {
		var regexp = new RegExp("(^|\\s)" + className + "(\\s|$)");
		var elmArray = $$(elmArray);
	   	var element, i;
	   	for(i=0;i<elmArray.length,element=elmArray[i];i++){
	   		element.className = element.className.replace(regexp,"$2");
	   	}
	}
	
	,
	hasClass : function(element, className) {
	    var regexp = new RegExp("(^|\\s)" + className + "(\\s|$)");
		var element = $(element);
	    return regexp.test(element.className);
	}

	,
	swapClass : function(elmArray, oldClassName, newClassName) {
	    removeClass(elmArray, oldClassName);
		addClass(elmArray, newClassName);
	}
	
	,
	$C : function(className, tagName, fromElement) {
		var startNode = fromElement || document;
		if (typeof startNode == "string") startNode = $(startNode);
		var tagFilter = tagName || "*";
		var children = startNode.getElementsByTagName(tagFilter);
		var elements = new Array();
		
		for (var i = 0; i < children.length; i++) 
			if(this.hasClass(children[i], className)) 
				elements.push(children[i]);
		return elements;
	}
};

DBScript.register(ClassHandler);
