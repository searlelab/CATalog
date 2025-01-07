combine_go_dataframes <- function(Database){
	go_data <- Database$go_list
	#print(length(go_data))
	go_data <- inject_go_types(go_data)
	#print("injected go type metadata")
	go_frame <- bind_rows(go_data, .id = "source")	#print(nrow(go_frame))
	go_frame$Entry <- Database$current_entry
	go_frame$Protein <- Database$current_name
	go_frame$Gene <- Database$current_gene
	#print(head(go_frame))
	return(go_frame)
}
