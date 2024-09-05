library(shiny)
library(shinydashboard)

ui <- dashboardPage(skin = "black",
		    dashboardHeader(title = tags$img(src='https://i.ibb.co/x6tH34j/logo4.png', height = '60', width = '120')),
		    dashboardSidebar(
				     ),
		    dashboardBody(
				  ),
		    )

server <- function(input, output, session){
}

shinyApp(ui, server)

