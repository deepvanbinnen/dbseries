DBScript.register(function() {
	DBScript.import("events");
	
	this.version = "1.0";
	this.name    = "Keyboard";
	this.src     = "keyboard.js";
	this.gscope  = true;
	
	var self = {};
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
	
	self.NUMBERSHIFT = {
		49:	33,
		50:	64,
		51:	35,
		52:	36,
		53:	37,
		54:	94,
		55:	38,
		56:	42,
		57:	40,
		48:	41
	};
	
	DBScript.addFunctionsToContext( {
		init : function() {}
	  , getKey : function(e){
			var k = {};
			k.ascii = DBScript.Events.getKeyCode(e);
			k.orig  = DBScript.Events.getKeyCode(e);
			k.name  = "";
			k.char  = "";
			k.isnum = false;
			k.invisible = false;
			k.ispaste = false;
			if(self.INVISIBLES[k.ascii]){
				if(k.ascii!=9 && k.ascii!=13 && k.ascii!=32)
				k.invisible    = true;
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
				}
				if(k.ascii>48 && k.ascii<57){
					k.isnum = true;
				}
				if(!DBScript.Events.shiftIsPressed(e)){
					if((k.ascii>64 && k.ascii<92)){
						k.ascii = k.ascii + 32;
					}
				}
				else if((k.ascii>47 && k.ascii<58)){
					k.ascii = self.NUMBERSHIFT[k.ascii];
				}
				k.char = String.fromCharCode(k.ascii);
			}
			if(k.char=="v" && DBScript.Events.ctrlIsPressed(e)){
				// manually check for CTRL+V
				var el = DBScript.Events.getTargetElement(e);
				k.ispaste = true;
			}
			return k;
		}
	  
	  	, reject : function(e, allow) {
	  		// alert(allow.test(this.getKey(e).char));	  		
	  	}
	}, this);
});