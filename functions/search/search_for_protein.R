search_for_protein <- function(data, field, keyword){
	if(field == "Protein name"){
		search_results <- data[grepl(keyword, data[,2], ignore.case = TRUE),]
	}
	if(field == "Gene name"){
		search_results <- data[grepl(keyword, data[,1], ignore.case = TRUE),]
	}
	if(field == "Entry"){
		search_results <- data[grepl(keyword, data[,3], ignore.case = TRUE),]

	}
	return(search_results)
}

