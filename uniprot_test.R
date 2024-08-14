setwd("C:\\Users\\alexw\\Documents\\R Shiny Projects\\CATalog")

library(UniProt.ws)

test <- "A0A5F5XCT0_FELCA" #first UniProtKB acession number in the table

foo <- queryUniProt(test)

bar <- mapUniProt(
		  from = "UniProtKB_AC-ID", to = "UniProtKB",
		  query = test,
		  columns = c("accession", "id", "xref_pdb")
		  )

#here is what we have so far:
#mapping to Ensembl id

#creating a UniProt.ws object for the cat
up <- UniProt.ws(9685)

#we need to select some data types that we want to retrieve by default
#using UniProtKB as the key
#we want:
	#acession
	#gene_names
	#protein_name
	#protein_existance
	#annotation score
	#go
	#go id
	#organelle

bar <- c("accession", "gene_names", "protein_name", "protein_existence", "annotation_score", "go", "go_id", "organelle")               
res <- select(x = up, keys = test, columns = bar, keytype = "UniProtKB") #this is a dataframe

#there are two ways to implement this in the app:
	#real time searching
	#having an up-front database

#let's try to setup a database for the second method
data <- read.csv("background.csv")
entries <- data$Entry

#creating an empty dataframe with our search categories
mat <- matrix(ncol = 9, nrow = 0)
df <- data.frame(mat)

names <- colnames(res)
colnames(df) <- names

#looping over the acession numbers
for(entry in entries){
	print(entry)
	res <- select(x = up, keys = entry, columns = bar, keytype = "UniProtKB")
	df <- rbind(df, res)
	print(nrow(df))
} #this is going to take a while; we should run this in the background while doing other things


	
