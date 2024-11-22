apply_demographic_filter <- function(background, demographics, max_age, max_bsc){
	if(max_age < 11 ){
		background <- filter_background(background, demographics, target = "Age", max_value = max_age)
	}
	if(max_bsc < 10){
		background <- filter_background(background, demograpics, target = "BCS", max_value = max_bsc)
	}
	background
}


