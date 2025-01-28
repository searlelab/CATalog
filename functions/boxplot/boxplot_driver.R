boxplot_driver <- function(data, entry, flag){
	output <- format_boxplot_data(data, entry)
	name <- unlist(output[1])
	df <- as.data.frame(output[[2]])

	plot <- make_boxplot(df, name, flag)
	plot
}

