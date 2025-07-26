render_go_table <- function(input, output, Database){
	output$go_display <- DT::renderDataTable({
    		req(input$main_display_rows_selected)
    		Database$go_table
  })
}
  

