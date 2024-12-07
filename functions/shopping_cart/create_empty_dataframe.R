create_empty_dataframe <- function(input_frame){
	mat = matrix(ncol = ncol(input_frame), nrow = 0)
	df = data.frame(mat)
	colnames(df) <- colnames(input_frame)
	df
}

