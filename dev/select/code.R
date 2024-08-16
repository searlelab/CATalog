setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog\\dev\\select")

library(tidyverse)

data <- read.csv("foreground.csv")

#function to find the highest biofluid for a given row
#for simplicty, we will have two different functions- one for a single category and one for two categories; The one for two categories will contain the one for a single category
#there is also a 'stupid' method that applies this method twice

check_highest_biofluid <- function(df, j){
	output <- 0
	#"j" is the index of the biofluid in the foreground dataframe
	#finding the target's value
	v <- df[,j]
	q <- subset(df, select = c(Urine, Serum, Plasma))
	vals <- as.numeric(as.vector(q[1,]))
	target <- max(vals)
	if(v == target){
		output <- output + 1
	}
	output
}

#ok, that's working, now we need to make it useful

#first, we will set up an empty dataframe

names <- colnames(data)
mat <- matrix(ncol = length(names), nrow = 0)
df_urine_test <- data.frame(mat)
colnames(df_cut) <- names

#now we will loop over the dataframe and select those with the highest amount in the Urine biofluid



for(row in 1:nrow(data)){
	r <- data[row,]
	output <- check_highest_biofluid(r, j)
	if(output == 1){
		df_urine_test <- rbind(df_urine_test, r)
	}
}


#this works; ready to integrate at a later time

		


