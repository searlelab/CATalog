make_scatterplot <- function(data_list){
	data <- rbind(data_list[[1]], data_list[[2]], data_list[[3]])
	data <- data[order(data$Age), ]
	plot <- ggplot(data, aes(x = Age, y = value, color = biofluid, group = biofluid)) +
  			geom_line() + 
  			geom_point() +  # Add points to the line plot
  			labs(x = "Age", y = "Value", color = "Biofluid") + 
  			ggtitle("Line Plot of Urine, Plasma, and Serum") +
  			theme_minimal()
	return(plot)
}	
