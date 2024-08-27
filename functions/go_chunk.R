go_chunk <- function(data, row_id, go_data){
	protein <- go_protein_mapper(data, row_id)
	go_list <- cell_parser_wrapper(protein, go_data)
	go_list
}

