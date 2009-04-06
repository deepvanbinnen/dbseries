/* DOC CHANGELOG AND REVISIONS */
/* CHANGE 1.1 -- function getInnerText(elm) toegevoegd om de innerText van een element op te halen */
/* CHANGE 1.2 -- function getInnerText(elm) aangepast om de innerText van een element op te halen */
/* CHANGE 1.3 -- JS versies van ColdFusion's URLDecode(inString) en URLEncodedFormat(inString) toegevoegd */
/* CHANGE 1.4 -- getElementsByClassName uitgebreid zodat je vanaf een node kunt zoeken naar specifieke tags */
/* CHANGE 1.5 -- alles wat te maken heeft met classes verwijderd en in een apart bestand classes.js gestopt */
/* CHANGE 1.6 -- URLEncodedFormat en URLDecode verplaatst naar string.js */

var DOMHelper;
if(!DOMHelper){
	DOMHelper = function(){
		this.version = "2.0";
		this.name    = "DOMHelper";
		this.src     = "DOMHelper_v2.js";
		this.gscope  = true;
	}
	
	DOMHelper.prototype = {
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
					el = getParentByTagName(el.parentNode,tagName);
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
	}
	
	if(DBScript){
		DBScript.register(DOMHelper);
	}
}

/*function init(){
	if(DBScript){
		var DBS = DBScript.instanceOf;
		console.debug(DBS.$("content"));
	}
}
$L(init);

var myFunctions = {
	testFunction : function(){
		alert("this is my testfunction");
	},
	
	init : function(){
		alert($("content"));
	},
	
	toString : function(){
		return "myFunctions";
	} 
}

 
if(DBScript){
	if(!DBScript.instanceOf.isRegistered("myFunctions")){
		DBScript.instanceOf.doRegister("myFunctions", "myFunctions.js", myFunctions, false);
	}
	DBScript.instanceOf.onLoad(myFunctions.init);
}
*/


