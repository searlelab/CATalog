source('setup.R')

core_database <- read.csv("./data/protein_database.csv")

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(
    title = tags$img(src = 'https://i.ibb.co/x6tH34j/logo4.png', height = '60', width = '120')
  ),
  dashboardSidebar(
    useShinyjs(),
    actionButton("reset_button", "Reset"),
    sidebarMenu(
      menuItem("Search", icon = icon("search"),
               textInput("go_search_query", "Search proteins by GO term:", value = ""),
               textInput("protein_search_query", "Search protein by field", value = ""),
               radioButtons("search_field", "Search Field:",
                            choices = c("Protein name", "Gene name", "Entry")),
               actionButton("search_button", "Search")
               #actionButton("reset_button", "Reset")
      ),
      menuItem("Filters", icon = icon("filter"),
               selectInput("sample_type", "Filter by highest biofluid:",
                           choices = c("all", "urine", "serum", "plasma")),
               numericInput("age_filter", "Maximum Age", value = 11),
               numericInput("bsc_filter", "Maximum BSC", value = 8),
               actionButton("filter_button", "Apply Filters")
      ),
      menuItem("Plots", icon = icon("chart-bar"),
               radioButtons("plot_labels", "Sample annotation:",
                            choices = c("off", "on")),
               
               radioButtons("plot_type", "Plot Type:",
                            choices = c("boxplot", "scatterplot"))
               
      ),
      menuItem("Gene Ontology", icon = icon("book"),
               radioButtons("go_data_type", "GO Data:",
                            choices = c("biological process", "cellular compartment", "molecular function"),
                            selected = "biological process")
      ),
      menuItem("Shopping Cart", icon = icon("download"),
               div(
                 actionButton("add_protein_button", "Add protein to cart"),
                 actionButton("export_go_data_button", "Add GO data to cart"),
                 actionButton("toggle_protein_cart", "Show shopping cart",
                              style = "width: 70%; margin-bottom: 10px; font-size: 12px;"),
                 radioButtons("cart_type", "Show shopping cart as:",
                              choices = c("proteins", "go data"))
               ),
               div(
                 downloadButton("download_protein_button", "Download Shopping Cart",
                                style = "width: 70%; margin-top: 10px; display: block;"),
                 downloadButton("download_go_button", "Download GO Cart",
                                style = "width: 70%; margin-top: 10px; display: block;")
               ),
               div(
                 actionButton("upload_button", "Upload File",
                              style = "width: 50%; margin-top: 10px;"),
                 div(
                   fileInput("file_upload", "Choose CSV File",
                             accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
                   style = "display: none;"
                 )
               )
      )
    )
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML("
        #download_protein_button, #download_go_button {
          color: black !important;
          background-color: #ffffff;
          border: 1px solid #cccccc;
          font-weight: bold;
          font-size: 12px;
          padding: 5px 10px;
        }
      "))
    ),
    tags$script(HTML('
      $(document).on("change", "input.checkbox", function() {
        var selected = [];
        $("input.checkbox:checked").each(function() {
          selected.push($(this).attr("id").replace("checkbox_", ""));
        });
        Shiny.setInputValue("checked_rows", selected);
      });
    ')),
    fluidRow(
      column(width = 8,
             box(width = NULL, DT::dataTableOutput("main_display"),
                 style = "height:400px; overflow-y: scroll; overflow-x: scroll;"),
             box(width = NULL, DT::dataTableOutput("go_information"),
                 style = "height: 200px; overflow-y: scroll; overflow-x: scroll;")
      ),
      column(width = 4,
             box(width = NULL, plotOutput("show_plot", height = 300, width = 250)),
             box(width = NULL, div(tableOutput("demo"),
                                   style = "font-size:70%; overflow-y: scroll"),
                 style = "height: 150px")
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
  ShoppingCart <- reactiveValues()
  
  Database$go_list = NULL
  
  data <- reactive({
    core_database
  })
  
  observeEvent(data(),{
    Database$background <- data()
    Database$background_cache <- data()
    Database$foreground <- generate_foreground(Database$background)
    #Database$foreground$check <- sprintf("<input type='checkbox' class='checkbox' id='checkbox_%s'>", core_database$Entry)
    Database$foreground_cache <- Database$foreground
    ShoppingCart$data <- create_empty_dataframe(Database$foreground)
    ShoppingCart$go_data <- create_empty_go_dataframe()
    Global$demographics <- demographics
  })
  
  #setting up the search parameters
  Search$cache <- NULL
  Search$is_ongoing <- FALSE
  
  Database$primary_search_is_ongoing <- FALSE
  
  toggle_go_data_type(input, trigger = "go_data_type", Database)
  toggle_plot_type(input, trigger = "plot_type", Plot)
    
  main_display_row_click_handler(input, trigger = "main_display_rows_selected", Database, Plot, Global, go_data)
  
  #GO result main_display
  output$go_information <- DT::renderDataTable({
    req(input$main_display_rows_selected)
    Database$go_table
  })
  
  search_button_logic(input, session, trigger = "search_button", Database, Search)
  
  reset_button_logic(input, session, trigger = "reset_button", Database, Search, Global, demographics, Plot)
  
  filter_button_logic(input, trigger = "filter_button", Database, Search, Global, Plot, demographics, output,session)
  
  render_main_display_table(output, table_id = "main_display", Database)
  
  shinyjs::extendShinyjs(script = NULL, functions = c())
  
  toggle_annotations(input, trigger = "plot_labels", Plot, Database)
  
  output$demo <- renderTable({
    Global$demographics
  })
  
  #output for the plot
  output$show_plot <- renderPlot({
    #req(input$main_display_rows_selected)
    Plot$current_plot
  })
  
  #logic to show alerts for entering illegal values in the demographic filter boxes
  invalid_demographic_value_error_handler(input, button_id = "age_filter", min = 1, max = 11)
  invalid_demographic_value_error_handler(input, button_id = "bsc_filter", min = 1, max = 8)
  
  #stuff involving the shopping cart
  add_protein_to_shopping_cart_handler(input, "add_protein_button", ShoppingCart, Database$foreground, output)
  add_go_info_to_shopping_cart_handler(input, "export_go_data_button", Database, ShoppingCart, go_data, output)
  remove_protein_from_shopping_cart_handler(input, "delete_selected", ShoppingCart)
  shopping_cart_row_click_handler(input, "protein_cart_main_display_rows_selected", ShoppingCart)
  
  toggle_cart_type(input, "cart_type", session, ShoppingCart, output)
  #protein_cart_main_display_backend(output, ShoppingCart)
  
  #logic for the modal portion of the cart main_display
  observeEvent(input$toggle_protein_cart,{ #modal main_display
    protein_cart_main_display_backend(output, ShoppingCart)
    showModal(modalDialog(
      title = "Protein Cart",
      tags$div(
        DTOutput("protein_cart_main_display"),
        style = "overflow-x: auto; width: 100%;"
      ),
      
      actionButton("delete_selected", "Delete Selected Rows"),
      easyClose = TRUE,
      footer = modalButton("Close"),
      style = "width: 90%; max-width: 2000px;"
    ))
  })
  
  download_protein_handler(output, ShoppingCart)
  download_go_handler(output, ShoppingCart)
  
  observeEvent(input$upload_button, {
    shinyjs::runjs('$("#file_upload").click();') # Simulate click on fileInput
  })
  
  observeEvent(input$file_upload, {
    req(input$file_upload) # Ensure a file is selected
    file_path <- input$file_upload$datapath
    
    # Read the file and update Database$foreground
    Database$foreground <- read.csv(file_path, stringsAsFactors = FALSE)
    
    # Print confirmation
    showNotification("Database$foreground has been updated.", type = "message")
  })
  
}

shinyApp(ui, server)
