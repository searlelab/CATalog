search_for_go_keyword <- function(go_data, foreground, keyword){
	df_bio_process <- go_data[grepl(keyword, go_data[,1], ignore.case = TRUE),]
	df_cell_compartment <- go_data[grepl(keyword, go_data[,2],ignore.case = TRUE),]
	df_mol_function <- go_data[grepl(keyword, go_data[,3],ignore.case = TRUE),]
	entries <- c(df_bio_process$Entry, df_cell_compartment$Entry, df_mol_function$Entry)
	search_results <- foreground%>%
		filter(Entry %in% entries)
	search_results
}

