scatterplot_driver<- function(Database, Global){
	#print("check 1")
	names <- c("Urine", "Plasma", "Serum")
	#print(paste("current entry is: ", Database$current_entry))
	r <- Database$background%>%
		filter(Entry == Database$current_entry)
	#print("check 2")
	r <- subset(r, select = -c(Entry, Protein, Gene))
	#print("check 3")
	second_letter <- substr(names(r), 2, 2)
	#print("check 4")
	subframes <- lapply(unique(second_letter), function(letter){
				    r[,second_letter == letter, drop = FALSE]
	})
	#print("check 5")
	demographics <- format_demographics(Global$demographics)
	#print("check 6")
	processed_frames <- list()
	#iterate over the list of subframes
	for(i in 1:length(subframes)){
		df <- format_subframe(df = subframes[[i]],
				      name = names[i],
				      demographics)
		processed_frames[[i]] <- df
	}
	#print("check 7")
	#make the scatterplot from the list of processed subframes
	plot <- make_scatterplot(processed_frames)
	#print("check 8")
	return(plot)
}
