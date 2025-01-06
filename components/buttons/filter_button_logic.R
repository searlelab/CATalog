filter_button_logic <- function(input, trigger, Database, Search, Global, Plot, demographics, output, session){
	observeEvent(input[[trigger]],{
    		Database$background <- Database$background_cache
		#print(paste("primary search status: ", Database$primary_search_is_ongoing))
		#print(paste("GO search status: ", Search$is_ongoing))
		#print(paste("Primary search query: ", Database$primary_search_cache))
    		if(Search$is_ongoing == FALSE && Database$primary_search_is_ongoing == FALSE){ #default conditions
			print("case 1 triggered")
      			Database$background <- apply_demographic_filter(Database$background, demographics, target = "Age", value = input$age_filter, max_value = 11)
			Database$background <- apply_demographic_filter(Database$background, demographics, target = "BSC", value = input$bsc_filter, max_value = 8)
      			Database$foreground <- generate_foreground(Database$background)
      			Database$foreground <- filter_foreground(Database$foreground, target = input$sample_type)
			Global$demographics <- update_demographics(Database$background, demographics)
    		}
    		else if(Search$is_ongoing == TRUE){ #caches so the table isn't reset upon searching the GO database
			print("case 2 triggered")
      			Database$background <- filter_background_by_cache(Database$background, Search$cache)
      			Database$background <- apply_demographic_filter(Database$background, demographics, target = "Age", value = input$age_filter, max_value = 11)
			Database$background <- apply_demographic_filter(Database$background, demographics, target = "BSC", value = input$bsc_filter, max_value = 8)
      			Database$foreground <- generate_foreground(Database$background)
      			Database$foreground <- filter_foreground(Database$foreground, target = input$sample_type)
			Global$demographics <- update_demographics(Database$background, demographics)
    		}
		if(!is.null(input$main_display_rows_selected)){
			Plot$boxplot <- boxplot_driver(data = Database$background,
						entry = Database$current_entry,
						flag = Plot$is_annotated)
		}

  	})
}
