boxplot_driver <- function(data, entry, flag, demographics){
	output <- format_data(data, entry)
	name <- unlist(output[1])
	df <- as.data.frame(output[[2]])

	plot <- make_boxplot(sample_demographics, name, flag)
	plot
}

