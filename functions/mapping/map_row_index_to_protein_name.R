map_row_index_to_protein_name <- function(data, index){
	r <- data[index,]
	name <- r$Protein
	return(name)
}


