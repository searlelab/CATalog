create_empty_go_dataframe <- function(){
	names <- c("source", "Description", "GO_ID", "type", "Entry", "Protein", "Gene")
	mat = matrix(ncol = 7, nrow = 0)
	df = data.frame(mat)
	colnames(df) <- names
	return(df)
}
