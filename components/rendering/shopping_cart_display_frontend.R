shopping_cart_display_frontend <- function(output, show_cart_trigger, ShoppingCart) {
	observeEvent(show_cart_trigger(), { # Trigger on changes to show_cart_trigger
	  	if(show_cart_trigger() > 0){

    		# Call backend to populate the cart display
    		shopping_cart_display_backend(output, ShoppingCart)
    
    		# Display the modal dialog
    		showModal(modalDialog(
      			title = "Shopping Cart",
      			tags$div(
        		DTOutput("shopping_cart_display"),
        		style = "overflow-x: auto; width: 100%;"
      			),
      
      		actionButton("remove_cart_item", "Delete Selected Row"),
      		easyClose = TRUE,
      		footer = modalButton("Close"),
      		style = "width: 90%; max-width: 2000px;"
    		))
	}
      })
}


