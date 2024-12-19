filter_background <- function(data, demographics, target, value){
	#print("filtering the background")
	#print(target)
	r <- demographics%>%
		filter(Cat == target)
	#print(head(r))
	#print("check 1")
	r <- data.frame(t(r[-1]))
	#print(head(r))
	#print("check 1.1")
	r[,1] <- as.numeric(r[,1])
	#print("check 1.2")
	n <- row.names(r %>% filter(r[,1] <= value))
	#print("check 1.3")
	metadata <- data%>%select(1:3)
	#print("check 1.4")
	data <- data[,-1:-3]
	#print("check 2")
	pattern <- paste(n, collapse = "|")
	filtered_data <- data[,grepl(pattern, names(data))]
	data <- cbind(metadata, filtered_data)
	#print(head(data))
	#print("sucessfully filtered background")
	return(data)
}

