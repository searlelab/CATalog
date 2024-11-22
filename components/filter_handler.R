filter_handler <- function(input, trigger, Database, Search, demographics){
	observeEvent(input[[trigger]],{
    		Database$background <- Database$background_cache
    		if(Search$is_ongoing == FALSE){
      			Database$background <- apply_demographic_filter(Database$background, demographics, max_age = input$age_filter, max_bsc = input$bsc_filter)
      			Database$foreground <- generate_foreground(Database$background)
      			Database$foreground <- filter_foreground(Database$foreground, target = input$sample_type)
    		}
    		else if(Search$is_ongoing == TRUE){
      			Database$background <- filter_background_by_cache(Database$background, Search$cache)
      			Database$background <- apply_demographic_filter(Database$background, demographics, max_age = input$age_filter, max_bsc = input$bsc_filter)
      			Database$foreground <- generate_foreground(Database$background)
      			Database$foreground <- filter_foreground(Database$foreground, target = input$sample_type)
    		}
  	})
}
