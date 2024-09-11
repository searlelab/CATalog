search_go_data_background <- function(data, background, index, word){
	#pattern <- create_pattern(word)
	#df <- data%>%
		#filter(str_detect(data[,index], pattern))
	df <- data[grepl(word, data[,index], ignore.case = TRUE),]
	entries <- df$Column2
	res <- background%>%
		filter(Entry.Name %in% entries)
	res
}

