annotation_toggle <- function(input, trigger, Plot){
	observeEvent(input[[trigger]],{
    		Plot$is_annotated <- input$plot_labels
    		if(Plot$is_annotated == "off"){
      			Plot$demographics <- NULL
    		}
    		if(Plot$is_annotated == "on"){
      			Plot$demographics <- demographics
    		}
  	})
}
  
