filter_handler <- function(input, trigger, Database, Search, Global, Plot, demographics){
	observeEvent(input[[trigger]],{
    		Database$background <- Database$background_cache
    		if(Search$is_ongoing == FALSE){
      			Database$background <- apply_demographic_filter(Database$background, demographics, target = "Age", value = input$age_filter, max_value = 11)
			Database$background <- apply_demographic_filter(Database$background, demographics, target = "BSC", value = input$bsc_filter, max_value = 8)
      			Database$foreground <- generate_foreground(Database$background)
      			Database$foreground <- filter_foreground(Database$foreground, target = input$sample_type)
			Global$demographics <- update_demographics(Database$background, demographics)
    		}
    		else if(Search$is_ongoing == TRUE){
      			Database$background <- filter_background_by_cache(Database$background, Search$cache)
      			Database$background <- apply_demographic_filter(Database$background, demographics, target = "Age", value = input$age_filter, max_value = 11)
			Database$background <- apply_demographic_filter(Database$background, demographics, target = "BSC", value = input$bsc_filter, max_value = 8)
      			Database$foreground <- generate_foreground(Database$background)
      			Database$foreground <- filter_foreground(Database$foreground, target = input$sample_type)
			Global$demographics <- update_demographics(Database$background, demographics)
    		}
		#logic to remake the plot using the new filtered background
		if(!is.null(input$display_rows_selected)){
			   Plot$boxplot <- boxplot_driver(data = Database$background,
							  entry = Database$current_entry,
							  flag = Plot$is_annotated)
			  }

  	})
}
