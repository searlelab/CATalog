library(shiny)

source('./test_function.R')

ui <- fluidPage(
  #fileInput("upload", NULL, accept = c(".csv")),
  #numericInput("n", "Rows", value = 5, min = 1, step = 1),
  tableOutput("head")
  
)

server <- function(input, output, session){
  
  data <- reactive({
    #req(input$upload)
    #csv = vroom::vroom(input$upload$datapath, delim = ",")
    test_function()
  })
  output$head <- renderTable({
  head(data())
  })
  
}

shinyApp(ui, server)