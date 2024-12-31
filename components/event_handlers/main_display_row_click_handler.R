main_display_row_click_handler <- function(input, trigger, Database, Plot, Global, go_data){
	observeEvent(input[[trigger]],{
			     #print("clicked on row")
			     Database$current_entry <- map_index_to_entry(Database$foreground, index = input$main_display_rows_selected)
			     Database$current_name <- map_index_to_name(Database$foreground, index = input$main_display_rows_selected)
			     Database$go_list <- go_processor(entry = Database$current_entry, go_data)
			     #print(paste("generated go list with: ", length(Database$go_list), "parts")) 
			     Database$go_table <- set_ontology(go_list = Database$go_list, field = input$go_data_type)
			     Plot$boxplot <- boxplot_driver(data = Database$background, entry = Database$current_entry, flag = Plot$is_annotated)
			     #print("updated boxplot")
			     Plot$scatterplot <- scatterplot_driver(Database, Global)
			     #print("updated scatterplot")
			     Plot$current_plot <- plot_junction(Plot, plot_type = input$plot_type)
	})
}
