set_plot <- function(plots, plot_type){
	if(plot_type == "Global Boxplot"){
		print(class(plots[[1]]))
		output <- plots[[1]]
	}
	if(plot_type == "By Age"){
		print(class(plots[[2]]))
		output <- plots[[2]]
	}
	output
}
