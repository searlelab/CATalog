filter_button_logic <- function(input, Database, Search, PlotManager, demographics, output, session){
	observeEvent(input$filter_button,{
		req(input$main_display_rows_selected)
    		Database$background <- Database$background_cache
		previously_selected <- input$main_display_rows_selected
		if(Search$ongoing == TRUE){
			print("using the cached search results")
			Database$background <- filter_background_by_cache(Database$background, Search$cache)
		}

  		if(input$age_filter > 0 && input$age_filter <= 11){
      			Database$background <- filter_background_by_demographics(Database$background, demographics, demographic_field = "Age", value = input$age_filter)
		}
		if(input$bsc_filter > 0 && input$bsc_filter <= 8){
			print("filtering by BSC")
			print(paste("the value is: ", input$bsc_filter))
			Database$background <- filter_background_by_demographics(Database$background, demographics, demographic_field = "BSC", value = input$bsc_filter)
			print("applied bsc filter")
		}
		if(input$sex_filter != "Both"){
			print("filtering by sex")
			print(paste("the value is: ", input$sex_filter))
			Database$background <- filter_background_by_demographics(Database$background, demographics, demographic_field = "Sex", value = input$sex_filter)
			print("applied sex filter")
		}

      		Database$foreground <- generate_foreground(Database$background)
		if(input$biofluid_type != "All"){
      			Database$foreground <- filter_foreground_by_highest_biofluid(Database$foreground, biofluid = input$biofluid_type)
			print("applied the foreground filter")
		}
		
		Database$demographics <- update_demographics(Database$background, demographics)
    		
		PlotManager$boxplot <- boxplot_driver(data = Database$background,
						entry = Database$current_entry,
						flag = PlotManager$is_annotated)
		
		PlotManager$scatterplot <- scatterplot_driver(Database)

		if(input$swap_plot_type == "Boxplot"){
			PlotManager$current_plot <- PlotManager$boxplot
		}
		else if(input$swap_plot_type == "Scatterplot"){
			PlotManager$current_plot <- PlotManager$scatterplot
		}

		proxy <- DT::dataTableProxy("main_display") # Replace "main_display" with your actual DataTable ID
    		DT::selectRows(proxy, previously_selected)



  	})
}
