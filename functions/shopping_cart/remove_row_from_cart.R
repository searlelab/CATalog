remove_row_from_cart <- function(shopping_frame, index){
	neg_index <- index*-1
	df <- shopping_frame[neg_index,]
	df
}
