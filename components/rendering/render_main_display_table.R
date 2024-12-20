render_main_display_table <- function(output, table_id, Database){
	output[[table_id]] <- DT::renderDataTable({
    		data_with_check <- Database$foreground
    		data_with_check$Check <- sprintf(
      			"<input type='checkbox' class='checkbox' id='checkbox_%s' />",
      			data_with_check$Entry
    		)
    		data_with_check <- data_with_check[, c("Check", setdiff(names(data_with_check), "Check"))]
    
    		datatable(data_with_check, 
              		selection = 'single',
              		escape = FALSE,
              		options = list(dom = 'Bfrtip',
                             	       pageLength = 10,
                                       autoWidth = FALSE,
                                       searching = FALSE,
                                       paging = TRUE
                                   ), class = 'cell-border stripe hover nowrap')
  		}, server = FALSE)

}
