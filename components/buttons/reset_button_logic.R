reset_button_logic <- function(input, session, trigger, Database, Search, Global, demographics, Plot){
	observeEvent(input[[trigger]],{
			      Database$background <- Database$background_cache
    			      Database$foreground <- Database$foreground_cache
			      Global$demographics <- demographics
    			      updateTextInput(session,"go_search_query", value="")
			      updateTextInput(session, "protein_search_query", value = "")
    			      updateNumericInput(session, "age_filter", value = 11)
   			      updateNumericInput(session, "bsc_filter", value = 8)
    			      Search$is_ongoing <- FALSE
			      Plot$boxplot <- boxplot_driver(data = Database$background,
						entry = Database$current_entry,
						flag = Plot$is_annotated)
			      Plot$scatterplot <- scatterplot_driver(Database, Global)

			      if(input$plot_type == "boxplot"){
					Plot$current_plot <- Plot$boxplot
			      }
			      else if(input$plot_type == "scatterplot"){
					Plot$current_plot <- Plot$scatterplot
			      }



	})
}
