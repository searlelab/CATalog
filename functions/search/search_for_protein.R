search_for_protein <- function(data, field, keyword){
	#print("running protein searcher")
	#print(paste("keyword is: ", keyword))
	#print(paste("search field is: ", field))
	#print(head(data))
	#print(ncol(data))
	#print(colnames(data))
	if(field == "Protein name"){
		#need to do something a bit more complex here
		#print("triggered condition 1")
		search_results <- data[grepl(keyword, data[,2], ignore.case = TRUE),]
	}
	if(field == "Gene name"){
		#print("triggered condition 2")
		search_results <- data[grepl(keyword, data[,1], ignore.case = TRUE),]
	}
	if(field == "Entry"){
		#print("triggered condition 3")
		search_results <- data[grepl(keyword, data[,3], ignore.case = TRUE),]

	}
	return(search_results)
}

