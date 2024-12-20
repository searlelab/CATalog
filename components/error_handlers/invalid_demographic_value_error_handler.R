invalid_demographic_value_error_handler <- function(input, button_id, min, max){
	observeEvent(input[[button_id]],{
			     value = input[[button_id]]
			     if(value > max || value < min || is.null(value) || !is.numeric(value)){
				     shinyalert(print(paste("Please enter a value between ", min, "and", max)))
			     }
	})
}
