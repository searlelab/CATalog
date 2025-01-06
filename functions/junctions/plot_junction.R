plot_junction <- function(Plot, plot_type){
	if(plot_type == "boxplot"){
		plot <- Plot$boxplot
		return(plot)
	}
	else if(plot_type == 'scatterplot'){
		plot <- Plot$scatterplot
		return(plot)
	}
}
