download_protein_handler <- function(output, ShoppingCart){
	output$download_protein_button <- downloadHandler(
    		filename = function(){
      		paste("protein_data-", Sys.Date(), ".csv", sep="")
    	},
    	content = function(file){
      		data <- ShoppingCart$data
      		write.csv(data, file, row.names = FALSE)
    	}
  )
}
