reset_button_logic <- function(input, session, Database, Search, demographics, PlotManager){
	observeEvent(input$reset_button,{
			      Database$background <- Database$background_cache
    			      Database$foreground <- Database$foreground_cache
			      Database$demographics <- demographics
    			      updateTextInput(session,"go_search_query", value="")
			      updateTextInput(session, "protein_search_query", value = "")
    			      updateNumericInput(session, "age_filter", value = 11)
   			      updateNumericInput(session, "bsc_filter", value = 8)
    			      Search$is_ongoing <- FALSE
			      PlotManager$boxplot <- boxplot_driver(data = Database$background,
						entry = Database$current_entry,
						flag = PlotManager$is_annotated)
			      PlotManager$scatterplot <- scatterplot_driver(Database)

			      if(input$switch_plot_type == "Boxplot"){
					PlotManager$current_plot <- PlotManager$boxplot
			      }
			      else if(input$switch_plot_type == "Scatterplot"){
					PlotManager$current_plot <- PlotManager$scatterplot
			      }



	})
}
