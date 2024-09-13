parse_cell <- function(protein, index, data){
	r <- data%>%
	filter(Column2 == protein)
	info <- r[,index] 
	semi_parsed <- unlist(strsplit(info, split = ';'))
	df <- data.frame(semi_parsed)%>% 
		tidyr::separate(semi_parsed, into = c("Description", "GO_ID"), sep = "\\[|\\]", extra = "drop", fill = "right")
	df
}

