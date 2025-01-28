filter_background_by_demographics <- function(data, demographics, demographic_field, value){
	r <- demographics%>%
		filter(Cat == demographic_field)
	r <- data.frame(t(r[-1]))
	r[,1] <- as.numeric(r[,1])
	n <- row.names(r %>% filter(r[,1] <= value))
	metadata <- data%>%select(1:3)
	data <- data[,-1:-3]
	pattern <- paste(n, collapse = "|")
	filtered_data <- data[,grepl(pattern, names(data))]
	data <- cbind(metadata, filtered_data)
	return(data)
}

