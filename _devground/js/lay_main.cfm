<cfparam name="attributes.javascripts" default="#ArrayNew(1)#">
<cfset ArrayAppend(attributes.javascripts,"DBScript/DBScript.js")>
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head><title>DBScript</title>
<style type="text/css">
.hidden {display: none;}
.visible {display: block;}

##loading {
	position: absolute;
	top: 0; left: 0;
	background: black;
	opacity: 0.7;
	width: 100%; height: 100%;
}

##loading .messagebox {
	width: 300px; margin: 3em auto; 
	background: white;
	padding: 1em 2em; border: 1pt solid silver;
}

</style>
<!--- <link type="text/css" rel="stylesheet" href="media/css/global.css" /> --->
<cfloop array="#attributes.javascripts#" index="jsfile"><script src="#jsfile#" type="text/javascript"></script></cfloop>
<script type="text/javascript">
	
var PopupWindow = function(){
	this.version = "1.0";
	this.name    = "PopupWindow";
	this.src     = "";
	this.gscope  = false; // if true appends class functions to global scope so that they can be called directly
};

PopupWindow.prototype = {
	windows : null,
	
	toString : function(){
			return this.name;
	},
	
	onWinLoad : function(){
		// any call which should execute after the DOM has been loaded goes here
		DBScript.Events.addEvent(DBScript.Classes.$C("inline-popup-link", "A"), "click", DBScript.PopupWindow.show);
		DBScript.Events.addEvent(DBScript.Classes.$C("inline-popup-close", "A"), "click", DBScript.PopupWindow.hide);
		
	},
		
	show : function(e){
		var trg = DBScript.Events.getTargetElement(e);
		var popupDiv = DBScript.PopupWindow.elementFromHref(trg.href);
		if(popupDiv) DBScript.Classes.swapClass(popupDiv, "hidden", "visible");
	}
	
	, hide : function(e){
		var trg = DBScript.Events.getTargetElement(e);
		var popupDiv = DBScript.PopupWindow.elementFromHref(trg.href);
		if(popupDiv) DBScript.Classes.swapClass(popupDiv, "visible", "hidden");
	}
	
	, elementFromHref : function(href) {
		var element_id = href.split("##");
		element_id.shift();
		return DBScript.Dollar.$(element_id.join());
	}
};
DBScript.register(PopupWindow);

var Validator = function(){
	this.version = "1.0";
	this.name    = "Validator";
	this.src     = "";
	this.gscope  = false; // if true appends class functions to global scope so that they can be called directly
}

/*
Validator.prototype = {
	  formcollect : new Array()
	, elmcollect  : new Array()
	, validators  : new Array()
}*/

var OctopusValidators = {
	"titel_voor"          : new RegExp("^[a-zA-Z\. ]*$"),
	"voorletters"         : new RegExp("^([a-zA-Z\. ])*$"),
	"voornaam"            : new RegExp("^[a-zA-Z\u00c0-\u00c4\u00c8-\u00cf\u00d2-\u00d6\u00d9-\u00dc\u00e0-\u00ef\u00f1-\u00f6\u00f9-\u00fc'` -]*$"),
	"achtervoegsel"       : new RegExp("^[a-zA-Z\. ]*$"),
	"geslacht"            : new RegExp("^[MVO]$","i"),
	"huisnummer"          : new RegExp("^[0-9]*$"),
	"postcode"            : new RegExp("^[1-9][0-9]{3}[ ]{0,1}[A-Z]{2}$"),
	"landcode"            : new RegExp("^([A-Z])*$"),
	"adrestype"           : new RegExp("^Pri|Zak|Mob$"),
	"landnummer"          : new RegExp("^([0-9\+])*$"),
	"netnummer"           : new RegExp("^([0-9])*$"),
	"abonneenummer"       : new RegExp("^([0-9])*$"),
	"emailtype"           : new RegExp("^Pri|Zak|Mob$"),
	"telefoontype"        : new RegExp("^Pri|Zak|Mob$"),
	"aanmeldcode"         : new RegExp("^[A-Z]{2}[0-9]{2,3}$"),
	"productcode"         : new RegExp("^[A-Z]{1}[0-9]{4}|[A-Z]{2}[0-9]{3}$"),
	"betaalwijze"         : new RegExp("^[GEDAR]$"),
	"betaalfrequentie"    : new RegExp("^[GEJHKM]$"),
	"opzegreden"          : new RegExp("^[ABDEFGHIJKLNOPRSWZ]$"),
	"bedrag"              : new RegExp("^[GEJHKM]$"),
	"aantalproducten"     : new RegExp("^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$")
};

var DataValidators = {
	 "required" : function(value){return (value!="")}
	,"email" : function(value){return (value.split("@").length==2)}
}
	


var FormValidator = function(){
	var _this = this;
	this.version = "1.0";
	this.name    = "FormValidator";
	this.src     = "";
	this.gscope  = false; // if true appends class functions to global scope so that they can be called directly
	
	var ElementValidator = function(element){ 
		var _this = this;
		_this.element = DBScript.Dollar.$(element);
		_this.validators = {};
		
		_this.setValidator = function(name, func) {
			_this.validators[name] = func;
		}
		
		_this.validate = function(name) {
			return (!(_this.validators[name]) ? false : _this.validators[name](_this.getValue()));
		}
		
		_this.getValue = function(){
			var value = _this.element.value || "";
			return value;
		}
	}
	
	_this.newValidator = function(element){
		return new ElementValidator(element);
	}
};

FormValidator.prototype = {
	  form : ""
	, elements : new Array()
	, validator_stacks: new Object()
	
	, setElements : function(){
		for(var i=0;i<this.form.elements.length;i++){
			if(this.inspectable(this.form.elements[i])){
				this.elements.push(this.getElementId(this.form.elements[i]));
				this.validator_stacks[this.elements[this.elements.length-1]] = this.newValidator(this.form.elements[i]); // stuff in validator functions later
				this.setValidatorsFromClass(this.validator_stacks[this.elements[this.elements.length-1]], this.form.elements[i]);
			}
		}
	}
	
	, getElementId : function(element){
		var id = element.id || "";
		if(id=="") id = "__FORMVALIDATOR__" + this.elements.length;
		return id;
	}
	
	, inspectable : function(element){
		return (DBScript.Dollar.$(element) && (["input","select,textarea,button"].indexOf(DBScript.Dollar.$(element).tagName.toLowerCase())!=-1)) ? true : false;
	}

	, getElements : function(){
		return this.elements;
	}
	
    , getElementsStack : function(){
		return this.validator_stacks;
	}
	
	, init : function(id){
		this.form = DBScript.Dollar.$(id);
		this.setElements();
	}
	
	, setValidatorsFromClass : function(validator, element){
		var classes = element.className.split(" ");
		for(var c=0;c<classes.length;c++){
			switch(classes[c]){
				case "required":
					validator.setValidator("required", DataValidators["required"]);
					break;
				case "email":
					validator.setValidator("required", DataValidators["required"]);
					break;	
					
			}
		}
		return validator;
	}
}


</script>
</head><body>

<div id="canvas">
	<div id="content">
		<h1>DBScript Demo page</h1>
		<p>This is the DBScript demo page. View the source for the examples used in this page.</p>
		
		<h2>Popupwindow</h2>
		<p>View the source to see how the <a href="##loading" class="inline-popup-link">PopupWindow</a> Class is created.</p>
		
		<h2>Simple Form Validator</h2>
		<p>View the source to see how the <a href="##loading" class="inline-popup-link">Form validator</a> Class for the form below is created.</p>
		
		<style type="text/css">
		form .form-element {position: relative; width: 600px;}
		form .form-element label {width: 150px; margin-right: 10px; float: left;}
		form .form-element label span {position: absolute; display: none; font-size: 0.7em;}
		form .form-element label span.required-indicator {display: inline; top: 0px; margin-left: 3px;}
		form .form-element input {width: 280px; }
		form .form-element label span.errormessage {display: block; margin-left: 160px; margin-top: 5px; padding: 0.1em; color: red; font-weight: bold;}
		</style>
		<form id="myform" name="myform" method="post" action="index.cfm?act=xhr.postform" class="xhr">
			<fieldset><legend>Simple Form</legend>
			<p class="form-element">
				<label for="character-input">Character input
					<span class="required-indicator">*</span>
					<span class="errormessage">This field is required.</span>
					<span class="formatmessage">There should only be characters in this field.</span>
				</label>
				<input type="text" class="alpha required" name="character-input" id="character-input" value="" />
			</p>
			<p class="form-element">
				<label for="numeric-input">Numeric input
					<span class="required-indicator">*</span>
					<span class="errormessage">This field is required.</span>
					<span class="formatmessage">There should only be numbers in this field.</span>
				</label>
				<input type="text" class="numeric required" name="numeric-input" id="numeric-input" value="" />
			</p>
			<p class="form-element">
				<label for="date-input">Date input
					<span class="required-indicator">*</span>
					<span class="errormessage">This field is required.</span>
					<span class="formatmessage">The syntax for the dateformat is: dd/mm/yyyy. Please enter a valid date.</span>
				</label>
				<input type="text" class="date required" name="date-input" id="date-input" value="" />
			</p>
			<p class="form-element">
				<label for="email-input">Email input
					<span class="required-indicator">*</span>
					<span class="errormessage">This field is required.</span>
					<span class="formatmessage">Please enter a valid emailaddress.</span>
				</label>
				<input type="text" class="email required" name="email-input" id="email-input" value="" />
			</p>
			</fieldset>
			<input type="submit" class="submit" name="btnsubmit" id="btnsubmit" value="Send" />
		</form>
	</div>
</div>

<div id="loading" class="hidden">
	<div class="messagebox">
		<a href="##loading" class="inline-popup-close">close</a>
		<h2>Popupwindow</h2>
		<p>Loading ...</p>
	</div>
</div>

<script type="text/javascript">
var fv = new FormValidator();
fv.init("myform");

console.debug(fv.getElements());
console.debug(fv.getElementsStack());

var x= fv.newValidator("email-input");

fv.setValidatorsFromClass("email-input");

console.debug(x);

/*
DBScript.ElementValidator.init("email-input");
aFunc = function(v) {return v + ": value passed";}
DBScript.ElementValidator.setValidator("myfunction", aFunc);
bFunc = function(v) {return v + ": second value passed";}
DBScript.ElementValidator.setValidator("mysecfunction", bFunc);
console.debug(DBScript.ElementValidator.validate("myfunction"));
console.debug(DBScript.ElementValidator.validate("mysecfunction"));
*/

</script>

</body></html>
</cfoutput>


