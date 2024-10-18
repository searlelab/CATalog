setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog")

library(tidyverse)

background <- read.csv('./data/background.csv')
demographics <- read.csv('./data/demographics.csv')

r <- background[1,]

name <- r$Protein.names

#the above needs to be converted to a function
annotate_row <- function(r, l, demographics){
	s <- r%>%
		dplyr::select(starts_with(l))
	annotations <- demographics[, grep(l, colnames(demographics), value = TRUE)]
	colnames(s) <- sub("^.", "", colnames(s))
	s$age <- as.numeric(annotations[1])
	s$sex <- annotations[2]
	s$cat <- l
	s
}

annotated_frame_generator <- function(r, demographics){
	cat_names <- c("A", "B", "C", "D", "E", "G", "H", "G")
	colnames(demographics)[1] <- "X"
	mat = matrix(ncol = 6, nrow = 0)
	column_names = c("U", "P", "S", "age", "sex", "cat")
	df = data.frame(mat)
	colnames(df) <- column_names
	for(cat_name in cat_names){
		s <- annotate_row(r, l = cat_name, demographics)
		df <- rbind(df, s)
	}
	df
}

	
#a plot was made by ChatGPT
ggplot(df_long, aes(x = age, y = Value, color = Measurement)) +
  geom_point() +  # Use points for the scatter plot
  geom_line(aes(group = Measurement)) +  # Connect points with lines
  labs(title = "Scatter Plot of U, P, and S by Age",
       x = "Age",
       y = "Value") +
  scale_color_manual(
    values = c('#FFA600', '#D55382',  '#003F5C'),
    labels = c('urine', 'plasma', 'serum'),
    name = "Measurement"  # Custom legend title
  ) +
  theme_minimal() 

#and we put the above into a function
make_scatterplot <- function(df, name){
	df_long <- pivot_longer(df, cols = c("U", "P", "S"), names_to = "Measurement", values_to = "Value")
	plot <- ggplot(df_long, aes(x = age, y = Value, color = Measurement))+
		geom_point()+
		geom_line(aes(group = Measurement))+
		labs(title = name,
		     x = "Age",
		     y = "Relative Abundance")+
		scale_color_manual(
			values = c('#FFA600', '#D55382',  '#003F5C'),
			labels = c('urine', 'plasma', 'serum'),
			name = "Biofluid"  # Custom legend title
			)+
		theme_minimal()
	plot
}


