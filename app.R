library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)

source('./functions/boxplot_wrapper.R')
source('./functions/format_data.R')
source('./functions/load_background_data.R')
source('./functions/load_foreground_data.R')
source('./functions/make_boxplot.R')

ui <- dashboardPage(
    dashboardHeader(title = "CATalog"),
    dashboardSidebar(),
      dashboardBody(
        fluidRow(
          box(6, DT::dataTableOutput("display")),
          box(6, plotOutput("boxplot", height = 500))
        )
  )
)

server <- function(input, output, session){
  
  data <- reactive({
    load_foreground_data()
  })
  
  background <- load_background_data()
  
  output$display <- DT::renderDataTable({
    datatable(data(), selection = 'single', options = list(scrollX = T))
  })
  
  output$boxplot <- renderPlot({
    s = input$display_rows_selected
    plot <- boxplot_wrapper(data = background, i = s)
    plot
  })
  
}

shinyApp(ui, server)