toggle_cart_type <- function(input, trigger, ShoppingCart){
	observeEvent(input[[trigger]],{
			     ShoppingCart$current_table <- cart_junction(ShoppingCart,
									 cart_type = input$cart_type)
	})
}
