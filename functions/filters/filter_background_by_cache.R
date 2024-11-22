filter_background_by_cache <- function(background, cache){
	entries <- cache$Entry
	background <- background%>%
		filter(Entry %in% entries)
	background
}
