annotated_frame_generator <- function(r, demographics){
	cat_names <- c("A", "B", "C", "D", "E", "G", "H", "G")
	colnames(demographics)[1] <- "X"
	mat = matrix(ncol = 6, nrow = 0)
	column_names = c("U", "P", "S", "age", "sex", "cat")
	df = data.frame(mat)
	colnames(df) <- column_names
	for(cat_name in cat_names){
		s <- annotate_row(r, l = cat_name, demographics)
		df <- rbind(df, s)
	}
	df
}


