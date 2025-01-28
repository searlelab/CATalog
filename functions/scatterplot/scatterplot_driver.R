scatterplot_driver<- function(Database){
	names <- c("Urine", "Plasma", "Serum")
	r <- Database$background%>%
		filter(Entry == Database$current_entry) #isolate the current row
	r <- subset(r, select = -c(Entry, Protein, Gene)) #isolate the samples
	second_letter <- substr(names(r), 2, 2) #get the biofluid symbol from each sample column
	subframes <- lapply(unique(second_letter), function(letter){
				    r[,second_letter == letter, drop = FALSE]
	}) #break each sample into a list of dataframes based on individual biofluid
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
