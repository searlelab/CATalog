library(shiny)
library(DT)
library(ggplot2)

source('./functions/boxplot_wrapper.R')
source('./functions/format_data.R')
source('./functions/load_background_data.R')
source('./functions/load_foreground_data.R')
source('./functions/make_boxplot.R')

ui <- fluidPage(
  titlePanel("CATalog"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      fluidRow(
        column(6, DT::dataTableOutput("display")),
        #column(6, verbatimTextOutput("debug"))
        column(6, plotOutput("boxplot", height = 500))
      )
    )
  )
)

server <- function(input, output, session){
  
  data <- reactive({
    load_foreground_data()
  })
  
  #background <- reactive({
    #load_background_data()
  #})
  
  background <- load_background_data()
  
  output$display <- DT::renderDataTable(selection = 'single',{
    data()
  })
  #output$debug <- renderPrint({
    #s = input$display_rows_selected
    #if(length(s)){
      #row <- data()[s,]
      #p <- row[,2]
      #print(p)
    #}
  #})
  
  output$boxplot <- renderPlot({
    s = input$display_rows_selected
    plot <- boxplot_wrapper(data = background, i = s)
    plot
  })
  
}

shinyApp(ui, server)