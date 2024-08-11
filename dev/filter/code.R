setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog\\dev\\filter")

library(tidyverse)

foreground <- read.csv("foreground.csv")
background <- read.csv("background.csv")

options <- c("unreviewed", "reviewed", "all")

#obtain list of peptides that particular review status
find_protein_status <- function(background, option){
	if(option == "unreviewed"){
		df <- background%>%
			filter(Reviewed == option)
	}
	else if(option == "reviewed"){
		df <- background%>%
			filter(Reviewed == option)
	}
	else{
		df <- background
	}
	proteins <- df$Protein.names
	proteins
}

t1 <- find_protein_status(background, option = "unreviewed") #1869
t2 <- find_protein_status(background, option = "reviewed") #53
t3 <- find_protein_status(background, option = "all") #1949

#the first function is working correctly, now a simple function to filter the foreground data
filter_foreground <- function(foreground, protein){
	df <- foreground%>%
		filter(Protein.name %in% protein)
	df
}
