filter_by_highest_biofluid <- function(data, deltas, field){
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
	print(length(entries))
	print(head(data))
	output <- data%>%
		filter(Entry %in% entries)
	output

}
