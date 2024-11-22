filter_background <- function(data, demographics, target, max_value){
	r <- demographics%>%
		filter(Cat == target)

	r <- data.frame(t(r[-1]))
	r[,1] <- as.numeric(r[,1])
	n <- row.names(r %>% filter(r[,1] <= max_value))
	metadata <- data%>%select(1:3)
	data <- data[,-1:-3]

	pattern <- paste(n, collapse = "|")
	filtered_data <- data[,grepl(pattern, names(data))]
	data <- cbind(metadata, filtered_data)

	data
}

