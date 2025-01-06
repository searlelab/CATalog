add_protein_to_shopping_cart_handler <- function(input, button_id, ShoppingCart, protein_table, output){
  observeEvent(input[[button_id]], {
    if(!is.null(input$checked_rows)) {
      selected_proteins <- input$checked_rows
      selected_rows <- get_selected_rows(selected_proteins, protein_table)

      # Add the selected proteins to the shopping cart
      ShoppingCart$data <- add_multiple_rows_to_cart(ShoppingCart$data, selected_rows)
      shinyalert(paste("Added selected proteins to cart"))

      # Update the current table if the cart type is "proteins"
      if(input$cart_type == "proteins") {
        ShoppingCart$current_frame <- ShoppingCart$data
      }      
    } else {
      shinyalert("No proteins selected")
    }
  })
}
