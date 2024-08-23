setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog\\dev\\go_filter")

library(tidyverse)

data <- read.csv("go_data.csv")

#we have two tasks here:
	#1. Single-row operations; parsing into a useful format
	#2. Searching the table for specific keywords

#parsing a single row

r <- data[2,]

#extracting the three main columns from this as a string (5, 6, 7)

bio_process <- r[,5]
cell_comp <- r[,6]
mol_func <- r[,7]

foo <- strsplit(bio_process, split = ';')
bar <- unlist(foo)

df <- data.frame(bar)%>%
	separate(bar, into = c("Description", "GO_ID"), sep = " \\[|\\]", extra = "drop", fill = "right")

#thanks to ChadGPT, we were able to quickly get something useful:

parse_cell <- function(id, index, data){
	r <- data[id,] #extracting row based on user selection
	info <- r[,index] #selecting out desired information
	semi_parsed <- unlist(strsplit(info, split = ';')) #preprocessing the informaiton
	df <- data.frame(semi_parsed)%>% #formatting
		tidyr::separate(semi_parsed, into = c("Description", "GO_ID"), sep = "\\[|\\]", extra = "drop", fill = "right")
	df
}

#lists can be used to combine all three dataframe outputs into a single entity

bio_process <- parse_cell(2, 5, data)
cell_comp <- parse_cell(2, 6, data)
mol_func <- parse_cell(2, 7, data)

dummy <- list(bio_process, cell_comp, mol_func)

#we need a wrapper for this

cell_parser_wrapper <- function(id, data){
	bio_process <- parse_cell(id, 5, data)
	cell_comp <- parse_cell(id, 6, data)
	mol_func <- parse_cell(id, 7, data)
	go_list <- list(bio_process, cell_comp, mol_func)
	go_list
}

#to handle the radio buttions, we will implement a fetch function for simplicity
fetch_go_info <- function(go_list, field){
	if(field == "biological process"){ #default
		output <- go_list[[1]]
	}
	if(field == "cellular compartment"){
		output <- go_list[[2]]
	}
	if(field == "molecular function"){
		output <- go_list[[3]]
	}
	output
}



