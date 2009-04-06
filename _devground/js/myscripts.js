var PopupWindow = {
	show : function(){
		$("popupinfo").style.display = "block";
		window.scrollTo(0,0);
		DBScript.Events.addEvent("popupclose", "click", PopupWindow.close);
	}
	
	, close : function(){
		DBScript.Events.removeEvent("popupclose", "click", PopupWindow.close);
		$("popupinfo").style.display = "none";
	}
};