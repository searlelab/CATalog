remove_protein_from_shopping_cart_handler <- function(input, trigger, ShoppingCart){
	observeEvent(input[[trigger]],{
			     req(input$protein_cart_main_display_rows_selected)
			     ShoppingCart$current_frame <- remove_row_from_cart(ShoppingCart$current_frame, input$protein_cart_main_display_rows_selected)
			     shinyalert(print(paste("Removed selected row from cart")))
	})
}
