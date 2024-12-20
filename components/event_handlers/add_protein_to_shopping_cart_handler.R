add_protein_to_shopping_cart_handler <- function(input, button_id, shopping_cart, protein_table){
	observeEvent(input[[button_id]],{
			     #print("the selected rows are: ")
			     #print(input$checked_rows)
			     if(!is.null(input$checked_rows)){
				     #print("rows are selected")
				     selected_proteins <- input$checked_rows
				     selected_rows <- get_selected_rows(selected_proteins, protein_table)
				     shopping_cart$data <- add_multiple_rows_to_cart(shopping_cart$data, selected_rows)
				     shinyalert(print(paste("Added selected proteins to cart")))
			     }
			     else{
				     shinyalert(print(paste("No proteins selected")))
			     }
	})
}
