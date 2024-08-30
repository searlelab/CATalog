filter_foreground <- function(deltas, foreground, target){
	#searching for rows that contain the target word
	df <- deltas[grepl(target, deltas[,8], ignore.case = TRUE),]
	entries <- df$Entry #getting the entries
	output <- foreground%>%
		filter(Entry %in% entries)
	output
}
