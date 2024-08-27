setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog\\dev\\go_filter\\debug")

library(tidyverse)

foreground <- read.csv("foreground.csv") #1900 original proteins
go_data <- read.csv("go_data.csv")

proteins <- foreground$Entry

s <- go_data%>%
	filter(Column2 %in% proteins) #1800 results

#debugging a new problem
index <- 5
word <- "GO:0016038"
df <- go_data[grepl(word, go_data[,index]),] #2 entries
entries <- df$Column2 #2 entries
res <- foreground%>% #0 entries
	filter(Entry %in% entries)

#this is strange, I'm going to test some more things.
#here is an entry that should not bring up any results:
test_entry <- "M3W0W4_FELCA"

data <- go_data #for ease of use

#there is an alignment issue with this current function, so the index must be mapped to the correct protein

map_go_protein <- function(foreground, i){
	r <- foreground[i,]
	protein <- r$Entry
	protein
}

#then a change to the way we extract the row
parse_cell <- function(protein, index, data){
	#r <- data[id,] #extracting row based on user selection
	r <- data%>%
		filter(Column2 == protein)
	info <- r[,index] #selecting out desired information
	semi_parsed <- unlist(strsplit(info, split = ';')) #preprocessing the informaiton
	df <- data.frame(semi_parsed)%>% #formatting
		tidyr::separate(semi_parsed, into = c("Description", "GO_ID"), sep = "\\[|\\]", extra = "drop", fill = "right")
	df
}

#and a test
foo <- parse_cell(protein, 5, data) #0 rows, as expected

#we are running into another issue when plugging this into the main app
#this involves debugging the cell parser
#test case willbe M3VUU7_FELCA

protein <- "M3VUU7_FELCA"
r <- data%>%
	filter(Column2 == protein)


