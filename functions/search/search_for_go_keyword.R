search_for_go_keyword <- function(go_data, foreground, go_field, keyword){
	df <- go_data[grepl(keyword, go_data[,go_field], ignore.case = TRUE),]
	entries <- df$Entry
	search_results <- foreground%>%
		filter(Entry %in% entries)
	search_results
}

