library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)

source('./functions/boxplot_wrapper.R')
source('./functions/filter_foreground.R')
source('./functions/find_protein_status.R')
source('./functions/format_data.R')
source('./functions/load_background_data.R')
source('./functions/load_foreground_data.R')
source('./functions/make_boxplot.R')

ui <- dashboardPage(
    dashboardHeader(title = "CATalog"),
    dashboardSidebar(
      radioButtons("status", "Review Status:",
                   c("unreviewed", "reviewed", "all"),
                   selected = "all")
    ),
      dashboardBody(
        fluidRow(
          box(DT::dataTableOutput("display")),
          box(plotOutput("boxplot", height = 500))
        )
  )
)

server <- function(input, output, session){
  
  #data <- reactive({
    #load_foreground_data()
  #})
  
  background <- load_background_data()
  foreground <- load_foreground_data()
  
  main <- reactiveValues()
  
  observeEvent(input$status,{
    main$proteins <- find_protein_status(background, option = input$status)
    main$data <- filter_foreground(foreground, main$proteins)
  })
  
  #data <- reactive(input$status,{
    #filter_foreground(foreground, main$proteins)
  #})
  
  output$display <- DT::renderDataTable({
    datatable(main$data, selection = 'single', options = list(scrollX = T))
  })
  
  output$boxplot <- renderPlot({
    s = input$display_rows_selected
    plot <- boxplot_wrapper(data = background, i = s)
    plot
  })
  
}

shinyApp(ui, server)