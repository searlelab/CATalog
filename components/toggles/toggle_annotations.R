toggle_annotations <- function(input, PlotManager, Database){
	observeEvent(input$show_annotations,{
    		PlotManager$is_annotated <- input$show_annotations
		if(!is.null(Database) && 
		   !is.null(Database$current_entry)&&
		   !is.null(Database$background)){
			PlotManager$boxplot <- boxplot_driver(Database$background, 
					       entry = Database$current_entry,
					       flag = PlotManager$is_annotated)
			if(input$swap_plot_type == "Boxplot"){
				PlotManager$current_plot <- PlotManager$boxplot
			}
		}
  	})
}
  
