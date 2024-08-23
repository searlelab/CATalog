fetch_go_info <- function(go_list, field){
	print(field)
	if(field == "biological process"){ #default
		output <- go_list[[1]]
	}
	if(field == "cellular compartment"){
		output <- go_list[[2]]
	}
	if(field == "molecular function"){
		output <- go_list[[3]]
	}
	output
}


