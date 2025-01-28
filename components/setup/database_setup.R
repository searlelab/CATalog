database_setup <- function(core_database, demographics, Database, ShoppingCart){
	 data <- reactive({
    		core_database
  	 })
  
  	observeEvent(data(),{
    		Database$background <- data()
    		Database$background_cache <- data()
    		Database$foreground <- generate_foreground(Database$background)
    		Database$foreground_cache <- Database$foreground
   	 	Database$demographics <- demographics
    		ShoppingCart$protein_data <- create_empty_dataframe(input_frame = Database$foreground, type = "protein")
    		ShoppingCart$go_data <- create_empty_dataframe(input_frame = NULL, type = "go")
		#print("set up database")
  	})
}
