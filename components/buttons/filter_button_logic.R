filter_button_logic <- function(input, Database, Search, PlotManager, demographics, output, session){
	observeEvent(input$filter_button,{
		req(input$main_display_rows_selected)
    		Database$background <- Database$background_cache
    		if(Search$ongoing == FALSE){ #default conditions
      			Database$background <- apply_demographic_filter(Database$background, demographics, target = "Age", value = input$age_filter, max_value = 11)
			Database$background <- apply_demographic_filter(Database$background, demographics, target = "BSC", value = input$bsc_filter, max_value = 8)
      			Database$foreground <- generate_foreground(Database$background)
      			Database$foreground <- filter_foreground_by_highest_biofluid(Database$foreground, biofluid = input$biofluid_type)
			Database$demographics <- update_demographics(Database$background, demographics)
    		}
    		else if(Search$ongoing == TRUE){ #caches so the table isn't reset upon searching the GO database
      			Database$background <- filter_background_by_cache(Database$background, Search$cache)
      			Database$background <- apply_demographic_filter(Database$background, demographics, target = "Age", value = input$age_filter, max_value = 11)
			Database$background <- apply_demographic_filter(Database$background, demographics, target = "BSC", value = input$bsc_filter, max_value = 8)
      			Database$foreground <- generate_foreground(Database$background)
      			Database$foreground <- filter_foreground_by_highest_biofluid(Database$foreground, biofluid = input$biofluid_type)
			Database$demographics <- update_demographics(Database$background, demographics)
    		}
		print("applied filters")
					
		PlotManager$boxplot <- boxplot_driver(data = Database$background,
						entry = Database$current_entry,
						flag = PlotManager$is_annotated)
		print("set boxplot")
		PlotManager$scatterplot <- scatterplot_driver(Database)

		print("set plots")

		if(input$swap_plot_type == "Boxplot"){
			PlotManager$current_plot <- PlotManager$boxplot
		}
		else if(input$swap_plot_type == "Scatterplot"){
			PlotManager$current_plot <- PlotManager$scatterplot
		}



  	})
}
