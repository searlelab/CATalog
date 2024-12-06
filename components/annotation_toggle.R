annotation_toggle <- function(input, trigger, Plot, Database){
	observeEvent(input[[trigger]],{
    		Plot$is_annotated <- input$plot_labels
    		if(Plot$is_annotated == "off"){
      			Plot$demographics <- NULL
    		}
    		if(Plot$is_annotated == "on"){
      			Plot$demographics <- demographics
    		}
		#remake the boxplot
		if(!is.null(Database) && 
		   !is.null(Database$current_entry)&&
		   !is.null(Database$background)){
			Plot$boxplot <- boxplot_driver(Database$background, 
					       entry = Database$current_entry,
					       flag = Plot$is_annotated)
		}
  	})
}
  
