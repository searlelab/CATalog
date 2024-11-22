row_click_handler <- function(input, trigger, Database, Global, Plot, go_data){
	observeEvent(input[[trigger]],{
			     Database$current_entry <- map_entry_to_index(Database$foreground, index = input$display_rows_selected)
			     Global$all_ontologies <- go_processor(entry = Database$current_entry, go_data)
			     Database$ontology <- set_ontology(go_list = Global$all_ontologies, field = input$go_item)
			     Plot$boxplot <- boxplot_driver(data = Database$background, entry = Database$current_entry, flag = Plot$is_annotated)
	})
}
