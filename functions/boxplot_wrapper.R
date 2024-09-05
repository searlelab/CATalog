boxplot_wrapper <- function(data, i){
	output <- format_data(data, i)
	print(head(output))
	name <- unlist(output[1])
	df <- as.data.frame(output[[2]])
	plot <- make_boxplot(df, name)
	plot
}

