protein_cart_main_display_backend <- function(output, ShoppingCart){
	output$protein_cart_main_display <- DT::renderDataTable({
		req(ShoppingCart$current_frame)
    		datatable(ShoppingCart$current_frame,
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
