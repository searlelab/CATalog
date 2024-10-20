set_plot <- function(plots, plot_type){
	if(plot_type == "Global Boxplot"){
		output <- plots[[1]]
	}
	if(plot_type == "By Age"){
		output <- plots[[2]]
	}
	if(plot_type == "By BCS"){
		output <- plots[[3]]
	}
	output
}
