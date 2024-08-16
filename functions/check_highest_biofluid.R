check_highest_biofluid <- function(df, j){
	output <- 0
	#"j" is the index of the biofluid in the foreground dataframe
	#finding the target's value
	v <- df[,j]
	q <- subset(df, select = c(Urine, Serum, Plasma))
	vals <- as.numeric(as.vector(q[1,]))
	target <- max(vals)
	if(v == target){
		output <- output + 1
	}
	output
}

