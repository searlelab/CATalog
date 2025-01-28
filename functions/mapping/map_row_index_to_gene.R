map_row_index_to_gene <- function(data, index){
	r <- data[index,]
	name <- r$Gene
	return(name)
}


