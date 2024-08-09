setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog\\dev\\boxplots")

library(ggplot2)
library(tidyverse)

data <- read.csv("background.csv") #background dataset in the app

#need to do some data modifications

#extracting the target row

x <- data[1,]

#extracting the protein name
name <- x[,4]

#removing extra columns
x <- subset(x, select = -c(Entry, Reviewed, Entry.Name, Protein.names, Gene.Names))

#getting the values
values <- as.numeric(x)

#getting the labels
labels <- colnames(x)


#making the label vectors
urine <- replicate(9, "urine")
plasma<- replicate(9, "plasma")
serum <- replicate(9, "serum")

#assembly
group <- c(urine, plasma, serum)

df <- data.frame(values, group, labels)

#better version of the boxplot
ggplot(df, aes(x = as.factor(group), y = values, fill = group, label = labels))+
	geom_boxplot()+
	geom_jitter(color = "blue", position = position_jitter(seed = 1)) +
       	geom_text(position = position_jitter(seed = 1))+	
	xlab("sample")+
	ggtitle(name) #plot title is the protein name, read from a variable



#now we need to make this into a set of functions

make_boxplot <- function(df, name){
	plot <- ggplot(df, aes(x = as.factor(group), y = values, fill = group, label = labels))+
		geom_boxplot()+
		geom_jitter(color = "blue", position = position_jitter(seed = 1))+
		geom_text(position = position_jitter(seed = 1))+
		xlab("sample")+
		ggtitle(name)
	plot
}

format_data <- function(data, i){
	x <- data[i,]
	name <- x[,4]
	x <- subset(x, select = -c(Entry, Reviewed, Entry.Name, Protein.names, Gene.Names))
	values <- as.numeric(x)
	labels <- colnames(x)

	urine <- replicate(9, "urine")
	plasma<- replicate(9, "plasma")
	serum <- replicate(9, "serum")

	group <- c(urine, plasma, serum)

	df <- data.frame(values, group, labels)

	#trick to return multiple outputs from an R function
	output <- list(name, df)
	output
}

boxplot_wrapper <- function(data, i){
	output <- format_data(data, i)
	name <- unlist(output[1])
	print(name)
	df <- as.data.frame(output[[2]])
	print(class(df))
	plot <- make_boxplot(df, name)
	plot
}

