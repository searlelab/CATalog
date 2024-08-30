setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog\\dev\\delta")

library(tidyverse)

#loading the data
data <- read.csv("deltas.csv")

report_log <- c()

#staring a loop over the rows
for(i in 1:nrow(data)){
	r <- data[i,]
	report_string <- biofluid_reporter(r)
	report_log <- append(report_log, report_string)
}

#the above counts in the event that the delta is less than 1, meaning that there is little difference in biofluid.
#if the delta is greater than one across the entire row, i.e.m the report is 0, then there is a dominant biofluid that must be identified.

find_largest_biofluid <- function(df){
	fluids <- c(df[,2], df[,3], df[,4])
	arr_index <- which(fluids == max(fluids))
	names <- colnames(r)
	name <- names[arr_index + 1]
}

#we can pull out part of the complex loop above as a function
biofluid_reporter <- function(r){
		#vector for storing items
	items <- c()
	#now we check each delta
	if(r[,5] < 1){
		items <- append(items, c("Urine", "Plasma"))
	}
	if(r[,6] < 1){
		items <- append(items, c("Urine", "Serum"))
	}
	if(r[,7] < 1){
		items <- append(items, c("Plasma", "Serum"))
	}
	report <- unique(items)
	if(length(report) == 0){ #retroactivelly adding the latter in
		name <- find_largest_biofluid(r)
		report <- append(report, name)
	}
	report_string <- paste(report, collapse = ';')
	report_string
}

