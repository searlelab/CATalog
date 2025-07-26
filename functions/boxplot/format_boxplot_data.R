format_boxplot_data <- function(data, entry){
	r <- data%>%
		filter(Entry == entry)
	name <- r[,2]
	x <- subset(r, select = -c(Entry, Protein, Gene))
	values <- as.numeric(x)
	labels <- colnames(x)

	urine <- replicate((ncol(x)/3), "Urine")
	plasma<- replicate((ncol(x)/3), "Plasma")
	serum <- replicate((ncol(x)/3), "Serum")

	biofluid <- c(urine, plasma, serum)

	df <- data.frame(values, biofluid, labels)

	output <- list(name, df)
	output
}

