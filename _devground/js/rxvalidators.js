rxValidator = function(){
	var _this = this;
	
	_this.isBankNr = function(){
		var __this = this;
		__this.test = function(val){
			var value=parseInt(val.replace(/\D/, ""));
			var ok = false;
			if(value<Math.pow(10,9)){
				if(value>=Math.pow(10,8)){
					var s=0,i,n=10,value=value.toString().split("");
					while(i=value.shift()){s+=i*(--n);}
					ok = (s%11==0);
				}
				if(value<=(9.7*Math.pow(10,6)) && value>=Math.pow(10,1)) ok = true; // geldig gironummer
			}
			return ok;
		}
	};
	
	_this.isValidBirthDate = function(){
		var __this = this;
		__this.test = function(val){
			var value=val.split('-');
			if(value[0]=='') return true;
			var ok = __this.isDate(value[0],value[1],value[2]);
			return ok;
		}
		
		__this.getYear = function(d) { 
			return (d < 1000) ? d + 1900 : d;
		}
		
		__this.isDate = function (year, month, day) {
			// month argument must be in the range 1 - 12
			month = month - 1;  // javascript month range : 0- 11
			var tempDate = new Date(year,month,day);
			if ((__this.getYear(tempDate.getYear()) == year) &&
				(month == tempDate.getMonth()) &&
				(day == tempDate.getDate()) ){
				var yr = tempDate.getFullYear();
				var today = new Date();
				var yr2 = today.getFullYear() - 100;
				var diff = Math.round(today.valueOf() - tempDate.valueOf());
				if(diff>=0 && yr > yr2) return true;
				else return false;
			}
			else {
				return false;
			}
		}
	};
	
	_this.isValidDate = function(){
		var __this = this;
		__this.test = function(val){
			var value=val.split('-');
			if(value[0]=='') return true;
			var ok = __this.isDate(value[0],value[1],value[2]);
			return ok;
		}
		
		__this.getYear = function(d) { 
			return (d < 1000) ? d + 1900 : d;
		}
		
		__this.isDate = function (year, month, day) {
			// month argument must be in the range 1 - 12
			month = month - 1;  // javascript month range : 0- 11
			var tempDate = new Date(year,month,day);
			if ((__this.getYear(tempDate.getYear()) == year) &&
				(month == tempDate.getMonth()) &&
				(day == tempDate.getDate()) ){
				return true;
			}
			else {
				return false;
			}
		}
	};
	
	_this.isMobNumber = function(){
		var __this = this;
		__this.test = function(val){
			return (val=='' || (val.substring(0,2)=='06' && val.length==10));
		}
	};
	
	_this.isTelNumber = function(){
		var __this = this;
		__this.test = function(val){
			return (val=='' || (val.substring(0,2)!='06' && val.length==10));
		}
	};
	
	_this.isAlgTelNummer = function(){
		var __this = this;
		__this.test = function(val){
			return (val=='' || (val.length==10 && val.substring(0,1)=='0'));
		}
	};
	
	_this.isValidEmail = function(){
		var __this = this;
		__this.test = function(val){
			if(val=="") return true;
			return isValidEmail(val);
		}
	};
	
	_this.isValidAmountChange = function(){
		var __this = this;
		__this.test = function(val){
			return checkTermijnBedrag(val);
		}
	};
	
	_this.isValidOrder = function(){
		var __this = this;
		__this.test = function(val){
			var aantalArray = $C("productaantal","select");
			var isOK = false;
			for(var i=0,el;i<aantalArray.length,el=aantalArray[i];i++){
				if(el.value>0) {
					isOK = true;
					break;
				}
			}
			return isOK;
		}
	};
	
	_this.isValidProdOrder = function(){
		var __this = this;
		__this.test = function(val){
			var aantalArray = $C("productaantalselect","select");
			var isOK = false;
			for(var i=0,el;i<aantalArray.length,el=aantalArray[i];i++){
				if(el.value>0) {
					isOK = true;
					break;
				}
			}
			return isOK;
		}
	};
	
	
	_this.isValidAanvraag = function(){
		var __this = this;
		__this.test = function(val){
			var aantalArray = $C("pakketaantal","select");
			var isOK = false;
			for(var i=0,el;i<aantalArray.length,el=aantalArray[i];i++){
				if(el.value>0) {
					isOK = true;
					break;
				}
			}
			return isOK;
		}
	};
	
	
	_this.isValidTussenvoegsel = function(){
		var __this = this;
		__this.test = function(val){
			if (val.length==0) {return true;}
			for (var i=1;i<=tnamei;i++) {
				if (val.toLowerCase() == tnames[i][2].toLowerCase()) {
					return true;
				}
			}
			return false;
		}
	};
	
	_this.isValidAchternaam = function(){
		var __this = this;
		__this.test = function(val){
			var rxAchternaam = new RegExp("^[a-zA-Z\u00c0-\u00c4\u00c8-\u00cf\u00d2-\u00d6\u00d9-\u00dc\u00e0-\u00ef\u00f1-\u00f6\u00f9-\u00fc'` -]*$");
			if(val.length<2) return false;
			return rxAchternaam.test(val);
		}
	};
	
	_this.isMax255 = function(){
		var __this = this;
		__this.test = function(val){
			return (val.length<=255);
		}
	};
	
	_this.isMax120 = function(){
		var __this = this;
		__this.test = function(val){
			return (val.length<=120);
		}
	};
	
	_this.isMin1 = function(){
		var __this = this;
		__this.test = function(val){
			return (val>0);
		}
	};
	
	_this.isValidAge = function(){
		var __this = this;
		__this.test = function(el){
			var bOk = false;
			var msg = "Voor het aanmelden van een MijnWNF account dient men minimaal 18 jaar te zijn.";
			var fieldset = getParentByTagName(el, "fieldset");
			var div = $C("splitdatewidget","div",fieldset);
			var els = $C("datewidget",null, div[0]);
			if(els.length==3){
				var val = els[2].value + "-" + els[1].value + "-" + els[0].value;
				var m = new _this.isValidDate();
				if(m.test(val)){
					var tempDate =  new Date(els[2].value,els[1].value-1,els[0].value);
					var today = new Date();
					var yr = tempDate.getFullYear();
					var yr2 = today.getFullYear() - 18;
					var tempDate2 = new Date(yr2, today.getMonth(), today.getDate())
					var diff = Math.round(tempDate2.valueOf() - tempDate.valueOf());
					if(diff>=0 && els[2].value!='' && els[0].value!=0) return true;
					else{ 
						alert(msg);
						return false;
					}
				}
				else {
					alert(msg);
					return false
				}
			}
			return true;
		}
	};
	
	_this.isValidAdoptieProduct = function(){
		var __this = this;
		__this.test = function(val){
			return val>0;
		}
	
	};
	
	_this.isValidRadioProduct = function(){
		var __this = this;
		__this.test = function(val){
			var radioArray = $C("prodtableradio","input");
			var isOK = false;
			for(var i=0,el;i<radioArray.length,el=radioArray[i];i++){
				if(el.checked) {
					isOK = true;
					break;
				}
			}
			return isOK;
		}
	
	}
	
	_this.rxValidators = {
		"titel_voor"          : new RegExp("^[a-zA-Z\. ]*$"),
		"voorletters"         : new RegExp("^([a-zA-Z\. ])*$"),
		"voornaam"            : new RegExp("^[a-zA-Z\u00c0-\u00c4\u00c8-\u00cf\u00d2-\u00d6\u00d9-\u00dc\u00e0-\u00ef\u00f1-\u00f6\u00f9-\u00fc'` -]*$"),
		/*"tussenvoegsel"    : new RegExp("^[a-zA-Z\.' ]*$"),*/
		/*"achternaam"          : new RegExp("^[a-zA-Z\u00c0-\u00c4\u00c8-\u00cf\u00d2-\u00d6\u00d9-\u00dc\u00e0-\u00ef\u00f1-\u00f6\u00f9-\u00fc'` -]*$"),*/
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
		"aantalproducten"     : new RegExp("^([0-9]|[1-9][0-9]|[1-9][0-9][0-9])$"),
		"banknr"              : new _this.isBankNr(),
		"splitdate"           : new _this.isValidBirthDate(),
		"mobnummer"           : new _this.isMobNumber(),
		"telnummer"           : new _this.isTelNumber(),
		"algnummer"			  : new _this.isAlgTelNummer(),
		"email"			      : new _this.isValidEmail(),
		"emailwidget"         : new _this.isValidEmail(),
		"wijzigtermijnbedrag" : new _this.isValidAmountChange(),
		"kalendercheck"       : new _this.isValidOrder(),
		"producttabel"        : new _this.isValidProdOrder(),
		"promovrijwilligcheck": new _this.isValidAanvraag(),
		"tussenvoegsel"       : new _this.isValidTussenvoegsel(),
		"achternaam"          : new _this.isValidAchternaam(),
		"leeftijdcontrole"    : new _this.isValidAge(),
		"slagzin"			  : new _this.isMax255(),
		"datumcontrole"       : new _this.isValidDate(),
		"adoptiecheck"		  : new _this.isValidAdoptieProduct(),
		"max120"			  : new _this.isMax120(),
		"prodaantal"		  : new _this.isMin1(),
		"radioproducttabel"   : new _this.isValidRadioProduct()
	};
	
	_this.validateElementByClass = function(el){
		var val = _this.getElementValueForClass(el);
		var cls = el.className.trim(); // IE6 heeft een bug als er lege elementen in de array staan
		var checks = cls.split(" ");
		var isValid = true;
		for(var i=0,chk;i<checks.length,chk=checks[i];i++){
			if(_this.rxValidators[chk]){
				/*if(console) console.debug("Checking class: " + chk + " against:" + val);*/
				isValid = _this.rxValidators[chk].test(val);
				if(!isValid) break;
			}
		}
		return isValid;
	}
	
	_this.getElementValueForClass = function(el){
		if(hasClass(el,"leeftijdcontrole")){
			return el;
		}
		if(hasClass(el,"splitdate")){
			var div = getParentByTagName(el, "div");
			var els = $C("datewidget",null,div);
			if(els.length!=3) return "";
			var out = els[2].value + "-" + els[1].value + "-" + els[0].value;
			return out;
		}
		if(hasClass(el,"mobnummer") || hasClass(el,"telnummer") || hasClass(el,"algnummer")){
			var el2 = el.id.split("_")[0] + "_kiesnummer";
			var out = el.value + $(el.id.split("_")[0] + "_kiesnummer").value;
			return out;
		}
		if(hasClass(el,"datumcontrole")){
			var div = getParentByTagName(el, "div");
			var els = $C("datewidget",null,div);
			if(els.length!=3) return "";
			var out = els[2].value + "-" + els[1].value + "-" + els[0].value;
			return out;
		}
		/*el.value = el.value.trim();*/
		return el.value;
	}
	
	_this.validateEvent = function(e){
		if(!e) e= window.event;
		var el = getTargetElement(e);
		if(!_this.validateElementByClass(el)) {
			cancelEvent(e);
		}
	}
}



