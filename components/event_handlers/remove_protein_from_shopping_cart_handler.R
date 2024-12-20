remove_protein_from_shopping_cart_handler <- function(input, trigger, ShoppingCart){
	observeEvent(input[[trigger]],{
			     req(input$protein_cart_main_display_rows_selected)
			     ShoppingCart$data <- remove_row_from_cart(ShoppingCart$data, input$protein_cart_main_display_rows_selected)
			     shinyalert(print(paste("Removed: ", ShoppingCart$current_protein_name, " from cart")))
	})
}
