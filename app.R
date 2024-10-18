library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)

source('./functions/boxplot_wrapper.R')
source('./functions/cell_parser_wrapper.R')
source('./functions/fetch_go_info.R')
source('./functions/filter_foreground.R')
source('./functions/format_data.R')
source('./functions/go_chunk.R')
source('./functions/go_column_mapper.R')
source('./functions/go_protein_mapper.R')
source('./functions/load_background_data.R')
source('./functions/load_foreground_data.R')
source('./functions/make_boxplot_annotated.R')
source('./functions/make_boxplot_unannotated.R')
source('./functions/parse_cell.R')
source('./functions/search_go_data_background.R')
source('./functions/search_go_data_foreground.R')
source('./functions/spoof_dataframe.R')
source('./functions/update_background.R')

GO_data <- read.csv("./data/go_data.csv")
deltas <- read.csv("./data/deltas.csv")

ui <- dashboardPage(skin = "black",
    dashboardHeader(title = tags$img(src='https://i.ibb.co/x6tH34j/logo4.png', height = '60', width = '120')),
    dashboardSidebar(
        textInput("keyword", "Filter proteins by GO: ", value = ""),
        actionButton("searchButton", "Search"),
        actionButton("resetButton", "reset"),
        selectInput("sampleType", "Filter by highest biofluid:",
                    choice = c("all", "urine", "serum", "plasma")),
        actionButton("filterButton", "Filter"),
        radioButtons("plot_labels", "Sample annotation: ",
                     c("off", "on")),
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
            box(width = NULL, div(tableOutput("demo"), style = "font-size:70%; overflow-y: scroll"),
              style = "height: 100px")
          )
        )
    )
)


server <- function(input, output, session){
  
  demographics <- read.csv("./data/demographics.csv")
  
  main <- reactiveValues()
  search <- reactiveValues()

  main$go_list = NULL
  
  foreground <- reactive({
    load_foreground_data()
  })
  
  observeEvent(foreground(),{
    main$data <- foreground()
  })

  background <- reactive({
    load_background_data()
  })
  
  observeEvent(background(),{
    main$back_data <- background()
  })
  
  main$search_cache_foreground <- NULL
  main$search_cache_background <- NULL
  search$ongoing <- FALSE

  observeEvent(input$display_rows_selected,{
    main$row_selected <- input$display_rows_selected
    go_list <- go_chunk(data = main$data,
                        row_id = input$display_rows_selected,
                        GO_data
    )
    main$go_list <- go_list
    main$go_element <- fetch_go_info(go_list, field = input$go_item)
  })
  
  observeEvent(input$go_item,{
    main$go_element <- fetch_go_info(go_list = main$go_list, field = input$go_item)
  })
  
  observeEvent(input$searchButton,{
    main$data <- foreground()
    main$back_data <- background()
    index <- go_column_mapper(input$go_item)
    res <- search_go_data_foreground(GO_data, main$data, index, word = input$keyword)
    main$data <- res
    res_background <- search_go_data_background(GO_data, main$back_data, index, word = input$keyword)
    main$back_data <- res_background
    main$search_cache_foreground <- res
    main$search_cache_background <- res_background
    print(nrow(main$search_cache))
    search$ongoing <- TRUE
    print(search$ongoing)
  })
  
  observeEvent(input$resetButton,{
    main$data <- foreground()
    main$back_data <- background()
    updateTextInput(session,"keyword", value="")
    search$ongoing <- FALSE
    #print(search$ongoing)
  })
  
  observeEvent(input$sampleType,{
    main$sample_selection <- input$sampleType
    #print(main$sample_selection)
  })
  

  observeEvent(input$filterButton,{

    
    if(main$sample_selection == "all" & search$ongoing == FALSE){ 
      main$data <- foreground() 
      main$back_data <- background()
    }
    else if(main$sample_selection == "all" & search$ongoing == TRUE){
      main$data <- main$search_cache_foreground
      main$back_data <- main$search_cache_background
    }
 
    else if(main$sample_selection != "all" & search$ongoing == TRUE){
      output <- filter_foreground(main$search_cache_foreground, deltas, field = main$sample_selection)
      background_output <- update_background(output, main$search_cache_background)
      main$data <- output
      main$back_data <- background_output
    }
    else{
      main$data <- foreground()
      main$back_data <- background()
      output <- filter_foreground(main$data, deltas, field = main$sample_selection)
      background_output <- update_background(output, main$back_data)
      main$data <- output
      main$back_data <- background_output
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
    plot <- boxplot_wrapper(data = main$back_data, i = s, flag = main$plot_annotation)
    plot
  })
  
}

shinyApp(ui, server)