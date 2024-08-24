cell_parser_wrapper <- function(id, data){
	bio_process <- parse_cell(id, 5, data)
	cell_comp <- parse_cell(id, 6, data)
	mol_func <- parse_cell(id, 7, data)
	go_list <- list(bio_process, cell_comp, mol_func)
	go_list
}

