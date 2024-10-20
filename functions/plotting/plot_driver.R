plot_driver <- function(data, entry, flag, demographics){
	output <- format_boxplot_data(data, entry)
	name <- unlist(output[1])
	df <- as.data.frame(output[[2]])
	if(flag == "off"){
		boxplot <- make_boxplot_unannotated(df, name)
	}
	if(flag == "on"){
		boxplot <- make_boxplot_annotated(df, name)
	}

	#handle the demographic plots
	r <- data%>%
		filter(Entry == entry)
	df_annotated <- annotated_frame_generator(r, demographics)
	scatterplot <- make_scatterplot(df_annotated, name = entry)
	plots <- list(boxplot, scatterplot)
	plots
}

