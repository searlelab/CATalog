add_multiple_rows_to_cart <- function(shopping_frame, entry_df){
	shopping_frame <- rbind(shopping_frame, entry_df)
	return(shopping_frame)
}
