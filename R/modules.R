#' Make Flipbook UI
#'
#' @param id
#'
#' @return
#' @export
#'
#' @examples
makeFlipbook_UI <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::actionButton(ns("makeFlipbook"), "make a flipbook"),
    shiny::uiOutput(ns("codeslider")),
    shiny::fluidRow(
      shiny::column(
        shiny::plotOutput(ns("plot2")),
        width = 6
      ),
      shiny::column(
        shiny::textOutput(ns("code")),
        shiny::tags$style(type="text/css", "#code {white-space: pre-wrap;}"),
        width = 6
      )
    ),
    shiny::fluidRow(
      shiny::includeHTML(ns("test.html"))
    )
  )
}

#' Make a Flipbook in a shiny app
#'
#' @param input
#' @param output
#' @param session
#' @param myplot a ggplot wrapped in `rlang::quo`
#'
#' @return
#' @export
#'
#' @examples
makeFlipbook <- function(input, output, session, myplot) {

  p2 <-
    myplot %>%
    rlang::quo_text() %>%
    # stringr::str_replace("\\n", "") %>%
    flipbookr::code_parse() %>%
    flipbookr:::parsed_return_partial_code_sequence() %>%
    identity()

  pList <- purrr::map(p2, ~eval(parse(text=.x)))

  output$codeslider <- renderUI({
    ns <- session$ns
    sliderInput(ns("n"), "N", 1, length(pList), 1, 1)
  })

  output$plot2 <- renderPlot({
    pList[[input$n]]
    # p
  })

  output$code <- renderText({
    paste0(p2[[input$n]], "\n")
  })

  output$frame <- renderUI({
    # my_test <- shiny::tags$iframe(src=shiny::includeHTML("test.html"), height=600, width=535)
    my_test <- shiny::includeHTML("test.html")
    # print(my_test)
    my_test
  })

}
