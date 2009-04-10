var EventHandler;
if(!EventHandler){
	EventHandler = function(){
		this.version = "2.0";
		this.name    = "Events";
		this.src     = "events_v2.js";
		this.gscope  = true;
		// this.evtElms = {};
	}
	
	EventHandler.prototype = {
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
		},
		
		$G : function(el){
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
		},
		
		getElementEvents : function(el){
			return DBScript.Events.evtElms[el];
		}
	}
	
	if(DBScript){
		DBScript.register(EventHandler);
	}
};


