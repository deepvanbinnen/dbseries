if(!String.trim){
	// this trim was suggested by Tobias Hinnerup
	String.prototype.trim = function() {
	  return(this.replace(/^\s+/,'').replace(/\s+$/,''));
	}
}