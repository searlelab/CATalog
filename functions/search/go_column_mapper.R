go_column_mapper <- function(field){
	index <- 5
	if(field == "biological process"){
		index = 2
	}
	if(field == "cellular compartment"){
		index = 3
	}
	if(field == "molecular function"){
		index = 4
	}
	index
}

