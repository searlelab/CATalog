library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)

source('./functions/boxplot_wrapper.R')
source('./functions/check_highest_biofluid.R')
source('./functions/check_secondary_biofluid.R')
source('./functions/filter_foreground.R')
source('./functions/filter_highest_biofluid.R')
source('./functions/filter_secondary_biofluid.R')
source('./functions/find_column_index.R')
source('./functions/find_protein_status.R')
source('./functions/format_data.R')
source('./functions/load_background_data.R')
source('./functions/load_foreground_data.R')
source('./functions/make_boxplot.R')

choices_1 <- c("all", "urine", "serum", "plasma")
choices_2 <- c("none", "urine", "serum", "plasma")

ui <- dashboardPage(
    dashboardHeader(title = "CATalog"),
    dashboardSidebar(
      radioButtons("status", "Review Status:",
                   c("unreviewed", "reviewed", "all"),
                   selected = "all"),
      selectInput("c1", "Filter by highest biofluid", choices_1),
      selectInput("c2", "Filter by second highest biofluid", choices_2),
      actionButton("execute", "Apply Filters", icon = icon("cat"))
      
      
    ),
      dashboardBody(
        fluidRow(
          box(DT::dataTableOutput("display"), 
              style = "height:500px; overflow-y: scroll; overflow-x: scroll;"),
          box(plotOutput("boxplot", height = 500))
        )
  )
)

server <- function(input, output, session){
  
  
  background <- load_background_data()
  
  main <- reactiveValues()
  
  foreground <- reactive({
    load_foreground_data()
  })
  
  observeEvent(foreground(),{
    main$data <- foreground()
  })
  
  observeEvent(input$status,{
    main$proteins <- find_protein_status(background, option = input$status)
    main$data <- filter_foreground(main$data, main$proteins)
  })
  
  #data <- reactive(input$status,{
    #filter_foreground(foreground, main$proteins)
  #})
  
  
  observeEvent(input$c1,{
    main$first_choice <- input$c1
  })
  
  observeEvent(input$c2, {
    main$second_choice <- input$c2
  })
  
  
  observeEvent(input$execute,{
    #if 'all' is selected, we reset the data table
    if(main$first_choice == "all"){
      main$data <- foreground()
      print(nrow(main$data))
    }
    #if 'all' is not selected, we do a thing
    else if(main$first_choice != "all"){
      #get the index
      i <- find_column_index(main$first_choice)
      #filter the table
      main$data <- filter_highest_biofluid(foreground(), i)
      #filter again if we have a second choice
      if(main$second_choice != "none"){
        j <- find_column_index(main$second_choice)
        main$data <- filter_secondary_biofluid(main$data, j)
      }
    }
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