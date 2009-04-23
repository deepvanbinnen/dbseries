DBScript.register(function() {
	DBScript.import("dollar");
	
	this.version = "2.0";
	this.name    = "Events";
	this.import  = "events";
	this.src     = "corelibs/events.js";
	this.gscope  = true;
	
	DBScript.addFunctionsToContext( {
		toString : function(){
			return this.name;
		}, 
		
		addEvent : function(elmArray,evt,fn){
			var elmArray = DBScript.$$(elmArray);
			var evtAdded = false;
			for(var i=0;i<elmArray.length;i++){
				evtAdded = false;
				if(elmArray[i].addEventListener){
					elmArray[i].addEventListener(evt,fn,false);
					evtAdded = true;
				} else if (elmArray[i].attachEvent){
					elmArray[i].attachEvent("on"+evt,fn);
					evtAdded = true;
				} else {
					elmArray[i]["on" + evt] = fn;
					evtAdded = true;
				}
				/*
				if(evtAdded && elmArray[i]) {
					DBScript.Events.evtElms[elmArray[i]] = evt;
				}
				*/
			}
		},
		
		removeEvent : function(elmArray,evt,fn){
			var elmArray = DBScript.$$(elmArray);
			for(var i=0;i<elmArray.length;i++){
				if(elmArray[i].removeEventListener){
					elmArray[i].removeEventListener(evt,fn,false);
				} else if (elmArray[i].detachEvent){
					elmArray[i].detachEvent("on"+evt,fn);
				} else {
					elmArray[i]["on" + evt] = null;
				}
			}
		},
		
		cancelEvent : function(e){
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
		},
	
		getTargetElement : function(e){
			if(!e) e = window.event;
			if(!e){
				return;
			} else if(e.srcElement){
				return e.srcElement
			} else if(e.currentTarget){
				return e.currentTarget;
			}
		}
		
		, $G : function(el){
			var el = DBScript.$(el);
			if(el.hasAttribute("value")) return el.value;
			else return el.innerHTML;
		},
	
		$S : function(el, val){
			var el = $(el);
			if(typeof val != "string") val = DBScript.$G(val);
			if(el.hasAttribute("value")) el.value = val;
			else el.innerHTML = val;
			return DBScript.$G(el);
		}
		
		, getKeyCode : function(e){
			if(!e) e = window.event;
			if(!e){
				return;
			} else if(e.which){
				return e.which;
			} else if(e.keyCode){
				return e.keyCode;
			}
			return;
		}
		
		, getCharCode : function(e){
			if(!e) e = window.event;
			if(!e){
				return;
			} else if(e.charCode){
				return e.charCode;
			} else if(e.keyCode){
				return e.keyCode;
			} else if(e.which){
				return e.which;
			}
			return;
		}

		// retourneert de vertaalde ascii-waarde van de ingetoetste knop op het toetsenbord
		, getKeyStringVal : function(e){return String.fromCharCode(_this.getCharCode(e));}
		
		// geven aan of op het moment van het event een van deze toetsen ingedrukt was
		, altIsPressed : function(e){return e['altKey'];}
		, ctrlIsPressed : function(e){return e['ctrlKey'];}
		, shiftIsPressed : function(e){return e['shiftKey'];}
		
		, getElementEvents : function(el){
			return DBScript.Events.evtElms[el];
		}
		
		, getKey : function(e){
			return DBScript.Keyboard.getKey(e);
		}
	}, this);
}).setStatus(2);;