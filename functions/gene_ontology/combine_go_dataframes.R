combine_go_dataframes <- function(Database){
	go_data <- Database$go_list
	go_data <- inject_go_types(go_data)
	go_frame <- bind_rows(go_data, .id = "source")	
	go_frame$Entry <- Database$current_entry
	go_frame$Protein <- Database$current_name
	go_frame$Gene <- Database$current_gene
	return(go_frame)
}
