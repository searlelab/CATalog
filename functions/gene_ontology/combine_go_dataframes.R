combine_go_dataframes <- function(Database){
	go_data <- Database$go_list
	#print(length(go_data))
	go_data <- inject_go_types(go_data)
	go_frame <- rbind(go_data[[1]], go_data[[2]], go_data[[3]])
	#print(nrow(go_frame))
	go_frame$Entry <- Database$current_entry
	go_frame$Protein <- Database$current_name
	print(head(go_frame))
	return(go_frame)
}
