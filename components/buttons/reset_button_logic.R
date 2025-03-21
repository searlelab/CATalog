reset_button_logic <- function(input, session, Database, Search, demographics, PlotManager){
	observeEvent(input$reset_button,{
			      Database$background <- Database$background_cache
    			      Database$foreground <- Database$foreground_cache
			      Database$demographics <- demographics
    			      updateTextInput(session,"go_search_query", value="")
			      updateTextInput(session, "protein_search_query", value = "")
			      updateNumericInput(session, "delta_threshold", value = 1)
    			      updateNumericInput(session, "age_filter", value = 11)
   			      updateNumericInput(session, "bsc_filter", value = 8)
			      updateRadioButtons(session, "sex_filter", selected = "Both")
    			      Search$ongoing <- FALSE
			      req(input$main_display_rows_selected)
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



	})
}
