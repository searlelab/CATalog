add_element_button_logic <- function(input, ShoppingCart, output, Database, go_data){
	observeEvent(input$add_protein_button, {
    		if(!is.null(input$checked_rows)) {
      			selected_proteins <- input$checked_rows
      			selected_rows <- get_selected_rows(selected_proteins, Database$foreground)

      			# Add the selected proteins to the shopping cart
      			ShoppingCart$protein_data <- rbind(ShoppingCart$protein_data, selected_rows)
      			shinyalert(paste("Added selected proteins to cart")) 
    		} else {
      			shinyalert("No proteins selected")
    		}
  	})
	observeEvent(input$add_go_data_button, {
    		if(!is.null(input$main_display_rows_selected)) {
                Database$current_entry <- map_row_index_to_entry_id(Database$foreground, index = input$main_display_rows_selected)
      		Database$current_name <- map_row_index_to_protein_name(Database$foreground, index = input$main_display_rows_selected)
      		Database$go_list <- go_processor(entry = Database$current_entry, go_data)

      		go_frame <- combine_go_dataframes(Database)

      		# Add the new GO data to ShoppingCart$go_data
      		ShoppingCart$go_data <- rbind(ShoppingCart$go_data, go_frame)
            	shinyalert(paste("Added GO data from: ", Database$current_entry))

        
    		} else {
      			shinyalert("No rows selected")
    		}
  	})
}



