scatterplot_driver<- function(Database){
	names <- c("Urine", "Plasma", "Serum")
	r <- Database$background%>%
		filter(Entry == Database$current_entry)
	r <- subset(r, select = -c(Entry, Protein, Gene))
	second_letter <- substr(names(r), 2, 2)
	subframes <- lapply(unique(second_letter), function(letter){
				    r[,second_letter == letter, drop = FALSE]
	})
	demographics <- format_demographics(Database$demographics)
	processed_frames <- list()
	for(i in 1:length(subframes)){
		df <- format_subframe(df = subframes[[i]],
				      name = names[i],
				      demographics)
		processed_frames[[i]] <- df
	}
	plot <- make_scatterplot(processed_frames, name = Database$current_name)
	return(plot)
}
