library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)

source('./functions/boxplot_wrapper.R')
source('./functions/cell_parser_wrapper.R')
source('./functions/create_pattern.R')
source('./functions/fetch_go_info.R')
source('./functions/filter_foreground.R')
source('./functions/format_data.R')
source('./functions/go_chunk.R')
source('./functions/go_column_mapper.R')
source('./functions/go_protein_mapper.R')
source('./functions/load_background_data.R')
source('./functions/load_foreground_data.R')
source('./functions/make_boxplot.R')
source('./functions/make_boxplot_unannotated.R')
source('./functions/parse_cell.R')
source('./functions/search_go_data.R')

GO_data <- read.csv("go_data.csv")
deltas <- read.csv("deltas.csv")

ui <- dashboardPage(skin = "black",
    dashboardHeader(title = tags$img(src='https://i.ibb.co/x6tH34j/logo4.png', height = '60', width = '120')),
    dashboardSidebar(
        textInput("keyword", "Filter proteins by GO: ", value = ""),
        actionButton("searchButton", "Search"),
        actionButton("resetButton", "reset"),
        #new filtering protocol
        selectInput("sampleType", "Filter by highest biofluid:",
                    choice = c("all", "urine", "serum", "plasma")),
        radioButtons("plot_labels", "Sample annotation: ",
                     c("off", "on")),
        #imageOutput("catalog_logo"),
        actionButton("selectButton", "Filter"),
        radioButtons("go_item", "GO Data: ",
                     c("biological process",
                       "cellular compartment",
                       "molecular function"),
                     selected = "biological process")
    ),
      dashboardBody(
        fluidRow(
          column(width = 8,
            box(width = NULL, DT::dataTableOutput("display"), 
              style = "height:400px; overflow-y: scroll; overflow-x: scroll;"),
            box(width = NULL, DT::dataTableOutput("results"),
                style = "height: 200px; overflow-y: scroll; overflow-x: scroll;")
            ),
          column(width = 4,
            box(width = NULL, plotOutput("boxplot", height = 300, width = 250)),
            box(width = NULL, div(tableOutput("demo"), style = "font-size:70%"),
              style = "height: 100px")
          )
        )
    )
)


server <- function(input, output, session){
  
  
  background <- load_background_data()
  
  demographics <- read.csv("demographics.csv")
  
  main <- reactiveValues()
  
  #default to prevent the app from exploding 
  main$go_list = NULL
  
  #initial loading of the data
  foreground <- reactive({
    load_foreground_data()
  })
  
  observeEvent(foreground(),{
    main$data <- foreground()
  })
  
  #new observer logic
  observeEvent(input$display_rows_selected,{
    main$row_selected <- input$display_rows_selected
    go_list <- go_chunk(data = main$data,
                        row_id = input$display_rows_selected,
                        GO_data
    )
    main$go_list <- go_list
    main$go_element <- fetch_go_info(go_list, field = input$go_item)
  })
  
  #this is a response to the user chainging the go category
  observeEvent(input$go_item,{
    #main$data <- foreground() #this induces a table reset
    main$go_element <- fetch_go_info(go_list = main$go_list, field = input$go_item)
  })
  
  observeEvent(input$searchButton,{
    main$data <- foreground()
    index <- go_column_mapper(input$go_item)
    res <- search_go_data(GO_data, main$data, index, word = input$keyword)
    main$data <- res
  })
  
  observeEvent(input$resetButton,{
    main$data <- foreground()
    updateTextInput(session,"keyword", value="")
  })
  
  #observer to control the drop-down menu
  observeEvent(input$sampleType,{
    main$sample_selection <- input$sampleType
    print(main$sample_selection)
  })
  
  #observer to perform the filtration step based on the button
  observeEvent(input$selectButton,{
    if(main$sample_selection == "all"){ #reset the table based on the 'all' selection
      main$data <- foreground()
    }
    else{
      output <- filter_foreground(deltas, main$data, target = main$sample_selection)
      main$data <- output
    }
  })
  
  #observer for the plot annotation
  observeEvent(input$plot_labels,{
    main$plot_annotation <- input$plot_labels
    if(main$plot_annotation == "off"){
      main$demographics <- NULL
    }
    if(main$plot_annotation == "on"){
      main$demographics <- demographics
    }
  })
  
  
  #output$catalog_logo <- renderImage({
    #list(
      #src = file.path("logo.png"),
      #contentType = "image/png",
      #width = 150,
      #height = 150
    #)
  #}, deleteFile = FALSE)
  
  output$results <- DT::renderDataTable({
    req(input$display_rows_selected)
    main$go_element
  })
  
  output$demo <- renderTable({
    main$demographics
  })
  
  output$display <- DT::renderDataTable({
    datatable(main$data, selection = 'single')
  })
  
  output$boxplot <- renderPlot({
    req(input$display_rows_selected)
    s = input$display_rows_selected
    plot <- boxplot_wrapper(data = background, i = s, flag = main$plot_annotation)
    plot
  })
  
}

shinyApp(ui, server)