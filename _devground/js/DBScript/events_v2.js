DBScript.register(function() {
	this.version = "2.0";
	this.name    = "Events";
	this.src     = "events_v2.js";
	this.gscope  = true;
	
	var self = this;
	self.INVISIBLES = {
		  8  : "BACKSPACE"
		, 9  : "TAB"
		, 13 : "ENTER"
		, 27 : "ESCAPE"
		, 32 : "SPACE"
		, 37 : "ARROWLEFT"
		, 38 : "ARROWUP"
		, 39 : "ARROWRIGHT"
		, 40 : "ARROWDOWN"
		, 45 : "INSERT"
		, 46 : "DELETE"
		, 36 : "HOME"
		, 35 : "END"
		, 33 : "PAGEUP"
		, 34 : "PAGEDOWN"
		, 16 : "SHIFT"
		, 17 : "ALT"
		, 18 : "CONTROL"
		, 20 : "CAPSLOCK"
		, 144 : "NUMLOCK"
	};
	
	self.NONALPHA = {
		  33 : "EXCLAMATIONMARK"
		, 64 : "ATSIGN"
		, 35 : "HASH"
		, 36 : "DOLLAR"
		, 37 : "PERCENTAGE"
		, 94 : "CARET"
		, 38 : "AMPERSAND"
		, 42 : "STAR"
		, 40 : "LEFT PARENTHESIS"
		, 41 : "RIGHT PARENTHESIS"
		, 59 : "SEMICOLON"
		, 58 : "COLON"
		, 61 : "EQUALS"
		, 43 : "PLUS"
		, 44 : "COMMA"
		, 60 : "LOWER THAN"
		, 45 : "MINUS"
		, 95 : "UNDERSCORE"
		, 46 : "DOT"
		, 62 : "GREATER THAN"
		, 47 : "SLASH" 
		, 63 : "QUESTIONMARK"
		, 96 : "ACCENT"
		, 126 : "TILDE"
		, 91 : "LEFT SQUARE BRACKET"
		, 123: "LEFT CURLY BRACKET"
		, 92 : "BACKSLASH"
		, 124 : "PIPELINE"
		, 93 : "RIGHT SQUARE BRACKET"
		, 125 : "RIGHT SQUARE BRACKET"
		, 39 : "SINGLE QUOTE"
		, 34 : "DOUBLE QUOTE"
	};
	self.KEYPADNUM = { 
		 "96":48
		,"97":49
		,"98":50
		,"99":51
		,"100":52
		,"101":53
		,"102":54
		,"103":55
		,"104":56
		,"105":57
	};
	self.NONALPHAMOZ = {
		"188":60,
		"109":95,
		"190":62,
		"191":63,
		"192":126,
		"219":91,
		"220":124,
		"221":93,
		"222":39
	};

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
		
		, getKey : function(e){
			var k = {};
			k.ascii = self.getKeyCode(e);
			k.orig  = self.getKeyCode(e);
			k.name  = "";
			k.char  = "";
			k.isnum = false;
			k.invis = false;
			if(self.INVISIBLES[k.ascii]){
				k.invis    = true;
				k.name = self.INVISIBLES[k.ascii];
			}
			else {
				if(self.KEYPADNUM[k.ascii]){
					k.ascii = self.KEYPADNUM[k.ascii];
				}
				if(self.NONALPHAMOZ[k.ascii]){
					k.ascii = self.NONALPHAMOZ[k.ascii];
				}
				if(self.NONALPHA[k.ascii]){
					k.name = self.NONALPHAMOZ[k.ascii];
					console.debug("NON ALPHA: " + k.ascii);
				}
				if(k.ascii>48 && k.ascii<57){
					k.isnum = true;
				}
				if(!self.shiftIsPressed(e) && (k.ascii>64 && k.ascii<92)){
					k.ascii = k.ascii + 32;
				}
				k.char = String.fromCharCode(k.ascii)
			}
			return k;
		}
		
		, getElementEvents : function(el){
			return DBScript.Events.evtElms[el];
		}
	}, this.constructor.prototype);
});