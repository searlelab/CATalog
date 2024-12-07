shopping_cart_row_select_logic <- function(input, trigger, table_reactive){
	observeEvent(input[[trigger]],{
			     table_reactive$current_peptide_name <- map_peptide_index_to_name(table_reactive$data, input$peptide_cart_display_rows_selected)
	})
}

