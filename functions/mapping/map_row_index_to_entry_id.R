map_row_index_to_entry_id <- function(data, index){
	r <- data[index,]
	entry <- r$Entry
	return(entry)
}
