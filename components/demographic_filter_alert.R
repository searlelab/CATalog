demographic_filter_alert <- function(input, button_id, min, max){
	observeEvent(input[[button_id]],{
			     print("triggered demographic alert")
			     value = input[[button_id]]
			     print(value)
			     if(value > max || value < min || is.null(value) || !is.numeric(value)){
				     shinyalert(print(paste("Please enter a value between ", min, "and", max)))
			     }
	})
}
