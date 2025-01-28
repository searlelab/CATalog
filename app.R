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
      ),
      menuItem("Filters", icon = icon("filter"),
               selectInput("biofluid_type", "Filter by highest biofluid:",
                           choices = c("All", "Urine", "Serum", "Plasma")),
               numericInput("age_filter", "Maximum Age", value = 11),
               numericInput("bsc_filter", "Maximum BSC", value = 8),
               radioButtons("sex_filter", "Sex: ", choices = c("Both", "Female Spayed", "Male Neutered")),
               actionButton("filter_button", "Apply Filters")
      ),
      menuItem("Plots", icon = icon("chart-bar"),
               radioButtons("show_annotations", "Sample Annotation:",
                            choices = c("off", "on")),
               
               radioButtons("swap_plot_type", "Plot Type:",
                            choices = c("Boxplot", "Scatterplot"))
               
      ),
      menuItem("Gene Ontology", icon = icon("book"),
               radioButtons("swap_go_data_type", "GO Data:",
                            choices = c("Biological Process", "Cellular Compartment", "Molecular Function"),
                            selected = "Biological Process")
      ),
      menuItem("Shopping Cart", icon = icon("download"),
               div(
                 actionButton("add_protein_button", "Add protein to cart"),
                 actionButton("add_go_data_button", "Add GO data to cart"),
                 actionButton("show_protein_cart", "Show Protein cart",
                              style = "width: 70%; margin-bottom: 10px; font-size: 12px;"),
                 actionButton("show_go_cart", "Show GO cart",
                              style = "width: 70%; margin-bottom: 10px; font-size: 12px;"),

               ),
               div(
                 downloadButton("download_protein_button", "Download Protein Data",
                                style = "width: 70%; margin-top: 10px; display: block;"),
                 downloadButton("download_go_button", "Download GO Data",
                                style = "width: 70%; margin-top: 10px; display: block;")
               ),
               div(
                 actionButton("upload_button", "Upload Proteins",
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
             box(width = NULL, DT::dataTableOutput("go_display"),
                 style = "height: 200px; overflow-y: scroll; overflow-x: scroll;")
      ),
      column(width = 4,
             box(width = NULL, plotOutput("plot_display", height = 300, width = 250)),
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
  PlotManager <- reactiveValues() #holds plot information
  Global <- reactiveValues() #elements that are not related to the core database but need to be accessed by disprate functions
  ShoppingCart <- reactiveValues()
  
  show_cart_trigger <- reactiveVal(0)
  
  Search$ongoing <- FALSE
  
  shinyjs::extendShinyjs(script = NULL, functions = c())
  
  #setup components
  database_setup(core_database, demographics, Database, ShoppingCart)
  
  
  #button elements
  search_button_logic(input, session, Database, Search)
  reset_button_logic(input, session, Database, Search, demographics, PlotManager)
  filter_button_logic(input, Database, Search, PlotManager, demographics, output,session)
  
  add_element_button_logic(input, ShoppingCart, output, Database, go_data)
  show_cart_button_logic(input, ShoppingCart, show_cart_trigger)
  remove_cart_item_button_logic(input, output, ShoppingCart)
  
  
  #toggles
  toggle_go_data_type(input, Database)
  toggle_plot_type(input, PlotManager)
  toggle_annotations(input, PlotManager, Database)
  
  #error handlers
  invalid_demographic_value_error_handler(input, button_id = "age_filter", min = 1, max = 11)
  invalid_demographic_value_error_handler(input, button_id = "bsc_filter", min = 1, max = 8)
  
  #main display
  render_main_display_table(output, table_id = "main_display", Database)
  main_display_row_click_handler(input, Database, PlotManager, go_data)
  
  #go display
  render_go_table(input, output, Database)
  
  #demographic display
  render_demographic_table(output, Database)
  
  #plot display
  render_plot_display(output, input, PlotManager)
  
  #shopping cart
  shopping_cart_display_frontend(output, show_cart_trigger, ShoppingCart)
  shopping_cart_display_backend(output, ShoppingCart)
  
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
