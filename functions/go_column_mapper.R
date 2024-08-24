go_column_mapper <- function(field){
	index <- 5
	if(field == "biological process"){
		index = 5
	}
	if(field == "cellular compartment"){
		index = 6
	}
	if(field == "molecular function"){
		index = 7
	}
	index
}

