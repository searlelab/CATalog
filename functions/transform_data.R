transform_data <- function(df){
	datatype <- colnames(df)
	values <- df[1,]
	output <- data.frame(datatype, values)
	output
}
