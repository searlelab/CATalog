filter_foreground <- function(data, deltas, field){
	if(field == "urine"){
		res <- deltas%>%
			filter(FlagUrine == 0)
	}
	if(field == "serum"){
		res <- deltas%>%
			filter(FlagSerum == 0)
	}
	if(field == "plasma"){
		res <- deltas%>%
			filter(FlagPlasma == 0)
	}
	entries <- res$Entry
	output <- data%>%
		filter(Entry %in% entries)

}
