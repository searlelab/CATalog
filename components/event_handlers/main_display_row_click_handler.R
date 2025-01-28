main_display_row_click_handler <- function(input, Database, PlotManager, go_data){
	observeEvent(input$main_display_rows_selected,{
			     print("running row selection logic")
			     Database$current_entry <- map_row_index_to_entry_id(Database$foreground, index = input$main_display_rows_selected)
			     Database$current_name <- map_row_index_to_protein_name(Database$foreground, index = input$main_display_rows_selected)
			     Database$current_gene <- map_row_index_to_gene(Database$foreground, index = input$main_display_rows_selected)
			     print("mappings complete")
			     Database$go_list <- go_processor(entry = Database$current_entry, go_data)
			     print("go data processed")
			     Database$go_table <- set_ontology(go_list = Database$go_list, field = input$swap_go_data_type)
			     PlotManager$boxplot <- boxplot_driver(data = Database$background, entry = Database$current_entry, flag = PlotManager$is_annotated)
			     PlotManager$scatterplot <- scatterplot_driver(Database)
			     #PlotManager$current_plot <- plot_junction(PlotManager, plot_type = input$swap_plot_type)
			     if(input$swap_plot_type == "Boxplot"){
				     PlotManager$current_plot <- PlotManager$boxplot
			     }
			     if(input$swap_plot_type == "Scatterplot"){
				     PlotManager$current_plot <- PlotManager$scatterplot
			     }
	})
}
