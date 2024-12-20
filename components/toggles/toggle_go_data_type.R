toggle_go_data_type <- function(input, trigger, Database){
	observeEvent(input[[trigger]],{
			     Database$go_table <- set_ontology(go_list = Database$go_list, field = input$go_data_type)
	})
}

