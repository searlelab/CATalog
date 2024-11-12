library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)

#static datasets
go_data <- read.csv("./data/go_data.csv")
deltas <- read.csv("./data/deltas.csv")
background <- read.csv("./data/background.csv")
demographics <- read.csv("./data/demographics.csv")


source('./functions/load_foreground_data.R')
source('./functions/map_entry_to_index.R')

#plotting functions
source('./functions/plotting/plot_driver.R')
source('./functions/plotting/format_boxplot_data.R')
source('./functions/plotting/make_boxplot_annotated.R')
source('./functions/plotting/make_boxplot_unannotated.R')
source('./functions/plotting/annotated_frame_generator.R')
source('./functions/plotting/annotate_row.R')
source('./functions/plotting/make_age_scatterplot.R')
source('./functions/plotting/make_bcs_scatterplot.R')
source('./functions/plotting/set_plot.R')

#gene ontology functions
source('./functions/gene_ontology/go_processor.R')
source('./functions/gene_ontology/parse_cell.R')
source('./functions/gene_ontology/set_ontology.R')
source('./functions/gene_ontology/spoof_dataframe.R')

#search-reated functions
source('./functions/search/search_for_go_keyword.R')
source('./functions/search/go_column_mapper.R')

#filtering functions
source('./functions/filters/filter_by_highest_biofluid.R')

#unstable test functions
source('./functions/test/filter_background.R')
source('./functions/test/filter_foreground.R')
source('./functions/test/generate_foreground.R')
source('./functions/test/map_target_to_index.R')



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
                                   selected = "biological process"),
                      radioButtons("plot_display", "Display Plot: ",
                                   c("Global Boxplot", "By Age", "By BCS"),
                                   selected = "Global Boxplot"),
                      sliderInput("filter_by_age", "Maximum age: ", value = 11, min = 1, max = 100),
                      sliderInput("filter_by_BCS", "Maximum BCS: ", value = 10, min = 1, max = 10),
                      actionButton("reset_background", "Reset Database")
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
                               box(width = NULL, plotOutput("show_plot", height = 300, width = 250)),
                               box(width = NULL, div(tableOutput("demo"), style = "font-size:70%; overflow-y: scroll"),
                                   style = "height: 100px")
                        )
                      )
                    )
)

server <- function(input, output, session){
  Database <- reactiveValues()
  Search <- reactiveValues() #search-related features
  Params <- reactiveValues() #user settings
  Plot <- reactiveValues() #holds plot information
  Global <- reactiveValues() #elements that are not related to the core database but need to be accessed by disprate functions
  
  Database$go_list = NULL
  
  #new protocol for handling the data
  data <- reactive({
    read.csv("./data/protein_database.csv")
  })
  
  observeEvent(data(),{
    Database$backround <- data()
    Database$foreground <- generate_foreground(Database$background)
    Database$foreground_cache <- Database$foreground
    
  })
  
  #setting up the search parameters
  Search$cache <- NULL
  Search$is_ongoing <- FALSE
  
  #connected to the GO field buttons
  #the seemingly redundant code here is used to switch between GO categories for a given protein when clicking other buttons
  observeEvent(input$go_item,{
    Params$go_field <- input$go_item
    Database$ontology <- set_ontology(go_list = Global$all_ontologies, field = Params$go_field)
  })
  
  #switches between what plot is currently shown
  observeEvent(input$plot_display,{
    Params$selected_plot <- input$plot_display
    Plot$current_plot <- set_plot(Plot$plots, plot_type = Params$selected_plot)
  })
  
  #observers for filtering the background data
  observeEvent(input$filter_by_age,{
    Database$background <- data() #reset the background
    Database$background <- filter_background(Database$background, demographics,
                                             target = "Age", max_value = input$filter_by_age)
  })
  
  observeEvent(input$filter_by_bcs,{
    Database$background <- data() #reset the background
    Database$background <- filter_background(Database$background, demographics,
                                             target = "BCS", max_value = input$filter_by_bcs)
  })
  
  
  
  #triggers when clicking on a row of the main display
  observeEvent(input$display_rows_selected,{
    Database$current_entry <- map_entry_to_index(Database$foreground, index = input$display_rows_selected)
    Global$all_ontologies <- go_processor(entry = Database$current_entry, go_data)
    Database$ontology <- set_ontology(go_list = Global$all_ontologies, field = Params$go_field)
    Plot$plots <- plot_driver(data = Database$background, entry = Database$current_entry, flag = Params$is_annotated,  demographics)
    Plot$current_plot <- set_plot(plots = Plot$plots, plot_type = Params$selected_plot)
  })
  
  output$display <- DT::renderDataTable({
    datatable(Database$foreground, selection = 'single')
  })
  
  #GO result display
  output$results <- DT::renderDataTable({
    req(input$display_rows_selected)
    Database$ontology
  })
  
  #triggers when pushing the search button
  observeEvent(input$searchButton,{
    Database$dataset <- Database$foreground_cache #reset the foreground data
    index <- go_column_mapper(input$go_item) #need to figure out how to circumvent this function
    search_results <- search_for_go_keyword(go_data, Database$foreground, go_field = index, keyword = input$keyword)
    Database$foreground <- search_results #set the search results
    Search$cache <- search_results #set the cache for the filtering process
    Search$is_ongoing <- TRUE #state that we are currently searching
  })
  
  #the search button is fundementally linked to the reset button
  observeEvent(input$resetButton,{
    Database$foreground <- Database$foreground_cache
    updateTextInput(session,"keyword", value="")
    Search$is_ongoing <- FALSE
  })
  
  #code for the sample selector; determines what to filter by
  observeEvent(input$sampleType,{
    Params$target_sample <- input$sampleType
  })
  
  
  #code for the filtering process
  observeEvent(input$filterButton,{
    if(Params$target_sample == "all" & Search$is_ongoing == FALSE){ 
      Database$foreground <- Database$foreground_cache #reset to the entire dataset
    }
    else if(Params$target_sample == "all" & Search$is_ongoing == TRUE){
      Database$foreground <- Search$cache #reset to the cached search data
    }
    
    else if(Params$target_sample != "all" & Search$is_ongoing == TRUE){
      Database$foreground <- filter_foreground(Search$cache, target = Params$target_sample)
    }
    else{
      Database$foreground <- Database$foreground_cache
      Database$foreground <- filter_foreground(Database$dataset, target = Params$target_sample)
    }
  })
  
  #observer for the plot annotation
  observeEvent(input$plot_labels,{
    Params$is_annotated <- input$plot_labels
    if(Params$is_annotated == "off"){
      Params$demographics <- NULL
    }
    if(Params$is_annotated == "on"){
      Params$demographics <- demographics
    }
  })
  
  output$demo <- renderTable({
    Params$demographics
  })
  
  #output for the plot
  output$show_plot <- renderPlot({
    req(input$display_rows_selected)
    Plot$current_plot
  })
  
  
 
  
}

shinyApp(ui, server)
