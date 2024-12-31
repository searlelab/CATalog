add_go_info_to_shopping_cart_handler <- function(input, trigger, Database, ShoppingCart, go_data){
	observeEvent(input[[trigger]],{
		if(!is.null(input$main_display_rows_selected)){
			print(paste("foreground data has: ", nrow(Database$foreground), "rows"))
			print("working on adding GO data to cart")
			#a series of horribly redundant steps that need to be solved through S4 classes in the future
			Database$current_entry <- map_index_to_entry(Database$foreground, index = input$main_display_rows_selected)
			Database$current_name <- map_index_to_name(Database$foreground, index = input$main_display_rows_selected)
			Database$go_list <- go_processor(entry = Database$current_entry, go_data)
			print(paste("GO data has :", length(Database$go_list), "parts"))
			go_frame <- combine_go_dataframes(Database)
			ShoppingCart$go_data <- add_multiple_rows_to_cart(ShoppingCart$go_data, go_frame)
			shinyalert(print(paste("Exported GO data from: ", Database$current_entry)))
		}
		else{
			shinyalert(print(paste("Nothing to export")))
		    }
	})
}
