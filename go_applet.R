library(shiny)
library(DT)
library(shinydashboard)
library(tidyverse)

GO_data <- read.csv("go_data.csv")

source("./functions/cell_parser_wrapper.R")
source("./functions/fetch_go_info.R")
source("./functions/load_foreground_data.R")
source("./functions/parse_cell.R")




ui <- dashboardPage(
		    dashboardHeader(title = "GO Applet"),
		    dashboardSidebar(
				     radioButtons("go_item", "GO Data: ",
						  c("biological process",
						    "cellular compartment",
						    "molecular function"),
				     selected = "biological process")
				     ),
		    dashboardBody(
				  fluidRow(
					   box(DT::dataTableOutput("display"),
					       style = "height:500px; overflow-y: scroll; overflow-x: scroll;")
					   ),
				  fluidRow(
					   box(DT::dataTableOutput("info"),
					       style = "height: 200px; overflow-y: scroll; overflow-x: scroll;")
					   )
				  )
		    )




server <- function(input, output, session){

	main <- reactiveValues()
  
  	foreground <- reactive({
    		load_foreground_data()
  	})
  
  	observeEvent(foreground(),{
    		main$data <- foreground()
  	})

	#we had the original radio buttions tied to an observer; instead of filtering main$data, we will toggle
	#main$go, which is what will be displayed

	#might need to use an eventReactive here

	#for refrence https://stackoverflow.com/questions/71212121/r-shiny-click-on-table-field

	#this makes a list of dataframes and stores them somewhere
	#triggers when the user clicks a row
	observeEvent(input$display_rows_selected,{
		id <- input$display_rows_selected
		go_list <- cell_parser_wrapper(id, GO_data)
		#we can set the specific ontologies for that protein to our reactive container
		print("remade go list")
		main$go_element <- fetch_go_info(go_list, field = input$go_item)
	})

	#now to wire the radio buttons
	#triggers when the user changes a radio button
	#also triggers on app loading with default of biological process
	#observeEvent(input$go_item,{
		#req(input$display_rows_selected)
	  #print("witty comment")
		#main$go_element_specific <- fetch_go_info(main$go_list_specific,
							  #field = input$go_item)
		#print(nrow(main$go_element_specific))
	#})
	
	#it appears that we need to have a default

	#nothing to change for the main display
	output$display <- DT::renderDataTable({
		datatable(main$data, selection = 'single')
	})

	#a bit different for the GO mappings
	output$info <- DT::renderDataTable({
		datatable(main$go_element)
	})



  
	
}

shinyApp(ui, server)

