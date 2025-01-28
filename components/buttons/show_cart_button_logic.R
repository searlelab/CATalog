show_cart_button_logic <- function(input, ShoppingCart, show_cart_trigger) {
  observeEvent(input$show_protein_cart, {
    ShoppingCart$current_table <- ShoppingCart$protein_data
    show_cart_trigger(show_cart_trigger() + 1)
  })
  observeEvent(input$show_go_cart, {
    ShoppingCart$current_table <- ShoppingCart$go_data
    show_cart_trigger(show_cart_trigger() + 1)
  })
}

