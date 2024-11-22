filter_foreground <- function(data, target){
	if(target == "all"){
		print("returning all data")
		df = data
	}
	else{
		#mapping the target to an index
		print("filtering based on condition")
		index <- map_target_to_index(target)
		#print(index)
		#generate an empty foreground dataframe
		mat = matrix(ncol = 6, nrow = 0)
		df = data.frame(mat)
		names = c("Entry", "Protein", "Gene", "Urine", "Plasma", "Serum")
		colnames(df) <- names

		#iterate over the dataframe and do some calculations on a row-by-row basis
		for(row in 1:nrow(data)){
			r <- data[row,]
			max_value <- max(as.numeric(as.vector(r[,4:6])))
			target_value <- r[,index]
			delta <- abs(max_value - target_value)
			#print(delta)
			if(delta <= 1){
				df <- rbind(df, r)
			}
		}
	}
	#print(nrow(df))
	df
}

