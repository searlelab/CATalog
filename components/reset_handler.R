reset_handler <- function(input, session, trigger, Database, Search){
	observeEvent(input[[trigger]],{
			      Database$background <- Database$background_cache
    			      Database$foreground <- Database$foreground_cache
    			      updateTextInput(session,"keyword", value="")
    			      updateNumericInput(session, "age_filter", value = 11)
   			      updateNumericInput(session, "bsc_filter", value = 10)
    			      Search$is_ongoing <- FALSE
	})
}
