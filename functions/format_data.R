format_data <- function(data, i){
	x <- data[i,]
	name <- x[,4]
	x <- subset(x, select = -c(Entry, Reviewed, Entry.Name, Protein.names, Gene.Names))
	values <- as.numeric(x)
	labels <- colnames(x)

	urine <- replicate(9, "urine")
	plasma<- replicate(9, "plasma")
	serum <- replicate(9, "serum")

	group <- c(urine, plasma, serum)

	df <- data.frame(values, group, labels)

	#trick to return multiple outputs from an R function
	output <- list(name, df)
	output
}

