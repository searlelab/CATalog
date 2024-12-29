toggle_plot_type <- function(input, trigger, Plot){
	observeEvent(input[[trigger]],{
			     Plot$current_plot <- plot_junction(Plot, plot_type = input$plot_type)
	})
}
