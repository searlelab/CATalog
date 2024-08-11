filter_foreground <- function(foreground, proteins){
	df <- foreground%>%
		filter(Protein %in% proteins)
	df
}
