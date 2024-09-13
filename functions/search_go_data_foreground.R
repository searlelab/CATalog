search_go_data_foreground <- function(data, foreground, index, word){
	df <- data[grepl(word, data[,index], ignore.case = TRUE),]
	entries <- df$Column2
	res <- foreground%>%
		filter(Entry %in% entries)
	res
}

