DBScript.register(function() {
	DBScript.import("dollar");
	
	this.version = "2.0";
	this.name    = "Classes";
	this.import  = "classes";
	this.src     = "corelibs/classes.js";
	this.gscope  = true;
	
	DBScript.addFunctionsToContext( {
		toString : function(){
			return this.name;
		}
		
		,
		onWinLoad : function(){
			var getElementsByClassName;
			if(!getElementsByClassName)
				getElementsByClassName = DBScript.$C;
		}
		
		,
		addClass : function (elmArray, className) {
		   	var elmArray = DBScript.$$(elmArray);
		   	var element, i;
		   	for(i=0;i<elmArray.length,element=elmArray[i];i++){
		   		if (!this.hasClass(element, className)) {
			      if (element.className) element.className += " " + className;
			      else element.className = className;
			   }
		   }
		}
	
		,
		removeClass : function(elmArray, className) {
			var regexp = new RegExp("(^|\\s)" + className + "(\\s|$)");
			var elmArray = DBScript.$$(elmArray);
		   	var element, i;
		   	for(i=0;i<elmArray.length,element=elmArray[i];i++){
		   		element.className = element.className.replace(regexp,"$2");
		   	}
		}
		
		,
		hasClass : function(element, className) {
		    var regexp = new RegExp("(^|\\s)" + className + "(\\s|$)");
			var element = DBScript.$(element);
		    return regexp.test(element.className);
		}
	
		,
		swapClass : function(elmArray, oldClassName, newClassName) {
			this.removeClass(elmArray, oldClassName);
			this.addClass(elmArray, newClassName);
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
	}, this);
}).setStatus(2);
