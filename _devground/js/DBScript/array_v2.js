Array.prototype.contains = function(v){
	var i=0;
	while(i < this.length){
		if(this[i] == v)
			return true;
		i++;
	}
	return false;
}

Array.prototype.swap = function(idx1, idx2){
	if(this[idx1] && this[idx2]){
		var tmp=this[idx1];
		this[idx1] = this[idx2]
		this[idx2] = tmp;
	}
	return this;
}

