find_protein_status <- function(background, option){
	if(option == "unreviewed"){
		df <- background%>%
			filter(Reviewed == option)
	}
	else if(option == "reviewed"){
		df <- background%>%
			filter(Reviewed == option)
	}
	else{
		df <- background
	}
	proteins <- df$Protein.names
	proteins
}


