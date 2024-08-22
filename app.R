library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)
library(UniProt.ws)
library(recolorize)

source('./functions/boxplot_wrapper.R')
source('./functions/check_highest_biofluid.R')
source('./functions/check_secondary_biofluid.R')
source('./functions/filter_foreground.R')
source('./functions/filter_highest_biofluid.R')
source('./functions/filter_secondary_biofluid.R')
source('./functions/find_column_index.R')
source('./functions/find_protein_status.R')
source('./functions/format_data.R')
source('./functions/get_entry_mapping.R')
source('./functions/load_background_data.R')
source('./functions/load_foreground_data.R')
source('./functions/make_boxplot.R')
source('./functions/query.R')
source('./functions/transform_data.R')

choices_1 <- c("all", "urine", "serum", "plasma")
choices_2 <- c("none", "urine", "serum", "plasma")

fields <- c("accession", "gene_names", "protein_name", "protein_existence", "annotation_score", "go", "go_id", "organelle")
up <- UniProt.ws(9685)

img <- readImage('logo.png')

ui <- dashboardPage(
    dashboardHeader(title = "CATalog"),
    dashboardSidebar(
      
      radioButtons("status", "Review Status:",
                   c("unreviewed", "reviewed", "all"),
                   selected = "all"),
      selectInput("c1", "Filter by highest biofluid", choices_1),
      selectInput("c2", "Filter by second highest biofluid", choices_2),
      actionButton("execute", "Apply Filters", icon = icon("cat")),
      imageOutput("catalog_logo")
      
      
    ),
      dashboardBody(
        fluidRow(
          box(DT::dataTableOutput("results"),
              style = "height: 200px; overflow-y: scroll; overflow-x: scroll;"),
          box(DT::dataTableOutput("demo"),
              style = "height: 200px; overflow-y: scroll; overflow-x: scroll;")
        ),
        fluidRow(
          box(DT::dataTableOutput("display"), 
              style = "height:500px; overflow-y: scroll; overflow-x: scroll;"),
          box(plotOutput("boxplot", height = 500))
        )
  )
)

server <- function(input, output, session){
  
  
  background <- load_background_data()
  
  demographics <- read.csv("demographics.csv")
  
  main <- reactiveValues()
  
  foreground <- reactive({
    load_foreground_data()
  })
  
  observeEvent(foreground(),{
    main$data <- foreground()
    print(class(main$data))
  })
  
  observeEvent(input$status,{
    main$proteins <- find_protein_status(background, option = input$status)
    main$data <- filter_foreground(main$data, main$proteins)
  })
  
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
  
  output$catalog_logo <- renderImage({
    list(
      src = file.path("logo.png"),
      contentType = "image/png",
      width = 150,
      height = 150
    )
  }, deleteFile = FALSE)
  
  output$results <- DT::renderDataTable({
    index <- input$display_rows_selected
    print("alpha")
    req(index)
    entry <- get_entry_mapping(main$data, index)
    print("beta")
    res <- query(up, entry, fields)
    print("gamma")
    res_formatted <- transform_data(res)
    print("delta")
    datatable(res_formatted)
  })
  
  output$demo <- DT::renderDataTable({
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