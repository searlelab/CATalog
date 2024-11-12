filter_background <- function(data, demographics, target, max_value){
	print("alpha")
	print(max_value)
	r <- demographics%>%
		filter(Cat == target)
	print("beta")
	print(nrow(r))

	r <- data.frame(t(r[-1]))
	print("beta check")
	print(head(r))
	print(nrow(r))
	r[,1] <- as.numeric(r[,1])
	print("charlie")
	print(nrow(r))
	n <- row.names(r %>% filter(r[,1] <= max_value))
	print("delta")
	print(n)

	metadata <- data%>%select(1:3)
	print("echo")
	print(head(metadata))
	data <- data[,-1:-3]

	pattern <- paste(n, collapse = "|")
	print("foxtrot")
	print(pattern)
	filtered_data <- data[,grepl(pattern, names(data))]
	data <- cbind(metadata, filtered_data)

	data
}

