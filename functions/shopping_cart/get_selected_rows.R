get_selected_rows <- function(selected_proteins, foreground){
	df <- foreground%>%
		filter(Entry %in% selected_proteins)
	df
}
