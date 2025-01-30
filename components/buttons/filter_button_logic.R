filter_button_logic <- function(input, Database, Search, PlotManager, demographics, output, session){
	observeEvent(input$filter_button,{
		if(is.null(input$main_display_rows_selected)){
			shinyalert(print("Please select a protein"))
		}
		req(input$main_display_rows_selected)
    		Database$background <- Database$background_cache
		previously_selected <- input$main_display_rows_selected
		if(Search$ongoing == TRUE){
			Database$background <- filter_background_by_cache(Database$background, Search$cache)
		}

  		if(input$age_filter > 0 && input$age_filter < 11){
      			Database$background <- filter_background_by_demographics(Database$background, demographics, demographic_field = "Age", value = input$age_filter)
		}
		if(input$bsc_filter > 0 && input$bsc_filter < 8){
			Database$background <- filter_background_by_demographics(Database$background, demographics, demographic_field = "BSC", value = input$bsc_filter)
		}
		if(input$sex_filter != "Both"){
			Database$background <- filter_background_by_demographics(Database$background, demographics, demographic_field = "Sex", value = input$sex_filter)
		}

      		Database$foreground <- generate_foreground(Database$background)
		if(input$biofluid_type != "All" && input$delta_threshold > 0){
      			Database$foreground <- filter_foreground_by_highest_biofluid(Database$foreground, biofluid = input$biofluid_type, delta_threshold = input$delta_threshold)
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

		proxy <- DT::dataTableProxy("main_display") 
		DT::selectRows(proxy, previously_selected)



  	})
}
