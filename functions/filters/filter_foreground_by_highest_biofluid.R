filter_foreground_by_highest_biofluid <- function(data, biofluid){
	if(biofluid == "all"){
		df = data
	}
	else{
		#mapping the target to an index
		col_index <- map_biofluid_to_column_index(biofluid)
		#generate an empty foreground dataframe
		mat = matrix(ncol = 6, nrow = 0)
		df = data.frame(mat)
		names = c("Entry", "Protein", "Gene", "Urine", "Plasma", "Serum")
		colnames(df) <- names

		#iterate over the dataframe and do some calculations on a row-by-row basis
		for(row in 1:nrow(data)){
			r <- data[row,]
			max_value <- max(as.numeric(as.vector(r[,4:6])))
			target_value <- r[,col_index]
			delta <- abs(max_value - target_value)
			if(delta <= 1){
				df <- rbind(df, r)
			}
		}
	}
	df
}

