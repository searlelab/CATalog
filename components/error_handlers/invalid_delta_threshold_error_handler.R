invalid_delta_threshold_error_handler <- function(input, session) {
  observeEvent(input$delta_threshold, {
    value <- input$delta_threshold
    if (value < 0) {
      shinyalert("Please enter a value greater than 0")
      updateNumericInput(session, "delta_treshold", value = NULL)  # Clears the input
    }
  })
}
