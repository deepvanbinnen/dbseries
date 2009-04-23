DBScript.register(function () {
	DBScript.import("dollar");
	DBScript.import("classes");
	DBScript.import("events");
	
	this.version = "2.0";
	this.name    = "XHRClass";
	this.import  = "xhr";
	this.src     = "corelibs/xhr.js";
	this.gscope  = true; // appends class functions to global scope so that they can be called directly
	
	DBScript.include("DBScript/taconite-client-min.js");
	DBScript.include("DBScript/taconite-parser-min.js");
	DBScript.addFunctionsToContext({
		request     : null,
		preRequest  : null,
		postRequest : null,
		
		toString : function(){
			return this.name;
		},
		
		onWinLoad : function(){
			// any call which should execute after the DOM has been loaded goes here
			DBScript.addEvent(DBScript.$C("xhr", "FORM"),"submit", DBScript.postXHRRequest);
			DBScript.addEvent(DBScript.$C("xhr","A"),"click", DBScript.doXHRRequest);
		},
		
		sendAjaxRequest : function(usePost){
			var usePost = usePost || false;
			if(usePost) XHRClass.request.setUsePOST();
			if(XHRClass.preRequest) XHRClass.request.setPreRequest(XHRClass.preRequest);
			if(XHRClass.postRequest) XHRClass.request.setPostRequest(XHRClass.postRequest);
			XHRClass.request.sendRequest();
		},
		
		$AJAX : function(req){
			return setRequestUrl(req);
		},
		
		setRequestUrl : function(req){
			/*
			"req.constructor.name" is not supprted in IE?
			XHRClass.request = req.constructor.name.toLowerCase()=="string" ? new AjaxRequest(req) : req;
			*/
			XHRClass.request = reqIsURL(req) ? new AjaxRequest(req) : req;
			return XHRClass.request;
		},
		
		reqIsURL : function(req){
			if(typeof(req)=="string") return true;
			if(req.constructor && req.constructor.name && req.constructor.name.toLowerCase()=="string") return true;
			return false;
		},
		
		setDefaultPreRequest : function(fnc){
			XHRClass.preRequest = fnc;
		},
		
		setDefaultPostRequest : function(fnc){
			XHRClass.postRequest = fnc;
		},
		
		doXHRRequest : function(e){
			cancelEvent(e);	
			var a = getTargetElement(e);
			a = getParentByTagName(a, "A");
			$AJAX(a.href);
			sendAjaxRequest();	
		},
		
		postXHRRequest : function(e){
			cancelEvent(e);	
			var frm = getTargetElement(e);
			frm = getParentByTagName(frm, "FORM");
			var req = $AJAX(frm.action);
			req.addFormElements(frm);
			sendAjaxRequest(true);
		}
	}, this);
}).setStatus(2);




