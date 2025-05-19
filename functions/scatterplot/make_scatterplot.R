make_scatterplot <- function(data_list, name){
	data <- rbind(data_list[[1]], data_list[[2]], data_list[[3]])
	data$Age <- as.numeric(data$Age)
	data <- data[order(data$Age), ]
	biofluid_colors <- c('#D55382', '#003F5C', '#FFA600')
	plot <- ggplot(data, aes(x = Age, y = value, color = biofluid, group = biofluid)) +
  			geom_line() + 
  			geom_point() +  # Add points to the line plot
			scale_color_manual(values = biofluid_colors)+
  			labs(x = "Age", y = "Relative Abundance", color = "Biofluid") + 
  			ggtitle(name) +
  			theme_minimal()
	return(plot)
}	
