toggle_go_data_type <- function(input, Database){
	observeEvent(input$swap_go_data_type,{
			     if(input$swap_go_data_type == "Biological Process"){
				     Database$go_table <- Database$go_list[[1]]
			     }
			     if(input$swap_go_data_type == "Cellular Compartment"){
				     Database$go_table <- Database$go_list[[2]]
			     }
			     if(input$swap_go_data_type == "Molecular Function"){
				     Database$go_table <- Database$go_list[[3]]
			     }
			     
	})
}

