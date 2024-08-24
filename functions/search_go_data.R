search_go_data <- function(data, foreground, index, word){
	pattern <- create_pattern(word)
	df <- data%>%
		filter(str_detect(data[,index], pattern))
	entries <- df$Column2
	res <- foreground%>%
		filter(Entry %in% entries)
	res
}

