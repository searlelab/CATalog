setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog_test_build")

library(tidyverse)

data <- read.csv("./data/background.csv")

#this part of the code dynamically generates the foreground dataframe; however, it is a bit slow
#making an empty dataframe for the new foreground data
mat = matrix(ncol = 6, nrow = 0)
df = data.frame(mat)

names <- c("Entry", "Protein", "Gene", "Urine", "Plasma", "Serum")

colnames(df) <- names

#iterating over the background data to generate the foreground dataset
for(row in 1:nrow(data)){
	r <- data[row,]
	Urine <- round(mean(as.numeric(as.vector(r%>%select(4:11)))), 1)
	Plasma <- round(mean(as.numeric(as.vector(r%>%select(12:19)))), 1)
	Serum <- round(mean(as.numeric(as.vector(r%>%select(20:27)))), 1)
	Entry <- r$Entry
	Protein <- r$Protein
	Gene <- r$Gene
	row_to_add <- data.frame(Gene, Protein, Entry, Urine, Plasma, Serum)
	df <- rbind(df, row_to_add)
}

#to filter based on demographic information, we first need to get the letter codes that correspond with cats within the user selection
d <- read.csv("./data/demographics.csv")

#when applying the filter, we first extract the row based on what the user input is
r <- d%>%
	filter(Cat == "Age")

#then we then need to extract the column names based on the selected value. For this example, we will target cats whose ages are less than 8 years old
#this is a bit of a process

r <- data.frame(t(r[-1]))
r[,1] <- as.numeric(r[,1])
n = row.names(r %>% filter(r[,1] <= 8))

#'n' are the letters of cats matching our criteria
#we can apply this constraint to our actual data
#first, we copy and remove the first three columns to avoid confusion
metadata <- data%>%select(1:3)
data <- data[,-1:-3] #removing the non-counts data

#now we can apply the filter
pattern <- paste(n, collapse = "|")
filtered_data <- data[,grepl(pattern, names(data))]
data <- cbind(metadata, filtered_data)

#now we need to redo the code that makes the foreground data, this is best put into a function
generate_foreground <- function(data){
	#making an empty dataframe
	mat = matrix(ncol = 6, nrow = 0)
	df = data.frame(mat)
	names = c("Entry", "Protein", "Gene", "Urine", "Plasma", "Serum")
	colnames(df) <- names

       	
	for(row in 1:nrow(data)){
		r <- data[row,]
		s <- r[,-1:-3] #removing the first three columns
		Urine <- round(mean(as.numeric(as.vector(s[,grepl('U', names(s))]))), 1)
		Plasma <- round(mean(as.numeric(as.vector(s[,grepl('P', names(s))]))), 1) #these are working
		Serum <- round(mean(as.numeric(as.vector(s[,grepl('S', names(s))]))), 1)
		Entry <- r$Entry
		Protein <- r$Protein
		Gene <- r$Gene
		row_to_add <- data.frame(Gene, Protein, Entry, Urine, Plasma, Serum)
		df <- rbind(df, row_to_add)
	}
	df
}

#now we'll make a background filter function
filter_background <- function(data, demographics, target, max_value){
	r <- demographics%>%
		filter(Cat == target)

	r <- data.frame(t(r[,1]))
	r[,1] <- as.numeric(r[,1])
	n <- row.names(r %>% filter(r[,1] <= max_value))

	metadata <- data%>%select(1:3)
	data <- data[,-1:-3]

	pattern <- paste(n, collapse = "|")
	filtered_Data <- data[,grepl(pattern, names(data))]
	data <- cbind(metadata, filtered_data)

	data
}

#the next step is to dynamically generate the delta frame based on the foreground frame
#in fact, we don't need to use a delta datframe, we can simply apply an internal filtering mechanism to modify the foreground data
map_target_to_index <- function(target){
	if(target == "Urine"){
		index = 4
	}
	if(target == "Plasma"){
		index = 5
	}
	if(target == "Serum"){
		index = 6
	}
	index
}


filter_foreground <- function(data, target){
	#mapping the target to an index
	index <- map_target_to_index(target)
	#generate an empty foreground dataframe
	mat = matrix(ncol = 6, nrow = 0)
	df = data.frame(mat)
	names = c("Entry", "Protein", "Gene", "Urine", "Plasma", "Serum")
	colnames(df) <- names

	#iterate over the dataframe and do some calculations on a row-by-row basis
	for(row in 1:nrow(data)){
		r <- data[row,]
		max_value <- max(as.numeric(as.vector(r[,4:6])))
		target_value <- r[,index]
		delta <- abs(max_value - target_value)
		if(delta >= 1){
			df <- rbind(df, r)
		}
	}
	df
}



	





