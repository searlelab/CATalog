format_data <- function(data, i){
	x <- data[i,]
	name <- x[,4]
	x <- subset(x, select = -c(Entry, Reviewed, Entry.Name, Protein.names, Gene.Names))
	values <- as.numeric(x)
	labels <- colnames(x)

	urine <- replicate(8, "urine")
	plasma<- replicate(8, "plasma")
	serum <- replicate(8, "serum")

	biofluid <- c(urine, plasma, serum)

	df <- data.frame(values, biofluid, labels)

	#trick to return multiple outputs from an R function
	output <- list(name, df)
	output
}

