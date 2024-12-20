shopping_cart_row_click_handler <- function(input, trigger, ShoppingCart){
	observeEvent(input[[trigger]],{
			     ShoppingCart$current_protein_name <- map_protein_index_to_name(ShoppingCart$data, input$protein_cart_main_display_rows_selected)
			     #print(ShoppingCart$current_protein_name)
	})
}

