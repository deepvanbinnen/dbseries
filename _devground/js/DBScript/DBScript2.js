/*
function createHTMLWindow(msg){
	var win = document.createElement("DIV");
	var txt = document.createTextNode(msg);
	var css = win.style
	css.height     = "200px";
	css.width      = "200px";
	css.border     = "1px solid red";
	css.background = "yellow";
	win.appendChild(txt);
	document.documentElement.appendChild(win);
}
window.alert = createHTMLWindow;
*/

Array.prototype.swap = function(i1, i2) {
	if(this[i1]&&this[i2]) {
		var tmp = this[i1];
		this[i1] = this[i2];
		this[i2] = tmp;
	}
}

Array.prototype.contains = function(v) {
	for(var i=0;i<this.length;i++)
		if(this[i]===v)
			return true;
	return false;
}



DBScriptWrapper = function(){};
DBScriptWrapper.prototype          = new Object;
DBScriptWrapper.prototype.debug    = false;
DBScriptWrapper.prototype.version  = "0.2";
DBScriptWrapper.prototype.includes = {};
DBScriptWrapper.prototype.elements = {};
DBScriptWrapper.prototype.events   = {};
DBScriptWrapper.prototype.register = function(name){
	DBScriptWrapper.prototype[name] = function(){return this;};
	return DBScriptWrapper.prototype[name];
};

DBScriptWrapper.prototype.include = function (source, name) {
	this.includes[name] = source;
	alert(this.includes);
	return this;
} 
DBScript = new DBScriptWrapper();
/*
var DBScript;
if(!DBScript)
	throw("DBScript not found!");
else {
	console.debug(DBScript);
}
alert("Did we stop this from alerting?");

// DBScript.include("/media/foo.js", "Foo").include("/media/bar.js", "Bar");

*/

var DBScriptWrapper, DBScript;
if(!DBScriptWrapper || !DBScript)
	throw("DBScript not found!");
	
var ClassHandler = DBScript.register("Classes");
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
}



