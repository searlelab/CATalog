cart_junction <- function(ShoppingCart, cart_type){
	if(cart_type == "proteins"){
		current_table <- ShoppingCart$data
		return(current_table)
	}
	else if(cart_type == "go data"){
		current_table <- ShoppingCart$go_data
		return(current_table)
	}
}
