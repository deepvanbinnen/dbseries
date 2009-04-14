/* prototype functions not default supported by all browsers */
if(!Array.indexOf){
	// alert("IE does not implement an indexOf function on arrays!\nWe hate IE!");
	Array.prototype.indexOf = function(v,i){
		var i = i || 0; // index to start
		if(i>this.length || i<0) return -1;
		for(;i<=this.length;i++){
			if(this[i]===v) return i;
		}
		 return -1;
	}
}

/* e-Vision namespace to make sure our functions don't collide with other library implementations */
var ENS = {};

/* Dollar function for easy referencing */
ENS.$;
if(!ENS.$){
	ENS.$ = function() {
		var elements = [];
		var getElement = function(element){
			if (document.getElementById) 
				return document.getElementById(element);
			if (document.all) 
				return document.all[element];
			return element;
		};
		
		var elements = new Array();
		for (var i = 0; i < arguments.length; i++) {
			var element = arguments[i];
			if (typeof element == 'string') 
				element = getElement(element);
			if (arguments.length == 1)
				return element;
			elements.push(element);
		}
		return elements;
	}
}

/* Event functions for assignment/removal of handlers for events */
if(!ENS.addEvent){
	ENS.addEvent = function(element,evt,fn){
		var element = ENS.$(element);
		if(element.addEventListener){
			element.addEventListener(evt,fn,false);
		} else if (element.attachEvent){
			element.attachEvent("on"+evt,fn);
		} else {
			element["on" + evt] = fn;
		}
	};
};

if(!ENS.removeEvent){
	ENS.removeEvent = function(element,evt,fn){
		var element = ENS.$(element);
		if(element.removeEventListener){
			element.removeEventListener(evt,fn,false);
		} else if (element.detachEvent){
			element.detachEvent("on"+evt,fn);
		} else {
			element["on" + evt] = null;
		}
	};
};

if(!ENS.cancelEvent){
	ENS.cancelEvent = function(e){
		if(!e) e = window.event;
		if(!e){
			return;
		} else if(e.preventDefault){
			e.preventDefault();
		} else if(e.stopPropagation){
			e.stopPropagation();
			e.returnValue = false;
		} else if(!e.cancelBubble){
			e.cancelBubble = true;
			e.returnValue = false;
		} 
		return;
	}; 
};

/* Class functions for adding removing and checking classnames for a given DOM-element */
if(!ENS.addClass){
	ENS.addClass = function (element, className) {
		var element = ENS.$(element);
		if (!ENS.hasClass(element, className)) {
			if (element.className) element.className += " " + className;
			else element.className = className;
		}
	}
}

if(!ENS.removeClass){
	ENS.removeClass = function(element, className) {
		var regexp = new RegExp("(^|\\s)" + className + "(\\s|$)");
		var element = ENS.$(element);
		element.className = element.className.replace(regexp,"$2");
	}
}

if(!ENS.hasClass){
	ENS.hasClass = function(element, className) {
		var regexp = new RegExp("(^|\\s)" + className + "(\\s|$)");
		var element = ENS.$(element);
		return regexp.test(element.className);
	}
}

/* Walk the DOM up to obtain a parent element reference */
if(!ENS.getParentByTagName){
	ENS.getParentByTagName = function(el,tagName){
		var element = ENS.$(el);     
		if(!element) return;
		if(element.tagName.toLowerCase()!=tagName.toLowerCase()){
			if(element.parentNode) 
				element = ENS.getParentByTagName(element.parentNode,tagName);
	    }
		return element;
	}
}

/* Date validator */
if(!ENS.isDate){
	ENS.isDate = function(y,m,d){
		var y = y || 0;
		var m = m || 0;
		var d = d || 0;
		if(d>0 && m>=1 && m<=12){
			if(d<=28) return true;
			if ((d<=30 && m!=2) || (d==31 && m!=2 && ((m%8)+parseInt(m/8))%2)) return true;
			// if(d==31 && m!=2 && ((m%8)+parseInt(m/8))%2) return true;
			if(d==29 && m==2 && (y%100)%4==0) return true;
		}
		return false;
	}
}