library(shiny)
library(DT)
library(shinydashboard)
library(tidyverse)

source('./functions/filter_foreground.R')

ui <- dashboardPage(
		    dashboardHeader(title = "Filter Applet"),
		    dashboardSidebar(
				     selectInput("sampleType", "Select Sample Type:",
						 choices = c("all", "urine", "serum", "plasma")),
				     actionButton("selectButton", "Filter")
				     ),
		    dashboardBody(
				  fluidRow(
					   box(width = 8, DT::dataTableOutput("display"),
					       style = "height:400px; overflow-y: scroll; overflow-x: scroll;")
					   )
				  )
		    )

server <- function(input, output, session){

	deltas <- read.csv("deltas.csv")

	main <- reactiveValues()

	foreground <- reactive({
		load_foreground_data()
	})

	#primary observer
	observeEvent(foreground(),{
			     main$data <- foreground()
	})
	
	#observer to control the drop-down menu
	observeEvent(input$sampleType,{
			     main$sample_selection <- input$sampleType
			     print(main$sample_selection)
	})

	#observer to perform the filtration step based on the button
	observeEvent(input$selectButton,{
			     if(main$sample_selection == "all"){ #reset the table based on the 'all' selection
				     main$data <- foreground()
			     }
			     else{
				     output <- filter_foreground(deltas, main$data, target = main$sample_selection)
				     main$data <- output
			     }
	})
	
	output$display <- DT::renderDataTable({
		datatable(main$data, selection = 'single')
	})
}

shinyApp(ui, server)


	
