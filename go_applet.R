library(shiny)
library(DT)
library(shinydashboard)
library(tidyverse)

GO_data <- read.csv("go_data.csv")

source("./functions/cell_parser_wrapper.R")
source("./functions/create_pattern.R")
source("./functions/fetch_go_info.R")
source("./functions/go_column_mapper.R")
source("./functions/load_foreground_data.R")
source("./functions/parse_cell.R")
source("./functions/search_go_data.R")




ui <- dashboardPage(
		    dashboardHeader(title = "GO Applet"),
		    dashboardSidebar(
				     radioButtons("go_item", "GO Data: ",
						  c("biological process",
						    "cellular compartment",
						    "molecular function"),
				     		  selected = "biological process"),
		    		     textInput("keyword", "Filter proteins by GO: ", value = ""),
				     actionButton("searchButton", "Search"),
				     actionButton("reset", "Reset table")
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

	#logic for the search event
	observeEvent(input$searchButton,{
	          index <- go_column_mapper(input$go_item)
			     res <- search_go_data(GO_data, main$data, index, word = input$keyword)
			     main$data <- res
	})
	
	#A reset button until I implement a better solution
	observeEvent(input$reset,{
	  main$data <- foreground()
	})


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

