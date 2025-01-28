go_processor <- function(entry, go_data){
	bio_process <- parse_cell(entry, 2, go_data)
	cell_comp <- parse_cell(entry, 3, go_data)
	mol_func <- parse_cell(entry, 4, go_data)
	go_list <- list(bio_process, cell_comp, mol_func)
	return(go_list)
}

