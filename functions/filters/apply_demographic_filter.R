apply_demographic_filter <- function(background, demographics, target, value, max_value){
	print("attempting to apply demographic filter")
	#preliminary requirements
	if(!is.null(value) && is.numeric(value)){
		  print("conditions met, executing filter")
		  if(value > 0 && value <= max_value){
			print("conditions met, applying filter")
		  	background <- filter_background(background, demographics, target, value)
		  }
		  
	}
	else{
	     print("did not apply filter")
	}
	return(background)
}
		 		 

