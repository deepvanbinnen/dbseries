DBScript.register(function () {
	this.version = "2.0";
	this.name    = "TableClass";
	this.src     = "tables.js";
	this.gscope  = true; // appends class functions to global scope so that they can be called directly
	
	DBScript.addFunctionsToContext( {
		toString : function(){
			return this.name;
		},
		
		onWinLoad : function(){
			// any call which should execute after the DOM has been loaded goes here
		},
		
		sortColumn : function(e){
			var getColIndex = function(column){
				var row  = getParentByTagName(column, "tr");
				var cols = row.getElementsByTagName(column.tagName);
				for(var i=0;i<cols.length;i++) 
					if(cols[i]==column)
						return i;
				return -1;
			}
			
			var getColSorter = function(column){
				if(hasClass(column, "numeric")) return numericSort;
				if(hasClass(column, "alpha"))   return alphaSort;
				return;
			}
			
			var numericSort = function(v1, v2){
				var v1 = parseFloat(v1);
				var v2 = parseFloat(v2);
				return v1-v2;
			}
			
			var alphaSort = function(v1, v2){
				var len = (v1.length>v2.length) ? v2.length : v1.length;
				for(var i=0;i<len;i++){
					if(v1[i]>v2[i]) return 1;
					if(v1[i]<v2[i]) return -1;
				}
				return v1.length-v2.length;
			}
			
			var getInnerText = function(elm, txt){
				var txt = txt || "";
				for(var i=0, el;i<elm.childNodes.length, el=elm.childNodes[i];i++){
					switch(el.nodeType){
						case 1:
							txt += getInnerText(el, txt);
						case 3: 
							txt += el.nodeValue;
					}
				}
				return txt;
			}
			
			var getSortType = function(column){
				if(hasClass(column, "reverse")){
					return false
				}
				return true;
			}
			
			var swapSortType = function(column){
				if(hasClass(column, "reverse")){
					removeClass(column, "reverse");
				}
				else {
					addClass(column, "reverse");
				}
				return;
			}
			
			var column = getTargetElement(e);
			var table = getParentByTagName(column, "table");
			var colindex = getColIndex(column);
			var sortFunction = getColSorter(column);
			var tbody = table.getElementsByTagName("tbody")[0];
			var trows = tbody.getElementsByTagName("tr");
			var sortASC = getSortType(column);
			swapSortType(column);
			
			for(var i=0,l=trows.length;i<l;i++){
				var colval = getInnerText(trows[i].getElementsByTagName("td")[colindex]);
				var moverow = trows[i];
				for(var j=i-1;j>=0;j--){
					var compval = getInnerText(trows[j].getElementsByTagName("td")[colindex]);
					var res = sortFunction(colval, compval);
					if ((res<0 && sortASC) || (res>0 && !sortASC)){
						tbody.insertBefore(moverow,trows[j]);
						moverow = trows[j];
					}
					else {
						break;
					}
				}
			}
		}
	}, this.constructor.prototype);
});




