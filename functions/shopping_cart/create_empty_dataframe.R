create_empty_dataframe <- function(input_frame = NULL, type = "go"){
	if(type == "go" && is.null(input_frame)){
		names <- c("source", "Description", "GO_ID", "type", "Entry", "Protein", "Gene")
		mat = matrix(ncol = 7, nrow = 0)
		df = data.frame(mat)
		colnames(df) <- names
		return(df)
	}
	else{
		mat = matrix(ncol = ncol(input_frame), nrow = 0)
		df = data.frame(mat)
		colnames(df) <- colnames(input_frame)
		return(df)
	}
}

