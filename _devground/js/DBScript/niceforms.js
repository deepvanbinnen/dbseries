/*#############################################################
Name: Niceforms
Version: 1.0
Author: Lucian Slatineanu
URL: http://www.badboy.ro/

Name: Niceforms Embedded
Version: 1.1
Author: Deepak Bhikharie
URL: http://www.e-vision.nl/

Feel free to use and modify but please provide credits.
#############################################################*/

//Global Variables

	
NiceForms = function(){
	this.version = "1.1";
	this.name    = "NiceForms";
	this.src     = "niceforms.js";
	this.gscope  = false; // whether to define 
}

NiceForms.prototype = {
	//Initialization function - if you have any other 'onload' functions, add them here
	init : function() {
		if(!document.getElementById) {return false;}
		NiceForms.preloadImages();
		NiceForms.getElements();
		NiceForms.separateElements();
		NiceForms.replaceRadios();
		NiceForms.replaceCheckboxes();
		NiceForms.replaceSelects();
		if(!NiceForms.isMac.test(navigator.vendor)) {
			NiceForms.replaceTexts();
			NiceForms.replaceTextareas();
			NiceForms.buttonHovers();
		}
	},
	
	
	//preloading required images
	preloadImages : function() {
		preloads = new Object();
		preloads[0] = new Image(); preloads[0].src = NiceForms.imagesPath + "button_left_xon.gif";
		preloads[1] = new Image(); preloads[1].src = NiceForms.imagesPath + "button_right_xon.gif";
		preloads[2] = new Image(); preloads[2].src = NiceForms.imagesPath + "input_left_xon.gif";
		preloads[3] = new Image(); preloads[3].src = NiceForms.imagesPath + "input_right_xon.gif";
		preloads[4] = new Image(); preloads[4].src = NiceForms.imagesPath + "txtarea_bl_xon.gif";
		preloads[5] = new Image(); preloads[5].src = NiceForms.imagesPath + "txtarea_br_xon.gif";
		preloads[6] = new Image(); preloads[6].src = NiceForms.imagesPath + "txtarea_cntr_xon.gif";
		preloads[7] = new Image(); preloads[7].src = NiceForms.imagesPath + "txtarea_l_xon.gif";
		preloads[8] = new Image(); preloads[8].src = NiceForms.imagesPath + "txtarea_tl_xon.gif";
		preloads[9] = new Image(); preloads[9].src = NiceForms.imagesPath + "txtarea_tr_xon.gif";
	},
	
	//getting all the required elements
	getElements : function () {
		var re = new RegExp('(^| )'+'niceform'+'( |$)');
		for (var nf = 0; nf < document.getElementsByTagName('form').length; nf++) {
			if(re.test(NiceForms.niceforms[nf].className)) {
				for(var nfi = 0; nfi < document.forms[nf].getElementsByTagName('input').length; nfi++) {NiceForms.inputs.push(document.forms[nf].getElementsByTagName('input')[nfi]);}
				for(var nfl = 0; nfl < document.forms[nf].getElementsByTagName('label').length; nfl++) {NiceForms.labels.push(document.forms[nf].getElementsByTagName('label')[nfl]);}
				for(var nft = 0; nft < document.forms[nf].getElementsByTagName('textarea').length; nft++) {NiceForms.textareas.push(document.forms[nf].getElementsByTagName('textarea')[nft]);}
				for(var nfs = 0; nfs < document.forms[nf].getElementsByTagName('select').length; nfs++) {NiceForms.selects.push(document.forms[nf].getElementsByTagName('select')[nfs]);}
			}
		}
	},
	
	//separating all the elements in their respective arrays
	separateElements : function() {
		var r = 0; var c = 0; var t = 0; var rl = 0; var cl = 0; var tl = 0; var b = 0;
		for (var q = 0; q < NiceForms.inputs.length; q++) {
			if(NiceForms.inputs[q].type == 'radio') {
				NiceForms.radios[r] = NiceForms.inputs[q]; ++r;
				for(var w = 0; w < NiceForms.labels.length; w++) {if(NiceForms.labels[w].htmlFor == NiceForms.inputs[q].id) {if(NiceForms.inputs[q].checked) {NiceForms.labels[w].className = "chosen";} NiceForms.radioLabels[rl] = NiceForms.labels[w]; ++rl;}}
			}
			if(NiceForms.inputs[q].type == 'checkbox') {
				NiceForms.checkboxes[c] = NiceForms.inputs[q]; ++c;
				for(var w = 0; w < NiceForms.labels.length; w++) {if(NiceForms.labels[w].htmlFor == NiceForms.inputs[q].id) {if(NiceForms.inputs[q].checked) {NiceForms.labels[w].className = "chosen";} NiceForms.checkboxLabels[cl] = NiceForms.labels[w]; ++cl;}}
			}
			if((NiceForms.inputs[q].type == "text") || (NiceForms.inputs[q].type == "password")) {NiceForms.texts[t] = NiceForms.inputs[q]; ++t;}
			if((NiceForms.inputs[q].type == "submit") || (NiceForms.inputs[q].type == "button")) {NiceForms.buttons[b] = NiceForms.inputs[q]; ++b;}
		}
	},
	
	replaceRadios : function () {
		for (var q = 0; q < NiceForms.radios.length; q++) {
			//move NiceForms.radios out of the way
			NiceForms.radios[q].className = "outtaHere";
			//create div
			var radioArea = document.createElement('div');
			if(NiceForms.radios[q].checked) {radioArea.className = "radioAreaChecked";} else {radioArea.className = "radioArea";}
			radioArea.style.left = NiceForms.findPosX(NiceForms.radios[q]) + 'px';
			radioArea.style.top = NiceForms.findPosX(NiceForms.radios[q]) + 'px';
			radioArea.style.margin = "1px";
			radioArea.id = "myRadio" + q;
			//insert div
			NiceForms.radios[q].parentNode.insertBefore(radioArea, NiceForms.radios[q]);
			//assign actions
			radioArea.onclick = new Function('NiceForms.rechangeRadios('+q+')');
			NiceForms.radioLabels[q].onclick = new Function('NiceForms.rechangeRadios('+q+')');
			if(!NiceForms.ie) {NiceForms.radios[q].onfocus = new Function('NiceForms.focusRadios('+q+')'); NiceForms.radios[q].onblur = new Function('NiceForms.blurRadios('+q+')');}
			NiceForms.radios[q].onclick = NiceForms.radioEvent;
		}
		return true;
	},
	
	focusRadios : function (who) {
		var what = document.getElementById('myRadio'+who);
		what.style.border = "1px dotted #333"; what.style.margin = "0";
		return false;
	},
	
	blurRadios : function (who) {
		var what = document.getElementById('myRadio'+who);
		what.style.border = "0"; what.style.margin = "1px";
		return false;
	},
	
	checkRadios : function (who) {
		var what = document.getElementById('myRadio'+who);
		others = document.getElementsByTagName('div');
		for(var q = 0; q < others.length; q++) {if((others[q].className == "radioAreaChecked")&&(others[q].nextSibling.name == NiceForms.radios[who].name)) {others[q].className = "radioArea";}}
		what.className = "radioAreaChecked";
	},
	
	changeRadios : function (who) {
		if(NiceForms.radios[who].checked) {
			for(var q = 0; q < NiceForms.radios.length; q++) {if(NiceForms.radios[q].name == NiceForms.radios[who].name) {NiceForms.radios[q].checked = false; NiceForms.radioLabels[q].className = "";}} 
			NiceForms.radios[who].checked = true; NiceForms.radioLabels[who].className = "chosen";
			NiceForms.checkRadios(who);
		}
	},
	
	rechangeRadios : function (who) {
		if(!NiceForms.radios[who].checked) {
			for(var q = 0; q < NiceForms.radios.length; q++) {if(NiceForms.radios[q].name == NiceForms.radios[who].name) {NiceForms.radios[q].checked = false; NiceForms.radioLabels[q].className = "";}}
			NiceForms.radios[who].checked = true; NiceForms.radioLabels[who].className = "chosen";
			NiceForms.checkRadios(who);
		}
	},
	
	radioEvent : function (e) {
		if (!e) var e = window.event;
		if(e.type == "click") {for (var q = 0; q < NiceForms.radios.length; q++) {if(this == NiceForms.radios[q]) {NiceForms.changeRadios(q); break;}}}
	},
	
	replaceCheckboxes : function() {
		for (var q = 0; q < NiceForms.checkboxes.length; q++) {
			//move checkboxes out of the way
			NiceForms.checkboxes[q].className = "outtaHere";
			//create div
			var checkboxArea = document.createElement('div');
			if(NiceForms.checkboxes[q].checked) {checkboxArea.className = "checkboxAreaChecked";} else {checkboxArea.className = "checkboxArea";}
			checkboxArea.style.left = NiceForms.findPosX(NiceForms.checkboxes[q]) + 'px';
			checkboxArea.style.top = NiceForms.findPosX(NiceForms.checkboxes[q]) + 'px';
			checkboxArea.style.margin = "1px";
			checkboxArea.id = "myCheckbox" + q;
			//insert div
			NiceForms.checkboxes[q].parentNode.insertBefore(checkboxArea, NiceForms.checkboxes[q]);
			//asign actions
			checkboxArea.onclick = new Function('NiceForms.rechangeCheckboxes('+q+')');
			if(!NiceForms.isMac.test(navigator.vendor)) {NiceForms.checkboxLabels[q].onclick = new Function('NiceForms.changeCheckboxes('+q+')');}
			else {NiceForms.checkboxLabels[q].onclick = new Function('NiceForms.rechangeCheckboxes('+q+')');}
			if(!NiceForms.ie) {NiceForms.checkboxes[q].onfocus = new Function('NiceForms.focusCheckboxes('+q+')'); NiceForms.checkboxes[q].onblur = new Function('NiceForms.blurCheckboxes('+q+')');}
			NiceForms.checkboxes[q].onkeydown = NiceForms.checkEvent;
		}
		return true;
	},
	
	focusCheckboxes : function(who) {
		var what = document.getElementById('myCheckbox'+who);
		what.style.border = "1px dotted #333"; what.style.margin = "0";
		return false;
	},
	
	blurCheckboxes : function(who) {
		var what = document.getElementById('myCheckbox'+who);
		what.style.border = "0"; what.style.margin = "1px";
		return false;
	},
	
	checkCheckboxes : function(who, action) {
		var what = document.getElementById('myCheckbox'+who);
		if(action == true) {what.className = "checkboxAreaChecked";}
		if(action == false) {what.className = "checkboxArea";}
	},
	
	changeCheckboxes : function(who) {
		if(NiceForms.checkboxLabels[who].className == "chosen") {
			NiceForms.checkboxes[who].checked = true;
			NiceForms.checkboxLabels[who].className = "";
			NiceForms.checkCheckboxes(who, false);
		}
		else if(NiceForms.checkboxLabels[who].className == "") {
			NiceForms.checkboxes[who].checked = false;
			NiceForms.checkboxLabels[who].className = "chosen";
			NiceForms.checkCheckboxes(who, true);
		}
	},
	
	rechangeCheckboxes : function (who) {
		var tester = false;
		if(NiceForms.checkboxLabels[who].className == "chosen") {
			tester = false;
			NiceForms.checkboxLabels[who].className = "";
		}
		else if(NiceForms.checkboxLabels[who].className == "") {
			tester = true;
			NiceForms.checkboxLabels[who].className = "chosen";
		}
		NiceForms.checkboxes[who].checked = tester;
		NiceForms.checkCheckboxes(who, tester);
	},
	
	checkEvent : function(e) {
		if (!e) var e = window.event;
		if(e.keyCode == 32) {for (var q = 0; q < NiceForms.checkboxes.length; q++) {if(this == NiceForms.checkboxes[q]) {NiceForms.changeCheckboxes(q);}}} //check if space is pressed
	},
	
	replaceSelects : function() {
	    for(var q = 0; q < NiceForms.selects.length; q++) {
			//create and build div structure
			var selectArea = document.createElement('div');
			var left = document.createElement('div');
			var right = document.createElement('div');
			var center = document.createElement('div');
			var button = document.createElement('a');
			var text = document.createTextNode(NiceForms.selectText);
			center.id = "mySelectText"+q;
			var selectWidth = parseInt(NiceForms.selects[q].className.replace(/width_/g, ""));
			center.style.width = selectWidth - 10 + 'px';
			selectArea.style.width = selectWidth + NiceForms.selectRightSideWidth + NiceForms.selectLeftSideWidth + 'px';
			button.style.width = selectWidth + NiceForms.selectRightSideWidth + NiceForms.selectLeftSideWidth + 'px';
			button.style.marginLeft = - selectWidth - NiceForms.selectLeftSideWidth + 'px';
			button.href = "javascript:showOptions("+q+")";
			button.onkeydown = selectEvent;
			button.className = "selectButton"; //class used to check for mouseover
			selectArea.className = "selectArea";
			selectArea.id = "sarea"+q;
			left.className = "left";
			right.className = "right";
			center.className = "center";
			right.appendChild(button);
			center.appendChild(text);
			selectArea.appendChild(left);
			selectArea.appendChild(right);
			selectArea.appendChild(center);
			//hide the select field
	        NiceForms.selects[q].style.display='none'; 
			//insert select div
			NiceForms.selects[q].parentNode.insertBefore(selectArea, NiceForms.selects[q]);
			//build & place options div
			var optionsDiv = document.createElement('div');
			optionsDiv.style.width = selectWidth + 1 + 'px';
			optionsDiv.className = "optionsDivInvisible";
			optionsDiv.id = "optionsDiv"+q;
			optionsDiv.style.left = NiceForms.findPosX(selectArea) + 'px';
			optionsDiv.style.top = NiceForms.findPosX(selectArea) + NiceForms.selectAreaHeight - NiceForms.selectAreaOptionsOverlap + 'px';
			//get select's options and add to options div
			for(var w = 0; w < NiceForms.selects[q].options.length; w++) {
				var optionHolder = document.createElement('p');
				var optionLink = document.createElement('a');
				var optionTxt = document.createTextNode(NiceForms.selects[q].options[w].text);
				optionLink.href = "javascript:showOptions("+q+"); selectMe('"+NiceForms.selects[q].id+"',"+w+","+q+");";
				optionLink.appendChild(optionTxt);
				optionHolder.appendChild(optionLink);
				optionsDiv.appendChild(optionHolder);
				//check for pre-selected items
				if(NiceForms.selects[q].options[w].selected) {selectMe(NiceForms.selects[q].id,w,q);}
			}
			//insert options div
			document.getElementsByTagName("body")[0].appendChild(optionsDiv);
		}
	},
	
	showOptions : function(g) {
			elem = document.getElementById("optionsDiv"+g);
			if(elem.className=="optionsDivInvisible") {elem.className = "optionsDivVisible";}
			else if(elem.className=="optionsDivVisible") {elem.className = "optionsDivInvisible";}
			elem.onmouseout = hideOptions;
	},
	
	hideOptions : function(e) { //hiding the options on mouseout
		if (!e) var e = window.event;
		var reltg = (e.relatedTarget) ? e.relatedTarget : e.toElement;
		if(((reltg.nodeName != 'A') && (reltg.nodeName != 'DIV')) || ((reltg.nodeName == 'A') && (reltg.className=="selectButton") && (reltg.nodeName != 'DIV'))) {this.className = "optionsDivInvisible";};
		e.cancelBubble = true;
		if (e.stopPropagation) e.stopPropagation();
	},
	
	selectMe : function(selectFieldId,linkNo,selectNo) {
		//feed selected option to the actual select field
		selectField = document.getElementById(selectFieldId);
		for(var k = 0; k < selectField.options.length; k++) {
			if(k==linkNo) {selectField.options[k].selected = "selected";}
			else {selectField.options[k].selected = "";}
		}
		//show selected option
		textVar = document.getElementById("mySelectText"+selectNo);
		var newText = document.createTextNode(selectField.options[linkNo].text);
		textVar.replaceChild(newText, textVar.childNodes[0]);
	},
	
	selectEvent : function(e) {
		if (!e) var e = window.event;
		var thecode = e.keyCode;
		switch(thecode){
			case 40: //down
				var fieldId = this.parentNode.parentNode.id.replace(/sarea/g, "");
				var linkNo = 0;
				for(var q = 0; q < NiceForms.selects[fieldId].options.length; q++) {if(NiceForms.selects[fieldId].options[q].selected) {linkNo = q;}}
				++linkNo;
				if(linkNo >= NiceForms.selects[fieldId].options.length) {linkNo = 0;}
				selectMe(NiceForms.selects[fieldId].id, linkNo, fieldId);
				break;
			case 38: //up
				var fieldId = this.parentNode.parentNode.id.replace(/sarea/g, "");
				var linkNo = 0;
				for(var q = 0; q < NiceForms.selects[fieldId].options.length; q++) {if(NiceForms.selects[fieldId].options[q].selected) {linkNo = q;}}
				--linkNo;
				if(linkNo < 0) {linkNo = NiceForms.selects[fieldId].options.length - 1;}
				selectMe(NiceForms.selects[fieldId].id, linkNo, fieldId);
				break;
			default:
				break;
		}
	},
	
	replaceTexts : function() {
		for(var q = 0; q < NiceForms.texts.length; q++) {
			NiceForms.texts[q].style.width = NiceForms.texts[q].size * 10 + 'px';
			txtLeft = document.createElement('img'); txtLeft.src = NiceForms.imagesPath + "input_left.gif"; txtLeft.className = "inputCorner";
			txtRight = document.createElement('img'); txtRight.src = NiceForms.imagesPath + "input_right.gif"; txtRight.className = "inputCorner";
			NiceForms.texts[q].parentNode.insertBefore(txtLeft, NiceForms.texts[q]);
			NiceForms.texts[q].parentNode.insertBefore(txtRight, NiceForms.texts[q].nextSibling);
			NiceForms.texts[q].className = "textinput";
			//create hovers
			NiceForms.texts[q].onfocus = function() {
				this.className = "textinputHovered";
				this.previousSibling.src = NiceForms.imagesPath + "input_left_xon.gif";
				this.nextSibling.src = NiceForms.imagesPath + "input_right_xon.gif";
			}
			NiceForms.texts[q].onblur = function() {
				this.className = "textinput";
				this.previousSibling.src = NiceForms.imagesPath + "input_left.gif";
				this.nextSibling.src = NiceForms.imagesPath + "input_right.gif";
			}
		}
	},
	
	replaceTextareas : function() {
		for(var q = 0; q < NiceForms.textareas.length; q++) {
			var where = NiceForms.textareas[q].parentNode;
			var where2 = NiceForms.textareas[q].previousSibling;
			NiceForms.textareas[q].style.width = NiceForms.textareas[q].cols * 10 + 'px';
			NiceForms.textareas[q].style.height = NiceForms.textareas[q].rows * 10 + 'px';
			//create divs
			var container = document.createElement('div');
			container.className = "txtarea";
			container.style.width = NiceForms.textareas[q].cols * 10 + 20 + 'px';
			container.style.height = NiceForms.textareas[q].rows * 10 + 20 + 'px';
			var topRight = document.createElement('div');
			topRight.className = "tr";
			var topLeft = document.createElement('img');
			topLeft.className = "txt_corner";
			topLeft.src = NiceForms.imagesPath + "txtarea_tl.gif";
			var centerRight = document.createElement('div');
			centerRight.className = "cntr";
			var centerLeft = document.createElement('div');
			centerLeft.className = "cntr_l";
			if(!NiceForms.ie) {centerLeft.style.height = NiceForms.textareas[q].rows * 10 + 10 + 'px';}
			else {centerLeft.style.height = NiceForms.textareas[q].rows * 10 + 12 + 'px';}
			var bottomRight = document.createElement('div');
			bottomRight.className = "br";
			var bottomLeft = document.createElement('img');
			bottomLeft.className = "txt_corner";
			bottomLeft.src = NiceForms.imagesPath + "txtarea_bl.gif";
			//assemble divs
			container.appendChild(topRight);
			topRight.appendChild(topLeft);
			container.appendChild(centerRight);
			centerRight.appendChild(centerLeft);
			centerRight.appendChild(NiceForms.textareas[q]);
			container.appendChild(bottomRight);
			bottomRight.appendChild(bottomLeft);
			//insert structure
			where.insertBefore(container, where2);
			//create hovers
			NiceForms.textareas[q].onfocus = function() {
				this.previousSibling.className = "cntr_l_xon";
				this.parentNode.className = "cntr_xon";
				this.parentNode.previousSibling.className = "tr_xon";
				this.parentNode.previousSibling.getElementsByTagName("img")[0].src = NiceForms.imagesPath + "txtarea_tl_xon.gif";
				this.parentNode.nextSibling.className = "br_xon";
				this.parentNode.nextSibling.getElementsByTagName("img")[0].src = NiceForms.imagesPath + "txtarea_bl_xon.gif";
			}
			NiceForms.textareas[q].onblur = function() {
				this.previousSibling.className = "cntr_l";
				this.parentNode.className = "cntr";
				this.parentNode.previousSibling.className = "tr";
				this.parentNode.previousSibling.getElementsByTagName("img")[0].src = NiceForms.imagesPath + "txtarea_tl.gif";
				this.parentNode.nextSibling.className = "br";
				this.parentNode.nextSibling.getElementsByTagName("img")[0].src = NiceForms.imagesPath + "txtarea_bl.gif";
			}
		}
	},
	
	buttonHovers : function () {
		for (var i = 0; i < NiceForms.buttons.length; i++) {
			NiceForms.buttons[i].className = "buttonSubmit";
			var buttonLeft = document.createElement('img');
			buttonLeft.src = NiceForms.imagesPath + "button_left.gif";
			buttonLeft.className = "buttonImg";
			NiceForms.buttons[i].parentNode.insertBefore(buttonLeft, NiceForms.buttons[i]);
			var buttonRight = document.createElement('img');
			buttonRight.src = NiceForms.imagesPath + "button_right.gif";
			buttonRight.className = "buttonImg";
			if(NiceForms.buttons[i].nextSibling) {NiceForms.buttons[i].parentNode.insertBefore(buttonRight, NiceForms.buttons[i].nextSibling);}
			else {NiceForms.buttons[i].parentNode.appendChild(buttonRight);}
			NiceForms.buttons[i].onmouseover = function() {
				this.className += "Hovered";
				this.previousSibling.src = NiceForms.imagesPath + "button_left_xon.gif";
				this.nextSibling.src = NiceForms.imagesPath + "button_right_xon.gif";
			}
			NiceForms.buttons[i].onmouseout = function() {
				this.className = this.className.replace(/Hovered/g, "");
				this.previousSibling.src = NiceForms.imagesPath + "button_left.gif";
				this.nextSibling.src = NiceForms.imagesPath + "button_right.gif";
			}
		}
	},
	
	//Useful functions
	findPosY : function(obj) {
		var posTop = 0;
		while (obj.offsetParent) {posTop += obj.offsetTop; obj = obj.offsetParent;}
		return posTop;
	},
	
	findPosX : function(obj) {
		var posLeft = 0;
		while (obj.offsetParent) {posLeft += obj.offsetLeft; obj = obj.offsetParent;}
		return posLeft;
	}
}




NiceForms.prototype.niceforms = document.getElementsByTagName('form'); 
NiceForms.prototype.inputs = new Array(); 
NiceForms.prototype.labels = new Array(); 
NiceForms.prototype.radios = new Array(); 
NiceForms.prototype.radioLabels = new Array(); 
NiceForms.prototype.checkboxes = new Array(); 
NiceForms.prototype.checkboxLabels = new Array(); 
NiceForms.prototype.texts = new Array(); 
NiceForms.prototype.textareas = new Array(); 
NiceForms.prototype.selects = new Array(); 
NiceForms.prototype.selectText = "please select"; 
NiceForms.prototype.agt = navigator.userAgent.toLowerCase(); 

NiceForms.prototype.ie = /*@cc_on !@*/false;
// this.ie = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1)); 


NiceForms.prototype.hovers = new Array(); 
NiceForms.prototype.buttons = new Array(); 
NiceForms.prototype.isMac = new RegExp('(^|)'+'Apple'+'(|$)');

//Theme Variables - edit these to match your theme
NiceForms.prototype.selectRightSideWidth = 21;
NiceForms.prototype.selectLeftSideWidth = 8;
NiceForms.prototype.selectAreaHeight = 21;
NiceForms.prototype.selectAreaOptionsOverlap = 2;
NiceForms.prototype.imagesPath = "images/";






// window.onload = init;