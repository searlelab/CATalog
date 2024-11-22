source('setup.R')

ui <- dashboardPage(skin = "black",
                    dashboardHeader(title = tags$img(src='https://i.ibb.co/x6tH34j/logo4.png', height = '60', width = '120')),
                    dashboardSidebar(
                      textInput("keyword", "Filter proteins by GO: ", value = ""),
                      actionButton("search_button", "Search"),
                      actionButton("reset_button", "reset"),
                      selectInput("sample_type", "Filter by highest biofluid:",
                                  choices = c("all", "urine", "serum", "plasma")),
                      numericInput("age_filter", "Maximum Age", value = 11),
                      numericInput("bsc_filter", "Maximum BSC", value = 10),
                      actionButton("filter_button", "Filter"),
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
  
  data <- reactive({
    read.csv("./data/protein_database.csv")
  })
  
  observeEvent(data(),{
    Database$background <- data()
    Database$background_cache <- data()
    Database$foreground <- generate_foreground(Database$background)
    Database$foreground_cache <- Database$foreground
  })
  
  #setting up the search parameters
  Search$cache <- NULL
  Search$is_ongoing <- FALSE
  
  observeEvent(input$go_item,{
    Database$ontology <- set_ontology(go_list = Global$all_ontologies, field = input$go_item)
  })
    
  row_click_handler(input, trigger = "display_rows_selected", Database, Global, Plot, go_data)
  
  #GO result display
  output$results <- DT::renderDataTable({
    req(input$display_rows_selected)
    Database$ontology
  })
  
  search_handler(input, trigger = "search_button", Database, Search)
  
  reset_handler(input, session, trigger = "reset_button", Database, Search)
  
  
  filter_handler(input, trigger = "filter_button", Database, Search, demographics)
  
  output$display <- DT::renderDataTable({
    datatable(Database$foreground, selection = 'single')
  })
  
  annotation_toggle(input, trigger = "plot_labels", Plot)
  
  output$demo <- renderTable({
    Plot$demographics
  })
  
  #output for the plot
  output$show_plot <- renderPlot({
    #req(input$display_rows_selected)
    Plot$boxplot
  })
  
}

shinyApp(ui, server)
