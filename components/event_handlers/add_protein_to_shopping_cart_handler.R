add_protein_to_shopping_cart_handler <- function(input, button_id, ShoppingCart, protein_table){
	observeEvent(input[[button_id]],{
			     if(!is.null(input$checked_rows)){
				     selected_proteins <- input$checked_rows
				     selected_rows <- get_selected_rows(selected_proteins, protein_table)
				     ShoppingCart$data <- add_multiple_rows_to_cart(ShoppingCart$data, selected_rows)
				     shinyalert(print(paste("Added selected proteins to cart")))
				     #updating the shopping cart display
				     if(input$cart_type == "proteins"){
					     ShoppingCart$current_table <- ShoppingCart$data
				     }
			     }
			     else{
				     shinyalert(print(paste("No proteins selected")))
			     }
	})
}
