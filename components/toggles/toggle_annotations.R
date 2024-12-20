toggle_annotations <- function(input, trigger, Plot, Database){
	observeEvent(input[[trigger]],{
		#print("triggered the annotation toggle")
		#print(head(Global$demographics))
    		Plot$is_annotated <- input$plot_labels
    		#if(Plot$is_annotated == "off"){
      			#Global$demographics <- NULL
    		#}
    		#if(Plot$is_annotated == "on"){
      			#Global$demographics <- Global$demographics
    		#}
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
  
