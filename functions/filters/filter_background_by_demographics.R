filter_background_by_demographics <- function(data, demographics, demographic_field, value){
	#print(paste("the current demographic filter value is: ", value))
	if(is.numeric(value)){
		#print("detected numeric data")
		#filtering by age or BSC
		r <- demographics%>%
			filter(Cat == demographic_field)
		r <- data.frame(t(r[-1]))
		r[,1] <- as.numeric(r[,1])
		names <- row.names(r %>% filter(r[,1] <= value))
	}
	if(!is.numeric(value)){
		#print("detected character data")
		#print(paste("the length of the value is: ", length(value)))
		#filtering by sex
		if(value == "Female Spayed"){
			value = "FS"
		}
		else{
			value = "MN"
		}
		r <- demographics%>%
			filter(Cat == demographic_field)
		r <- data.frame(t(r[-1]))
		names <- row.names(r %>% filter(r[,1] == value))
	}
	metadata <- data%>%select(1:3)
	data <- data[,-1:-3]
	pattern <- paste(names, collapse = "|")
	filtered_data <- data[,grepl(pattern, names(data))]
	data <- cbind(metadata, filtered_data)
	return(data)
}


