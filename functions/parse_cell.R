parse_cell <- function(id, index, data){
	r <- data[id,] #extracting row based on user selection
	info <- r[,index] #selecting out desired information
	semi_parsed <- unlist(strsplit(info, split = ';')) #preprocessing the informaiton
	df <- data.frame(semi_parsed)%>% #formatting
		tidyr::separate(semi_parsed, into = c("Description", "GO_ID"), sep = "\\[|\\]", extra = "drop", fill = "right")
	df
}

