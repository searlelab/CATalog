make_age_scatterplot <- function(df, name){
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

