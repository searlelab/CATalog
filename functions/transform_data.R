transform_data <- function(df){
	output <- t(df)
	colnames(output) <- "item"
	output	
}
