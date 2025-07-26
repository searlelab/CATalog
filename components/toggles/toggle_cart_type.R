toggle_cart_type <- function(input, trigger, session, ShoppingCart, output) {
  observeEvent(input[[trigger]], {
    #print(input$cart_type)
    
    # Update ShoppingCart$current_table based on the cart type
    ShoppingCart$current_frame <- cart_junction(ShoppingCart, cart_type = input$cart_type)
    
     #protein_cart_main_display_backend(output, ShoppingCart)
  })
}
