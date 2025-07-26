generate_foreground <- function(data){
	#making an empty dataframe
	mat = matrix(ncol = 6, nrow = 0)
	df = data.frame(mat)
	names = c("Entry", "Protein", "Gene", "Urine", "Plasma", "Serum")
	colnames(df) <- names

	for(row in 1:nrow(data)){
		r <- data[row,]
		s <- r[,-1:-3] #removing the first three columns
		Urine <- round(mean(as.numeric(as.vector(s[,grepl('U', names(s))]))), 1)
		Plasma <- round(mean(as.numeric(as.vector(s[,grepl('P', names(s))]))), 1) #these are working
		Serum <- round(mean(as.numeric(as.vector(s[,grepl('S', names(s))]))), 1)
		Entry <- r$Entry
		Protein <- r$Protein
		Gene <- r$Gene
		row_to_add <- data.frame(Gene, Protein, Entry, Urine, Plasma, Serum)
		df <- rbind(df, row_to_add)
	}
	return(df)
}


