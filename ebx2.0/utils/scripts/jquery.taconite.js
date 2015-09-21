(function($) {
	/**
	 * $ is an alias to jQuery object
	 *
	 */

	function prepData(data) {
	    if(typeof(data) == "undefined") {
	        return {_ts : new Date().getTime()};
	    }
	    else if(typeof(data) == "string") {
	        return data + "&_ts=" + new Date().getTime();
	    }
	    else if(typeof(data) == "object") {
	        data._ts = new Date().getTime();
	        return data;
	    }
	    return data;
	}
	
	jQuery.taconiteGet = function(url, data) {
	    $.get(url, prepData(data), function(data, textStatus){new TaconiteJQueryParser().parse(data);});
	};
	
	
	jQuery.taconitePost = function(url, data) {
	    $.post(url, prepData(data), function(data, textStatus){new TaconiteJQueryParser().parse(data);});
	};
	
	jQuery.taconiteAjax = function(settings) {
	    settings.dataType = "xml";
	    settings.cache = false;
	    settings.success = function(data, textStatus, xhr) {
	        new TaconiteJQueryParser().parse(data);
	    };
	    $.ajax(settings);
	};
	
	function TaconiteJQueryParser() { }
	
	TaconiteJQueryParser.prototype.parse = function(responseXml) {
	    var nodes = null;
	    if(responseXml != null) {
	        nodes = responseXml.documentElement.childNodes;
	    }
	    
	    if(nodes == null) {
	        nodes = new Array();
	    }
	    
	    for(var i = 0; i < nodes.length; i++) {
	        this.parseNode(nodes[i]);
	    }
	}
	
	TaconiteJQueryParser.prototype.parseNode = function(taconiteCommand) {
	    if(taconiteCommand.nodeType != 1) {
	        return;
	    }
	    
	    var xmlTagName = taconiteCommand.tagName.toLowerCase();
	    var selector = "";
	    if(taconiteCommand.getAttribute("contextNodeID") != null) {
	        selector = "#" + taconiteCommand.getAttribute("contextNodeID");
	    }
	    else if(taconiteCommand.getAttribute("contextNodeSelector") != null) {
	        selector = taconiteCommand.getAttribute("contextNodeSelector");
	    }
	    else {
	        selector = taconiteCommand.getAttribute("selector");
	    }
	    
	    var results = $(selector);
	
	    //remove attributes which are no longer needed
	    taconiteCommand.removeAttribute("contextNodeID");
	    taconiteCommand.removeAttribute("contextNodeSelector");
	    taconiteCommand.removeAttribute("matchMode");
	    taconiteCommand.removeAttribute("parseInBrowser");
	    taconiteCommand.removeAttribute("selector");
	    
	    switch (xmlTagName) {
	        case "taconite-append-as-children":
	            results.append(this.getContent(taconiteCommand));
	            break;
	        case "taconite-delete":
	            results.remove();
	            break;
	        case "taconite-append-as-first-child":
	            results.prepend(this.getContent(taconiteCommand));
	            break;                         
	        case "taconite-insert-after":
	            results.after(this.getContent(taconiteCommand));
	            break;
	        case "taconite-insert-before":
	            results.before(this.getContent(taconiteCommand));
	            break;                         
	        case "taconite-replace-children":
	            results.empty();
	            results.append(this.getContent(taconiteCommand));
	            break;
	        case "taconite-replace":
	            results.replaceWith(this.getContent(taconiteCommand));
	            break;                         
	        case "taconite-set-attributes":
	            this.handleAttributes(selector, taconiteCommand);
	            break;
	        case "taconite-redirect":
	            this.handleRedirect(taconiteCommand);
	            break;
	        case "taconite-execute-javascript":
	            eval(this.getContent(taconiteCommand));
	            break;
	    }
	
	}
	
	TaconiteJQueryParser.prototype.getContent = function(taconiteCommand) {
	    var content = "";
	    var child = null;
	    for(var p = 0; p < taconiteCommand.childNodes.length; p++) {
	        child = taconiteCommand.childNodes[p];
	        if(child.nodeType == 4) {
	            content = child.nodeValue;
	            break;
	        }
	    }
	    return content;
	}
	
	TaconiteJQueryParser.prototype.isTaconiteTag = function(node) {
	    return node.tagName.substring(0, 9) == "taconite-";
	}
	
	TaconiteJQueryParser.prototype.handleAttributes = function(selector, xmlNode) {
	    var attr = null;
	    var attrString = "";
	    var name = "";
	    var value = "";
	
	    for(var x = 0; x < xmlNode.attributes.length; x++) {
	        attr = xmlNode.attributes[x];
	        name = attr.name;
	        value = attr.value;
	
	        if(name == "style") {
	            $(selector).css(value);
	        }
	        else if(name == "value") {
	            $(selector).val(value);
	        }
	        else if(name == "class") {
	            $(selector).addClass(value);
	        }
	        else {
	            $(selector).attr(name, value);
	        }
	    }
	}
	
	TaconiteJQueryParser.prototype.handleRedirect = function(node) {
	    window.location.href = node.getAttribute("targetUrl");
	}
})(jQuery); // Call and execute the function immediately passing the jQuery object