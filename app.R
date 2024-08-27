library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)

source('./functions/boxplot_wrapper.R')
source('./functions/cell_parser_wrapper.R')
source('./functions/create_pattern.R')
source('./functions/fetch_go_info.R')
source('./functions/go_column_mapper.R')
source('./functions/go_protein_mapper.R')
source('./functions/load_background_data.R')
source('./functions/load_foreground_data.R')
source('./functions/make_boxplot.R')
source('./functions/parse_cell.R')
source('./functions/search_go_data.R')

GO_data <- read.csv("go_data.csv")

ui <- dashboardPage(
    dashboardHeader(title = "CATalog"),
    dashboardSidebar(
      
        radioButtons("go_item", "GO Data: ",
                     c("biological process",
                       "cellular compartment",
                       "molecular function"),
                     selected = "biological process"),
        
        
        textInput("keyword", "Filter proteins by GO: ", value = ""),
        actionButton("searchButton", "Search"),
        #actionButton("reset", "Reset table"),
        imageOutput("catalog_logo")
    ),
      dashboardBody(
        fluidRow(
          box(width = 8, DT::dataTableOutput("display"), 
              style = "height:300px; overflow-y: scroll; overflow-x: scroll;"),
          box(width = 4, plotOutput("boxplot", height = 300, width = 250))
        ),
        fluidRow(
          box(DT::dataTableOutput("results"),
              style = "height: 200px; overflow-y: scroll; overflow-x: scroll;"),
          box(tableOutput("demo"),
              style = "height: 200px; overflow-y: scroll; overflow-x: scroll;")
        )
    )
)


server <- function(input, output, session){
  
  
  background <- load_background_data()
  
  demographics <- read.csv("demographics.csv")
  
  main <- reactiveValues()
  
  #initial loading of the data
  foreground <- reactive({
    load_foreground_data()
  })
  
  observeEvent(foreground(),{
    main$data <- foreground()
  })
  
  #new observer logic
  observeEvent(input$display_rows_selected,{
    #do not want to reset the table here!
    id <- input$display_rows_selected
    protein <- go_protein_mapper(main$data, i = id)
    print(protein)
    go_list <- cell_parser_wrapper(protein, GO_data)
    #we can set the specific ontologies for that protein to our reactive container
    #print("remade go list")
    main$go_element <- fetch_go_info(go_list, field = input$go_item)
  })
  
  #this is a response to the user chainging the go category
  observeEvent(input$go_item,{
    main$data <- foreground() #this induces a table reset
  })
  
  observeEvent(input$searchButton,{
    main$data <- foreground()
    index <- go_column_mapper(input$go_item)
    res <- search_go_data(GO_data, main$data, index, word = input$keyword)
    main$data <- res
  })
  
  #observeEvent(input$reset,{
    #main$data <- foreground()
  #})
  
  output$catalog_logo <- renderImage({
    list(
      src = file.path("logo.png"),
      contentType = "image/png",
      width = 150,
      height = 150
    )
  }, deleteFile = FALSE)
  
  output$results <- DT::renderDataTable({
    main$go_element
  })
  
  output$demo <- renderTable({
    demographics
  })
  
  output$display <- DT::renderDataTable({
    datatable(main$data, selection = 'single')
  })
  
  output$boxplot <- renderPlot({
    s = input$display_rows_selected
    plot <- boxplot_wrapper(data = background, i = s)
    plot
  })
  
}

shinyApp(ui, server)