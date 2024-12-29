main_display_row_click_handler <- function(input, trigger, Database, Plot, Global, go_data){
	observeEvent(input[[trigger]],{
			     #print("clicked on row")
			     Database$current_entry <- map_entry_to_index(Database$foreground, index = input$main_display_rows_selected)
			     Database$go_list <- go_processor(entry = Database$current_entry, go_data)
			     Database$go_table <- set_ontology(go_list = Database$go_list, field = input$go_data_type)
			     Plot$boxplot <- boxplot_driver(data = Database$background, entry = Database$current_entry, flag = Plot$is_annotated)
			     #print("updated boxplot")
			     Plot$scatterplot <- scatterplot_driver(Database, Global)
			     #print("updated scatterplot")
			     Plot$current_plot <- plot_junction(Plot, plot_type = input$plot_type)
	})
}
