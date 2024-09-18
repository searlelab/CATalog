update_background <- function(foreground, background){
	entries <- foreground$Entry
	res <- background%>%
		filter(Entry.Name %in% entries)
	res
}
