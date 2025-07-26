filter_foreground_by_highest_biofluid <- function(data, biofluid, delta_threshold){
	print(paste("the class of the delta threshold is: ", class(delta_threshold)))
	col_index <- map_biofluid_to_column_index(biofluid)
	#generate an empty foreground dataframe
	mat = matrix(ncol = 6, nrow = 0)
	df = data.frame(mat)
	names = c("Entry", "Protein", "Gene", "Urine", "Plasma", "Serum")
	colnames(df) <- names

	#iterate over the dataframe and do some calculations on a row-by-row basis
	for(row in 1:nrow(data)){
		print("in the loop")
		r <- data[row,]
		max_value <- max(as.numeric(as.vector(r[,4:6])))
		target_value <- r[,col_index]
		delta <- abs(max_value - target_value)
		if(delta <= delta_threshold){
			print("if you don't see this, the issue is here")
			df <- rbind(df, r)
		}
	}
	return(df)
}
	

