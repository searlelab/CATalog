update_demographics <- function(background, demographics){
	col_names <- colnames(background)
	names <- col_names[nchar(col_names) == 2]
	cats_of_interest <- unique(substr(names, 1, 1))
	metadata <- demographics[,1]
	demographics <- demographics[,-1]
	demographics <- demographics[, substr(colnames(demographics), 1, 1) %in% cats_of_interest]
	demographics <- cbind(metadata, demographics)
	return(demographics)
}


