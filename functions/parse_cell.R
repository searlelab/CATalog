parse_cell <- function(protein, index, data){
	r <- data%>%
		filter(Column2 == protein)
	if(nrow(r) == 0){
		df <- NULL
		print("no GO terms found")
	}
	else{
		info <- r[,index] 
		semi_parsed <- unlist(strsplit(info, split = ';'))
		df <- data.frame(semi_parsed)%>% 
			tidyr::separate(semi_parsed, into = c("Description", "GO_ID"), sep = "\\[|\\]", extra = "drop", fill = "right")
	}
	df
}

