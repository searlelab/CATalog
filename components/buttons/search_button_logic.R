search_button_logic <- function(input, session, trigger, Database, Search){
	observeEvent(input[[trigger]],{
			     if(input$go_search_query != ""){
			     	updateTextInput(session,"protein_search_query", value="")
			     	Database$foreground <- Database$foreground_cache
			     	search_results <- search_for_go_keyword(go_data, Database$foreground, keyword = input$go_search_query)
			     	Database$foreground <- search_results
			     	Search$cache <- search_results
			     	Search$is_ongoing <- TRUE
			     }
			     if(input$protein_search_query != ""){
			     	updateTextInput(session,"go_search_query", value="")
			     	Database$foreground <- Database$foreground_cache
				search_results <- search_for_protein(Database$foreground, field = input$search_field, keyword = input$protein_search_query)
				Database$foreground <- search_results
				Search$cache <- search_results
				Search$is_ongoing <- TRUE
			     }
	})
}
