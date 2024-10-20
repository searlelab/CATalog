annotate_row <- function(r, l, demographics){
	r <- subset(r, select = -c(toremove, Reviewed, Entry, Protein.names, Gene.Names))
	s <- r%>%
		dplyr::select(starts_with(l))
	annotations <- demographics[, grep(l, colnames(demographics), value = TRUE)]
	colnames(s) <- sub("^.", "", colnames(s))
	s$age <- as.numeric(annotations[1])
	s$sex <- annotations[2]
	s$cat <- l
	s
}

