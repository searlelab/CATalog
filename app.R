source('setup.R')

core_database <- read.csv("./data/protein_database.csv")

ui <- dashboardPage(skin = "black",
                    dashboardHeader(title = tags$img(src='https://i.ibb.co/x6tH34j/logo4.png', height = '60', width = '120')),
                    dashboardSidebar(
                      textInput("keyword", "Filter proteins by GO: ", value = ""),
                      actionButton("search_button", "Search"),
                      actionButton("reset_button", "reset"),
                      selectInput("sample_type", "Filter by highest biofluid:",
                                  choices = c("all", "urine", "serum", "plasma")),
                      numericInput("age_filter", "Maximum Age", value = 11),
                      numericInput("bsc_filter", "Maximum BSC", value = 8),
                      actionButton("filter_button", "Filter"),
                      radioButtons("plot_labels", "Sample annotation: ",
                                   c("off", "on")),
                      radioButtons("go_item", "GO Data: ",
                                   c("biological process",
                                     "cellular compartment",
                                     "molecular function"),
                                   selected = "biological process"),
                      actionButton("add_protein_button", "Add protein to cart"),
                      actionButton("toggle_protein_cart", "Show protein shopping cart"),
                      actionButton("test_button", "Test")
                    ),
                    dashboardBody(
                      tags$script(HTML(
                        "
                        $(document).on('change', 'input.checkbox', function(){
                          var selected = [];
                          $('input.checkbox:checked').each(function(){
                            selected.push($(this).attr('id').replace('checkbox_',''));
                          });
                          Shiny.setInputValue('checked_rows',selected);
                        });
                        "
                      )),
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
  ShoppingCart <- reactiveValues()
  
  Database$go_list = NULL
  
  data <- reactive({
    core_database
  })
  
  observeEvent(data(),{
    Database$background <- data()
    Database$background_cache <- data()
    Database$foreground <- generate_foreground(Database$background)
    Database$foreground$check <- sprintf("<input type='checkbox' class='checkbox' id='checkbox_%s'>", core_database$Entry)
    Database$foreground_cache <- Database$foreground
    ShoppingCart$data <- create_empty_dataframe(Database$foreground)
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
    datatable(Database$foreground, 
              selection = 'single',
              escape = FALSE,
              options = list(dom = 't', paging = FALSE))
  }, server = FALSE)
  
  annotation_toggle(input, trigger = "plot_labels", Plot, Database)
  
  output$demo <- renderTable({
    Plot$demographics
  })
  
  #output for the plot
  output$show_plot <- renderPlot({
    #req(input$display_rows_selected)
    Plot$boxplot
  })
  
  #logic to show alerts for entering illegal values in the demographic filter boxes
  demographic_filter_alert(input, button_id = "age_filter", min = 1, max = 11)
  demographic_filter_alert(input, button_id = "bsc_filter", min = 1, max = 8)
  
  #stuff involving the shopping cart
  add_protein_to_cart(input, "add_protein_button", ShoppingCart, Database$foreground)
  remove_protein_from_cart(input, "delete_selected", ShoppingCart)
  shopping_cart_row_select_logic(input, "protein_Cart_display_rows_selected")
  
  
  
  #defines the shopping cart table appearance
  output$protein_cart_display <- DT::renderDataTable({
    datatable(ShoppingCart$data,
              selection = "single",
              options = list(
                scrollX = TRUE,
                autoWidth = TRUE,
                pageLength = 10
              ),
              class = 'display nowrap'
              )
  })
  
  #logic for the modal portion of the cart display
  observeEvent(input$toggle_protein_cart,{ #modal display
    showModal(modalDialog(
      title = "Protein Cart",
      tags$div(
        DTOutput("protein_cart_display"),
        style = "overflow-x: auto; width: 100%;"
      ),
      
      actionButton("delete_selected", "Delete Selected Rows"),
      easyClose = TRUE,
      footer = modalButton("Close"),
      style = "width: 90%; max-width: 2000px;"
    ))
  })
  
  observeEvent("test_button",{
    print(input$checked_rows)
  })
  
  
}

shinyApp(ui, server)
