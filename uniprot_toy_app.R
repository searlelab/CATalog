library(shiny)
library(DT)
library(shinydashboard)
library(UniProt.ws)

source('./functions/get_entry_mapping.R')
source('./functions/load_foreground_data.R')
source('./functions/query.R')
source('./functions/transform_data.R')

#setting up system things on launch
fields <- c("accession", "gene_names", "protein_name", "protein_existence", "annotation_score", "go", "go_id", "organelle")
up <- UniProt.ws(9685)

ui <- dashboardPage(
		    dashboardHeader(title = "UniProt Test"),
		    dashboardSidebar(
		    ),
		    dashboardBody(
				  fluidRow(
					   box(DT::dataTableOutput("results"),
					       style = "height: 200px; overflow-y: scroll; overflow-x: scroll;"),
				  fluidRow(
					   box(DT::dataTableOutput("display"),
					       style = "height: 500px; overflow-y: scroll; overflow-x: scroll;")
					   )
				  )
		    )
)

server <- function(input, output, session){
	data <- load_foreground_data()

	output$results <- DT::renderDataTable({
		index <- input$display_rows_selected
		entry <- get_entry_mapping(data, index)
		res <- query(up, entry, fields)
		res_formatted <- transform_data(res)
		datatable(res_formatted)
	})

	output$display <- DT::renderDataTable({
    		datatable(data, selection = 'single')
  	})
}
  
shinyApp(ui, server)



