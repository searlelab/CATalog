search_handler <- function(input, trigger, Database, Search){
	observeEvent(input[[trigger]],{
			     Database$foreground <- Database$foreground_cache
			     index <- go_column_mapper(input$go_item)
			     search_results <- search_for_go_keyword(go_data, Database$foreground, go_field = index, keyword = input$keyword)
			     Database$foreground <- search_results
			     Search$cache <- search_results
			     Search$is_ongoing <- TRUE
	})
}
