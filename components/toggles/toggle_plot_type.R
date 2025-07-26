toggle_plot_type <- function(input, PlotManager){
	observeEvent(input$swap_plot_type,{
			     if(input$swap_plot_type == "Boxplot"){
				     PlotManager$current_plot <- PlotManager$boxplot
			     }
			     if(input$swap_plot_type == "Scatterplot"){
				     PlotManager$current_plot <- PlotManager$scatterplot
			     }

	})
}
