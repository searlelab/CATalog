check_secondary_biofluid <- function(df, j){
	output <- 0
	#"j" is the index of the biofluid in the foreground dataframe
	#finding the target's value
	v <- df[,j]
	q <- subset(df, select = c(Urine, Serum, Plasma))
	vals <- as.numeric(as.vector(q[1,]))
	#sort from lowest to highest
	vals_sorted <- sort(vals, decreasing = TRUE)
	target <- vals_sorted[2] #getting the second highest value
	if(v == target){
		output <- output + 1
	}
	output
}

