shopping_cart_display_backend <- function(output, ShoppingCart){
	output$shopping_cart_display <- DT::renderDataTable({
		req(ShoppingCart$current_table)
    		datatable(ShoppingCart$current_table,
              		selection = "single",
              		options = list(
                	scrollX = TRUE,
                	autoWidth = TRUE,
                	pageLength = 10
              	),
              	class = 'main_display nowrap'
              	)
  	})
}
