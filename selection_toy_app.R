library(shiny)

source('./functions/check_highest_biofluid.R')
source('./functions/check_secondary_biofluid.R')

source('./functions/filter_highest_biofluid.R')
source('./functions/filter_secondary_biofluid.R')

source('./functions/find_column_index.R')

choices_1 <- c("all", "urine", "serum", "plasma")
choices_2 <- c("none", "urine", "serum", "plasma")

ui <- fluidPage(
  selectInput("c1", "Filter by highest biofluid", choices_1),
  selectInput("c2", "Filter by second highest biofluid", choices_2),
  actionButton("execute", "Apply Filters", icon = icon("cat")),
  dataTableOutput("dt")
)

server <- function(input, output, session){
  
  foreground <- load_foreground_data()
  
  main <- reactiveValues()
  
  observeEvent(input$c1,{
    main$first_choice <- input$c1
    #this keeps the display up automatically
    main$data <- foreground
  })
  
  observeEvent(input$c2, {
    main$second_choice <- input$c2
    print(main$second_choice)
  })
  
  observeEvent(input$execute,{
    #if 'all' is selected, we reset the data table
    if(main$first_choice == "all"){
      main$data <- foreground
    }
    #if 'all' is not selected, we do a thing
    else if(main$first_choice != "all"){
      #get the index
      i <- find_column_index(main$first_choice)
      #filter the table
      main$data <- filter_highest_biofluid(foreground, i)
      #filter again if we have a second choice
      if(main$second_choice != "none"){
        j <- find_column_index(main$second_choice)
        main$data <- filter_secondary_biofluid(main$data, j)
      }
    }
  })
  
  output$dt <- renderDataTable(main$data)
}

shinyApp(ui, server)