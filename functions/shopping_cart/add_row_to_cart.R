add_row_to_cart <- function(shopping_frame, input_frame, index){
	r <- input_frame[index,]
	shopping_frame <- rbind(shopping_frame, r)
	shopping_frame
}
