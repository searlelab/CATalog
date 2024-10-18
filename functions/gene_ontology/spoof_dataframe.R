spoof_dataframe <- function(protein){
	mat = matrix(ncol = 7, nrow = 1)
	names = c("Column1", "Column2", "Column3", "Column4", "Column5", "Column6", "Column7")

	df = data.frame(mat)
	colnames(df) <- names
	dummy <- c(protein, "", "", "", "", "", "")
	df <- rbind(df, dummy)
	df <- df[-1,]
	df
}


