query <- function(up, entry, fields){
	res <- select(x = up, keys = entry, columns = fields, keytype = "UniProtKB")
	res
}
