var DBScriptHandler;
if(!DBScriptHandler){
	DBScriptHandler = function(debug){
		this.debug = debug || false;
		this.init();
		return this;
	};
	
	DBScriptHandler.prototype = { 
		scrindex : 0
		,
		init : function(){
			this.echo("init DBScript...");
			this.onLoad(this.unload, true)
			this.dependancies = {};
			this.Dependancy = function(objame, filename){
				this.init(objame, filename);
				return this;
			};
			this.Dependancy.prototype = {
				init : function(objame, filename){
					this.name     = objame;
					this.filename = filename;
					this.ldstatus = 0; // 0=uninited;1=start;2=loaded;
					// console.debug(myDBScript);
				}
				,
				setStatus : function(ldstatus){
					this.ldstatus = ldstatus; // 0=uninited;1=start;2=loaded;
				}
			}
		}
	
		,
		echo : function(message){
			if (this.debug)
				console.debug(message);
		}
		
		,
		unload : function(){
			delete DBScript;
			/* console.debug(this);
			alert('Unloaded DBScript');*/
			
		}
		
		,
		onLoad : function(fn, isUnloadFunction){
			var isUnloadFunction = isUnloadFunction || false;
			var addEvent;
			if(!addEvent){
				addEvent = function(elm,evt,fn){
					if(elm.addEventListener){
						elm.addEventListener(evt,fn,false);
					} else if (elm.attachEvent){
						elm.attachEvent("on"+evt,fn);
					} else {
						elm["on" + evt] = fn;
					}
				}
			}
			
			if(isUnloadFunction){
				addEvent(window, "unload", fn);
				return;
			}
			
			var loaded  = false; 
			/* for Mozilla/Opera9 */
			if (document.addEventListener) {
			  addEvent(document, "DOMContentLoaded", fn);
			  loaded  = true; 
			}

			/* for Internet Explorer */
			/*@cc_on @*/
			/*@if (@_win32)
			  // document.write("<script id="+'"'+scriptid+'"'+" defer src=javascript:void(0)><\/script>");
			  var scriptid = "__scriptid"+(this.scrindex-1);
			  var script = document.getElementById(scriptid);
			  // alert(script);
			  script.onreadystatechange = function() {
			    if (this.readyState == "complete") {
			      loaded  = true; 
			      fn(); // call the onload handler
			    }
			  };
			/*@end @*/

			/* for Safari */
			if (/WebKit/i.test(navigator.userAgent)) { // sniff
			  var _timer = setInterval(function() {
			    if (/loaded|complete/.test(document.readyState)) {
			      loaded  = true; 
			      fn(); // call the onload handler
			    }
			  }, 10);
			}
			
			// other browser support
			if(!loaded){
				addEvent(window,"load",fn);
			}			
		}
		
		,
		getBase : function(){
		    var i, base, src = src || __me, scripts = document.getElementsByTagName("script");
		    for (i=0; i < scripts.length; i++){if (scripts[i].src.match(src)){ base = scripts[i].src.replace(src, "");break;}}
		    return base;
		} 
		
		,
		stripBase : function(src){
			return src.replace(this.base, "");
		}
		
		,
		isLoaded : function(src){
			var i, loaded = false, scripts = document.getElementsByTagName('head')[0].getElementsByTagName("script");
			for(i=0;i < scripts.length;i++){if(src == this.stripBase(scripts[i].src)){loaded = true; break;}}
			return loaded;
		}
		
		,
		include : function(src){
			 if(this.isLoaded(src)) {
			 	this.echo("Already loaded: "+src);
				return;
			}
			var scriptid = "__scriptid"+this.scrindex;
			this.scrindex++;
			var script = document.createElement('script');
		    script.type = 'text/javascript';
		    script.src = src;
			script.id  = scriptid;
		    document.getElementsByTagName('head')[0].appendChild(script); 
			this.echo("Including: "+src);
		}
		
		,
		doRegister : function(objname, filename, classDef, defineAsGlobal){
			var defineAsGlobal = defineAsGlobal || false;
			if(!this.getDependancy(objname)){
				this.echo("Registering: "+objname+" @ "+filename+" through class: "+classDef.toString());
				this.dependancies[objname] = new this.Dependancy(objname, filename);
				DBScriptHandler.prototype[objname] = classDef;
				if(classDef["onWinLoad"]){
					this.onLoad(classDef["onWinLoad"]);
				}
				
				if(defineAsGlobal)
					this.makeFunctionsGlobal(classDef);
				// DBScript.echo("registering: "+objname+" @ "+filename);
			}
			return this.getDependancy(objname);
		}
		
		,
		register : function(ClassFunc){
			var myClass = new ClassFunc();
			this.doRegister(myClass.name, myClass.src, myClass, myClass.gscope);
		}
		
		,
		makeFunctionsGlobal : function(classDef){
			for(func in classDef){
				if(classDef[func] && classDef[func].constructor==Function){
					if(func!="onWinLoad" && !window[func]) {
						this.echo("Adding: "+func+" from "+classDef.toString());
						window[func] = classDef[func];
					}
				}
			}
			
		}
		
		,
		isRegistered : function(objname) {
			return this.getDependancy(objname);
		}
		
		, 
		getDependancy : function(objname){
			return this.dependancies[objname];
		}
	}
	
	var DBScript = new DBScriptHandler(true);
	DBScript.include("DBScript/dollar_v2.js");
	DBScript.include("DBScript/events_v2.js");
	DBScript.include("DBScript/classes_v2.js");
	DBScript.include("DBScript/DOMHelper_v2.js");
	DBScript.include("DBScript/string.js");
	DBScript.include("DBScript/tables.js");
	DBScript.include("DBScript/xhr_v2.js");
}

