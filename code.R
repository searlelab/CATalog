setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog")

library(tidyverse)

background <- read.csv("background.csv")
data <- read.csv("go_data.csv")

index <- 1
word <- "wnt"

search_go_data_background <- function(data, background, index, word){
	#pattern <- create_pattern(word)
	#df <- data%>%
		#filter(str_detect(data[,index], pattern))
	df <- data[grepl(word, data[,index], ignore.case = TRUE),]
	entries <- df$Column2
	res <- background%>%
		filter(Entry %in% entries)
	res
}

res <- search_go_data_background(data, background, index, word)
