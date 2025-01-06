add_go_info_to_shopping_cart_handler <- function(input, trigger, Database, ShoppingCart, go_data, output){
  observeEvent(input[[trigger]], {
    if(!is.null(input$main_display_rows_selected)) {
      # Processing the selected rows and adding GO data
      Database$current_entry <- map_index_to_entry(Database$foreground, index = input$main_display_rows_selected)
      Database$current_name <- map_index_to_name(Database$foreground, index = input$main_display_rows_selected)
      Database$go_list <- go_processor(entry = Database$current_entry, go_data)

      go_frame <- combine_go_dataframes(Database)

      # Add the new GO data to ShoppingCart$go_data
      ShoppingCart$go_data <- add_multiple_rows_to_cart(ShoppingCart$go_data, go_frame)
      print(paste("size of GO cart: ", nrow(ShoppingCart$go_data)))
      shinyalert(paste("Exported GO data from: ", Database$current_entry))

      # Update current_frame to reflect the "go data" if needed
      if(input$cart_type == "go data") {
        ShoppingCart$current_frame <- ShoppingCart$go_data #set the GO data as the current display
      	print("re-rendering the GO frame")
      }

      
    } else {
      shinyalert("Nothing to export")
    }
  })
}

