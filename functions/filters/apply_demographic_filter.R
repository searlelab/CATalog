apply_demographic_filter <- function(background, demographics, max_age, max_bsc){
	if(max_age < 11 ){
		background <- filter_background(background, demographics, target = "Age", max_value = max_age)
		print("Age filter passed")
	}
	if(max_bsc < 10){
		background <- filter_background(background, demographics, target = "BSC", max_value = max_bsc)
		print("BSC filter passed")
	}
	background
}


