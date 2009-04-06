
var taconite_client_version="2.0";function AjaxRequest(url){var self=this;var xmlHttp=createXMLHttpRequest();var queryString="";var requestURL=url;var method="GET";var preRequest=null;var postRequest=null;var debugResponse=false;var async=true;var errorHandler=null;this.getXMLHttpRequestObject=function(){return xmlHttp;}
this.setPreRequest=function(func){preRequest=func;}
this.setPostRequest=function(func){postRequest=func;}
this.getPostRequest=function(){return postRequest;}
this.setUsePOST=function(){method="POST";}
this.setUseGET=function(){method="GET";}
this.setEchoDebugInfo=function(){debugResponse=true;}
this.isEchoDebugInfo=function(){return debugResponse;}
this.setQueryString=function(qs){queryString=qs;}
this.getQueryString=function(){return queryString;}
this.setAsync=function(asyncBoolean){async=asyncBoolean;}
this.setErrorHandler=function(func){errorHandler=func;}
this.addFormElements=function(form){var formElements=new Array();if(form!=null){if(typeof form=="string"){var el=document.getElementById(form);if(el!=null){formElements=el.elements;}}else{formElements=form.elements;}}
var values=toQueryString(formElements);accumulateQueryString(values);}
this.addNameValuePair=function(name,value){var nameValuePair=name+"="+encodeURIComponent(value);accumulateQueryString(nameValuePair);}
this.addNamedFormElementsByFormID=function(){var elementName="";var namedElements=null;for(var i=1;i<arguments.length;i++){elementName=arguments[i];namedElements=document.getElementsByName(elementName);var arNamedElements=new Array();for(j=0;j<namedElements.length;j++){if(namedElements[j].form&&namedElements[j].form.getAttribute("id")==arguments[0]){arNamedElements.push(namedElements[j]);}}
if(arNamedElements.length>0){elementValues=toQueryString(arNamedElements);accumulateQueryString(elementValues);}}}
this.addNamedFormElements=function(){var elementName="";var namedElements=null;for(var i=0;i<arguments.length;i++){elementName=arguments[i];namedElements=document.getElementsByName(elementName);elementValues=toQueryString(namedElements);accumulateQueryString(elementValues);}}
this.addFormElementsById=function(){var id="";var element=null;var elements=new Array();for(var h=0;h<arguments.length;h++){element=document.getElementById(arguments[h]);if(element!=null){elements[h]=element;}}
elementValues=toQueryString(elements);accumulateQueryString(elementValues);}
this.sendRequest=function(){if(preRequest){preRequest(self);}
var obj=this;if(async)
xmlHttp.onreadystatechange=function(){handleStateChange(self)};if(requestURL.indexOf("?")>0){requestURL=requestURL+"&ts="+new Date().getTime();}
else{requestURL=requestURL+"?ts="+new Date().getTime();}
try{if(method=="GET"){if(queryString.length>0){requestURL=requestURL+"&"+queryString;}
xmlHttp.open(method,requestURL,async);xmlHttp.send(null);}
else{xmlHttp.open(method,requestURL,async);try{if(xmlHttp.overrideMimeType){xmlHttp.setRequestHeader("Connection","close");}}
catch(e){}
xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");xmlHttp.send(queryString);}}
catch(exception){if(errorHandler){errorHandler(self,exception);}
else{throw exception;}}
if(!async){handleStateChange(self);}
if(self.isEchoDebugInfo()){echoRequestParams();}}
handleStateChange=function(ajaxRequest){if(ajaxRequest.getXMLHttpRequestObject().readyState!=4){return;}
if(ajaxRequest.getXMLHttpRequestObject().status!=200){errorHandler(self);return;}
try{var debug=ajaxRequest.isEchoDebugInfo();if(debug){echoResponse(ajaxRequest);}
var nodes=null;if(ajaxRequest.getXMLHttpRequestObject().responseXML!=null){nodes=ajaxRequest.getXMLHttpRequestObject().responseXML.documentElement.childNodes;}
else{nodes=new Array();}
var parser=new XhtmlToDOMParser();var parseInBrowser="";for(var i=0;i<nodes.length;i++){if(nodes[i].nodeType!=1||!isTaconiteTag(nodes[i])){continue;}
parser.parseXhtml(nodes[i]);}}
catch(exception){if(errorHandler){errorHandler(self,exception);}
else{throw exception;}}
finally{try{if(ajaxRequest.getPostRequest()){var f=ajaxRequest.getPostRequest();f(ajaxRequest);}}
catch(exception){if(errorHandler){errorHandler(self,exception);}}}}
function createXMLHttpRequest(){var req=false;if(window.XMLHttpRequest){req=new XMLHttpRequest();}
else if(window.ActiveXObject){try{req=new ActiveXObject("Msxml2.XMLHTTP");}
catch(e){try{req=new ActiveXObject("Microsoft.XMLHTTP");}
catch(e){req=false;}}}
return req;}
function accumulateQueryString(newValues){if(queryString==""){queryString=newValues;}
else{queryString=queryString+"&"+newValues;}}
function isTaconiteTag(node){return node.tagName.substring(0,9)=="taconite-";}
function toQueryString(elements){var node=null;var qs="";var name="";var tempString="";for(var i=0;i<elements.length;i++){tempString="";node=elements[i];name=node.getAttribute("name");if(!name){name=node.getAttribute("id");}
name=encodeURIComponent(name);if(node.tagName.toLowerCase()=="input"){if(node.type.toLowerCase()=="radio"||node.type.toLowerCase()=="checkbox"){if(node.checked){tempString=name+"="+encodeURIComponent(node.value);}}
if(node.type.toLowerCase()=="text"||node.type.toLowerCase()=="hidden"||node.type.toLowerCase()=="password"){tempString=name+"="+encodeURIComponent(node.value);}}
else if(node.tagName.toLowerCase()=="select"){tempString=getSelectedOptions(node);}
else if(node.tagName.toLowerCase()=="textarea"){tempString=name+"="+encodeURIComponent(node.value);}
if(tempString!=""){if(qs==""){qs=tempString;}
else{qs=qs+"&"+tempString;}}}
return qs;}
function getSelectedOptions(select){var options=select.options;var option=null;var qs="";var tempString="";for(var x=0;x<options.length;x++){tempString="";option=options[x];if(option.selected){tempString=encodeURIComponent(select.name)+"="+encodeURIComponent(option.value);}
if(tempString!=""){if(qs==""){qs=tempString;}
else{qs=qs+"&"+tempString;}}}
return qs;}
function echoResponse(ajaxRequest){var echoTextArea=document.getElementById("debugResponse");if(echoTextArea==null){echoTextArea=createDebugTextArea("Server Response:","debugResponse");}
var debugText=ajaxRequest.getXMLHttpRequestObject().status
+" "+ajaxRequest.getXMLHttpRequestObject().statusText+"\n\n\n";echoTextArea.value=debugText+ajaxRequest.getXMLHttpRequestObject().responseText;}
function echoParsedJavaScript(js){var echoTextArea=document.getElementById("debugParsedJavaScript");if(echoTextArea==null){var echoTextArea=createDebugTextArea("Parsed JavaScript (by JavaScript Parser):","debugParsedJavaScript");}
echoTextArea.value=js;}
function createDebugTextArea(label,id){echoTextArea=document.createElement("textarea");echoTextArea.setAttribute("id",id);echoTextArea.setAttribute("rows","15");echoTextArea.setAttribute("style","width:100%");echoTextArea.style.cssText="width:100%";document.getElementsByTagName("body")[0].appendChild(document.createTextNode(label));document.getElementsByTagName("body")[0].appendChild(echoTextArea);return echoTextArea;}
function echoRequestParams(){var qsTextBox=document.getElementById("qsTextBox");if(qsTextBox==null){qsTextBox=createDebugTextBox("Query String:","qsTextBox");}
qsTextBox.value=queryString;var urlTextBox=document.getElementById("urlTextBox");if(urlTextBox==null){urlTextBox=createDebugTextBox("URL (Includes query string if GET request):","urlTextBox");}
urlTextBox.value=requestURL;}
function createDebugTextBox(label,id){textBox=document.createElement("input");textBox.setAttribute("type","text");textBox.setAttribute("id",id);textBox.setAttribute("style","width:100%");textBox.style.cssText="width:100%";document.getElementsByTagName("body")[0].appendChild(document.createTextNode(label));document.getElementsByTagName("body")[0].appendChild(textBox);return textBox;}};