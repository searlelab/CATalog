boxplot_wrapper <- function(data, i, flag){
	output <- format_data(data, i)
	name <- unlist(output[1])
	df <- as.data.frame(output[[2]])
	if(flag == "off"){
		plot <- make_boxplot_unannotated(df, name)
	}
	if(flag == "on"){
		plot <- make_boxplot_annotated(df, name)
	}
	plot
}

