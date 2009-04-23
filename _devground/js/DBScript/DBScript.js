var DBScriptHandler;
if(!DBScriptHandler){
	DBScriptHandler = function(debug){
		this.debug = debug || false;
		this.name = "DBScript";
		this.init();
		
		var id   = "DBScript";
		var self = "";
		var root = ""; 
		var libmap = {};
		var nsmap  = {};
		
		this.emptyFunction = function(){};
		
		var setSelf = function(){
			var s = document.getElementById(id);
			if(s){
				self = s.src;
				root = self.split("/");
				root.pop();
				root = root.join("/") + "/";
			}
		}
		
		this.getSelf = function(){
			return root;
		}
		
		this.getInclude = function(src){
			return root + src;
		}
		
		this.import = function(name){
			var src = "";
			if(nsmap[name] && libmap[nsmap[name]]) {
				src = libmap[nsmap[name]];
			} else if(libmap[name]){
				src = libmap[name];
			} 
			if(src!=""){
				this.echo("Got import includefile for:" + name + " at: " + root+src);
				this.include(src);
			}
			else {
				this.echo("Import:" + name + " not found.");
			}
		}
		
		/**
		 * Add namespace, name and source file used by the import method   
		 */
		this.setLibMap = function(ns, name, src){
			/**
			 * @param {String} ns  namespace
			 * @param {String} src sourcefile
			 * @param {String} name importname
			 */
			 nsmap[name] = ns;
			 libmap[ns]  = src;
			 this.echo("added to libmap:" + name); 
		}
		
		this.getLibMap = function(name){
			return nsmap;
		}
		
		setSelf();
		return this;
	};
	
	DBScriptHandler.prototype = { 
		  scrindex : 0
		
		, init : function(){
			this.echo("init DBScript...");
			this.onLoad(this.unload, true);
			this.registered = {};
			this.RegisteredObject = function(objname, filename, constructor){
				this.init(objname, filename, constructor);
				return this;
			};
			this.RegisteredObject.prototype = {
				init : function(objname, filename, constructor){
					this.name     = objname;
					this.filename = filename;
					this.ldstatus = 0; // 0=uninited;1=start;2=loaded;
					this.instance = constructor;
					// console.debug(myDBScript);
				}
				, setStatus : function(ldstatus){
					this.ldstatus = ldstatus; // 0=uninited;1=start;2=loaded;
				}
			};
		}
	
		,
		createInstance : function(className) {
			return (this.isRegistered(className)) ? new this.registered[className].instance() : new this.emptyFunction();
		}
	
		,
		echo : function(message, force){
			var force = force || false;
			if (this.debug || force)
				console.debug(message);
		}
		
		,
		unload : function(){
			delete DBScript;
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
			    if (this.readyState == "complete" || this.readyState == "loaded") {
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
		    console.debug(this.getSelf());
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
			var src = this.getSelf() + src; 
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
		doRegister : function(objname, filename, classInstance, classDef, extendDBScript){
			var defineAsGlobal = defineAsGlobal || false;
			if(!this.getRegisteredObject(objname)){
				
				this.registered[objname] = new this.RegisteredObject(objname, filename, classDef);
				if(classInstance) {
					DBScriptHandler.prototype[objname] = classInstance;
					this.echo("Registering: "+objname+" @ "+filename+" through class: "+classInstance.toString());
					if(classInstance["onWinLoad"]){
						this.onLoad(classInstance["onWinLoad"]);
					}
					if(extendDBScript)
						this.addFunctionsToContext(classInstance, this);
					// DBScript.echo("registering: "+objname+" @ "+filename);
				}
			}
			return this.getRegisteredObject(objname);
		}
		
		,
		register : function(ClassFunc, instantiate, name){
			var instantiate = (arguments.length > 1) ? instantiate : true;
			var myClass = instantiate ? new ClassFunc() : null;
			var name    = (arguments.length > 2) ? name : (myClass) ? myClass.name : "__unknown__" + this.scrindex;
			var src     = (myClass && myClass.src) ? myClass.src : "";
			var gscope  = (myClass && myClass.gscope) ? true : false;
			// this.echo(ClassFunc.toString(), true);
			return this.doRegister(name, src, myClass, ClassFunc, gscope);
		}
		
		,
		addFunctionsToContext : function(classDef, context){
			var context = context || window;
			//alert(context);
			for(var func in classDef){
				if(classDef[func] && classDef[func].constructor==Function){
					if(!context[func]) {
						this.echo("Adding: "+func+" from "+ classDef.toString());
						context[func] = classDef[func];
					}
				}
			}
			
		}
		
		,
		copyProps : function(source, destination, keymap){
			for(var key in keymap){
				destination[keymap[key]] = source[key];
			}
		}
		
		,
		isRegistered : function(objname) {
			return this.getRegisteredObject(objname);
		}
		
		, 
		getRegisteredObject : function(objname){
			return this.registered[objname];
		}
	}
	
	var DBScript = new DBScriptHandler(true);
	DBScript.include("corelibs.js");
	DBScript.include("addons.js");
	DBScript.include("userlib.js");
	// DBScript.include("DBScript/array_v2.js");
	// DBScript.include("DBScript/string.js");
	// DBScript.include("DBScript/dollar_v2.js");
	// DBScript.include("DBScript/events_v2.js");
	// DBScript.include("DBScript/keyboard.js");
	// DBScript.include("DBScript/classes_v2.js");
	// DBScript.include("DBScript/DOMHelper_v2.js");
	// DBScript.include("DBScript/tables.js");
	// DBScript.include("DBScript/xhr_v2.js");
	// DBScript.include("DBScript/popupwin.js");
	// DBScript.include("DBScript/aliases.js");
	// DBScript.include("DBScript/formelement.js");
	// DBScript.include("DBScript/eventhandler.js");
}

