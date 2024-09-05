boxplot_wrapper <- function(data, i, flag){
	output <- format_data(data, i)
	print(head(output))
	name <- unlist(output[1])
	df <- as.data.frame(output[[2]])
	if(flag == "off"){
		plot <- make_boxplot_unannotated(df, name)
	}
	if(flag == "on"){
		plot <- make_boxplot(df, name)
	}
	plot
}

