filter_highest_biofluid <- function(data, j){
       #setting up the output dataframe
	names <- colnames(data)
	mat <- matrix(ncol = length(names), nrow = 0)
	output <- data.frame(mat)
	colnames(output) <- names
	#applying the filter
	for(row in 1:nrow(data)){
		r <- data[row,]
		x <- check_highest_biofluid(r, j)
		if(x == 1){
			output <- rbind(output, r)
		}
	}
	output
}	
