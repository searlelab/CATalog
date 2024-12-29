format_demographics <- function(demographics){
	x <- data.frame(t(demographics))
	colnames(x) <- x[1,]
	x <- x[-1,]
	x$Cat <- rownames(x)
	return(x)
}
