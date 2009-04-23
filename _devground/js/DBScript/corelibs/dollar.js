/* 2.0
 * This used to be 'basics.js' in systems older than 200612072059
 * For compat reasons basics.js still exists
 */
 
/* Borrowed the source from:
 * Find the element in the current HTML document with the given id or ids
 * @see http://getahead.ltd.uk/dwr/browser/util/$
 */

DBScript.register(function(){
	this.version = "2.0";
	this.name    = "Dollar";
	this.import  = "dollar";
	this.src     = "corelibs/dollar.js";
	this.gscope  = true;
	
	DBScript.addFunctionsToContext( {
		toString : function(){
			return this.name;
		}, 
		
		$ : function() {
			var getElement = function(element){
				if (document.getElementById) 
					return document.getElementById(element);
				if (document.all) 
					return document.all[element];
				return element
			}
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
		},
		
		$$ : function(elmArray){
			var elmArray = elmArray || null;
			if(typeof elmArray == "string" || (!elmArray.length && elmArray.constructor!='Array()')) {
				var nElmArray = new Array();
				if(elmArray.split){
					var elms = elmArray.split(',');
					for(var i=0,el;i<elms.length,el=elms[i];i++){
						nElmArray.push(this.$(el));
					}
				} else {
					nElmArray.push(this.$(elmArray));
				}
				elmArray = nElmArray;
			}
			return elmArray;
		}
	}, this);
}).setStatus(2);


 