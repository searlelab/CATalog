search_go_data_background <- function(data, background, index, word){
	df <- data[grepl(word, data[,index], ignore.case = TRUE),]
	entries <- df$Column2
	res <- background%>%
		filter(Entry.Name %in% entries)
	res
}

