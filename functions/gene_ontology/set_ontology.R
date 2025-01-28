set_ontology <- function(go_list, field){
	if(field == "Biological Process"){ #default
		output <- go_list[[1]]
	}
	if(field == "Cellular Compartment"){
		output <- go_list[[2]]
	}
	if(field == "Molecular Function"){
		output <- go_list[[3]]
	}
	output
}


