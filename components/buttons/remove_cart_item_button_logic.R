remove_cart_item_button_logic <- function(input, output, ShoppingCart) {
  observeEvent(input$remove_cart_item, {
    req(input$shopping_cart_display_rows_selected)
    
    # Remove the selected row from the table
    ShoppingCart$current_table <- remove_row_from_cart(ShoppingCart$current_table, input$shopping_cart_display_rows_selected)

    #fixing a potential issue here, the carts themselves need to be updated, not just the copy being currently displayed
    if(ShoppingCart$cart_type == "protein"){
	    ShoppingCart$protein_data <- ShoppingCart$current_table
    }
    else if(ShoppingCart$cart_type == "go"){
	    ShoppingCart$go_data <- ShoppingCart$current_table
    }
    
    # Trigger a redraw of the DataTable
    output$shopping_cart_display <- DT::renderDataTable({
      req(ShoppingCart$current_table)
      datatable(
        ShoppingCart$current_table,
        selection = "single",
        options = list(
          scrollX = TRUE,
          autoWidth = TRUE,
          pageLength = 10
        ),
        class = 'main_display nowrap'
      )
    })
    
    # Notify the user
    shinyalert::shinyalert("Removed selected row from cart", type = "success")
  })
}

