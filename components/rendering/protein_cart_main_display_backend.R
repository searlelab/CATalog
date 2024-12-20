protein_cart_main_display_backend <- function(output, ShoppingCart){
	output$protein_cart_main_display <- DT::renderDataTable({
    		datatable(ShoppingCart$data,
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
