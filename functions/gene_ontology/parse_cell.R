parse_cell <- function(entry, go_category, go_data){
	#due to difficulties when trying to use variable names as exact column names, column indicies are used to refer to columns
	#2- biological process
	#3- cellular ocmpartment
	#4- molecular function
	r <- go_data%>%
		filter(Entry == entry)
	if(nrow(r) == 0){
		r <- spoof_dataframe(entry)
		info <- r[,go_category] 
		semi_parsed <- unlist(strsplit(info, split = ';'))
		df <- data.frame(semi_parsed)%>% 
			tidyr::separate(semi_parsed, into = c("Description", "GO_ID"), sep = "\\[|\\]", extra = "drop", fill = "right")

		
	}	
	else{
		info <- r[,go_category] 
		semi_parsed <- unlist(strsplit(info, split = ';'))
		df <- data.frame(semi_parsed)%>% 
			tidyr::separate(semi_parsed, into = c("Description", "GO_ID"), sep = "\\[|\\]", extra = "drop", fill = "right")
	}
	df
}

