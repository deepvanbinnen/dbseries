DBScript.register(function() {
	this.name = "FormElement";
		
	var self = this;
	self.element = null;
	
	self.group = [];
	self.groupindex = 0;
	self.groupid = "";
	
	self.is_checkbox = false;
	self.is_radio = false;
	self.is_checked  = false;
	
	self.is_select = false;
	self.is_multiple  = false;
	
	self.current_value = null;
	self.first_value = null;
	
	DBScript.addFunctionsToContext( {
		init : function(element) {
			self.element = DBScript.$(element);
			if(self.element){
				switch(self.element.tagName.toLowerCase()) {
					case "input":
						switch(self.element.type.toLowerCase()){
							case "checkbox":
								self.is_checkbox = true;
							case "radio":
								self.is_radio = true;
							default:
								var gr = DBScript.getParentByTagName(self.element, "form");
								if(gr[self.element.name]){
									self.group = gr[self.element.name];
									for(var i=0;i<self.group.length;i++){
										if(self.group[i]===el){
											self.groupindex = i;
											break;
										}
									}
								}
						}
						break;
					case "select":
						self.is_select = true;
						if(self.element.multiple){
							self.is_multiple = self.element.multiple;
						}
						break;	
					case "textarea":
						break;
					default:
				}
				
				self.setValueFromElement();
				
				DBScript.copyProps(self.element, self, {
					  "value" : "first_value"
					, "id"    : "id"
					, "name"  : "formname"
					, "checked" : "is_checked"
				});
				
				
				DBScript.Events.addEvent(self.element, "change", self.setValueFromElement);
				DBScript.Events.addEvent(self.element, "keydown", self.keyPress_cb);
			}
		}

		, getElement : function() {
			return self.element;
		}
		, getGroup : function() {
			return self.group;
		}
		, isCheckbox : function() {
			return self.is_checkbox;
		}
		, isRadio : function() {
			return self.is_radio;
		}
		, isSelect : function() {
			return self.is_select;
		}
		, isMultipleSelect : function() {
			return self.is_multiple;
		}
		, getValue : function() {
			return self.current_value;
		}
		, setGroup : function(group){
			self.group = group;
		}
		, isChecked : function(){
			return self.is_checked;
		}
		, isCheckable : function(){
			return self.is_checkbox || self.is_radio;
		}
		, hasValue : function(){
			return (self.value!=null);
		}
		, setValueFromElement : function(e){
			var el = DBScript.Events.getTargetElement(e) || self.element;
			self.current_value = el.value; 
			self.setChecked();
		}
		, setValue : function(val){
			self.current_value = self.element.value = val; 
		}
		, setChecked : function(){
			if(self.isCheckable()) 
				self.checked = self.element.checked;
		}
		, getName : function(){
			return self.formname;
		}
		, getId : function(){
			return self.id;
		}
		, getInitValue : function(){
			return self.first_value;
		}
		, hasChanged : function(){
			return (self.first_value!=self.current_value);
		}
		, keyPress_cb : function(e){
			// DBScript.echo( e, true );
			
			DBScript.echo( DBScript.Events.getKey(e), true );
		}
	
	}, this.constructor.prototype);
}, false, "FormElement");