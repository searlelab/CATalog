render_plot_display <- function(output, input, PlotManager){
	output$plot_display <- renderPlot({
    		req(input$main_display_rows_selected)
    		PlotManager$current_plot
  })
}
  
