remove_protein_from_cart <- function(input, button_id, table_reactive){
	observeEvent(input[[button_id]],{
			     req(input$peptide_cart_display_rows_selected)
			     table_reactive$data <- remove_row_from_cart(table_reactive$data, input$peptide_cart_display_rows_selected)
			     shinyalert(print(paste("Removed: ", table_reactive$current_peptide_name, " from cart")))
	})
}
