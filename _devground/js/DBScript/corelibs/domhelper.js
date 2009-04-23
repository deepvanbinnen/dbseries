DBScript.register(function() {
	DBScript.import("dollar");
	
	this.version = "2.0";
	this.name    = "DOMHelper";
	this.import  = "domhelper";
	this.src     = "corelibs/domhelper.js";
	this.gscope  = true;
	
	DBScript.addFunctionsToContext( {
		toString : function(){
			return this.name;
		},
		
		createElement : function(tag,attr){
			var el = document.createElement(tag);
			if(attr!=null) 
				parseAttributes(el,attr);
			return el;
		},
		
		duplicateElement : function(el){
			return el.cloneNode(true);
		},
		
		parseAttributes : function(el,attr){
			for(var i in attr) 
				(i=="className") ? el.className = attr[i] : el.setAttribute(i,attr[i]);
		},
		
		insertText : function(el,text){
			if (text==null || text=='') 
				return el;
			var DOMText = parseHTML(text);
			if(DOMText.childNodes.length==1 && DOMText.childNodes[0].nodeType==3){
				t = document.createTextNode(DOMText.childNodes[0].nodeValue);
				el.appendChild(t);
			}
			else {
				el.innerHTML += DOMText.innerHTML;
			}
			return el;
		},
		
		setText : function(el, text){
			el.innerHTML = '';
			return insertText(el,text);
		},
		
		parseHTML : function(text){
			var div = createElement("DIV");
			div.innerHTML = text;
			return div;
			/*return div.childNodes[0].nodeValue;*/
		},
		
		appendChildren : function(el, children){
			for(child in children){
				el.appendChild(child)
			}
			return el;
		},
		
		getParentByTagName : function(el,tagName){
			if(typeof el == "string") 
				el = getElementById(el);
			if(!el) 
				return;
			if(el.tagName.toLowerCase()!=tagName.toLowerCase()){
				if(el.parentNode) 
					el = this.getParentByTagName(el.parentNode,tagName);
			}
			return el;
		},
		
		/* retrieves all innertext for a given node */
		getInnerText : function(el){
			var text = (arguments.length==1) ? "" : arguments[1];
			var children = el.childNodes;
			for(var i=0;i<children.length;i++){
				if(children[i].nodeType==3){
					text += children[i].nodeValue
				}
				else {
					if(children[i].nodeType==1){
						text += getInnerText(children[i], text);
					}
				}
			}
			return text;
		},
		
		/* retrieves the innerHTML of a given node */
		getInnerHTML : function(el){
			return el.innerHTML;
		}
	}, this);
}).setStatus(2);;

