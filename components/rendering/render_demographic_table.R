render_demographic_table <- function(output, Database){
	output$demo <- renderTable({
    		Database$demographics
  	})
}
