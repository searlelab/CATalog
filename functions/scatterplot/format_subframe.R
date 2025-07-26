format_subframe <- function(df, name, demographics){
	df <- data.frame(t(df))
	row.names(df) <- gsub("^(.).", "\\1", row.names(df))
	colnames(df) <- 'value'
	df$Age <- demographics$Age[match(row.names(df), demographics$Cat)]
	df$biofluid <- name
	return(df)
}


