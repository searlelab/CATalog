download_go_handler <- function(output, ShoppingCart){
	output$download_go_button <- downloadHandler(
    		filename = function(){
      		paste("go_data-", Sys.Date(), ".csv", sep="")
    	},
    	content = function(file){
      		data <- ShoppingCart$go_data
      		write.csv(data, file, row.names = FALSE)
    	}
  )
}
