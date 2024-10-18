format_data <- function(data, entry){
	r <- data%>%
		filter(Entry == entry)
	name <- r[,4]
	x <- subset(r, select = -c(dropme, Reviewed, Entry, Protein.names, Gene.Names))
	values <- as.numeric(x)
	labels <- colnames(x)

	urine <- replicate(8, "urine")
	plasma<- replicate(8, "plasma")
	serum <- replicate(8, "serum")

	biofluid <- c(urine, plasma, serum)

	df <- data.frame(values, biofluid, labels)

	output <- list(name, df)
	output
}

