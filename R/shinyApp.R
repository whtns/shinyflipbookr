
#' Create a Shiny Flipbookr
#'
#' @param appTitle The title to be displayed
#'
#' @return
#' @export
#'
#' @examples
shinyflipbookr <- function(appTitle = "shinyflipbookr example") {

  ui <- shiny::fluidPage(

    # Application title
    shiny::titlePanel("appTitle"),

    shiny::sidebarLayout(

      # Sidebar with a slider input
      shiny::sidebarPanel(
      ),

      # Show a plot of the generated distribution
      shiny::mainPanel(
        shiny::plotOutput("plot1"),
        makeFlipbook_UI("test")

      )
    )
  )


  server <- function(input, output) {

    p1 <- rlang::quo(
      gapminder::gapminder %>%
        dplyr::filter(year == 2007) %>%
        ggplot2::ggplot() +
        ggplot2::aes(x = gdpPercap) +
        ggplot2::aes(y = lifeExp) +
        ggplot2::geom_point(alpha = .6) +
        ggplot2::aes(color = continent) +
        ggplot2::aes(size = pop / 1000000) +
        ggplot2::labs(title = "Per capita GDP versus life expectency in 2007") +
        ggplot2::labs(subtitle = "Data Source: Gapminder package in R") +
        ggplot2::labs(size = "Population (millions)") +
        ggplot2::labs(col = "") +
        ggplot2::labs(x = "Per capita GDP") +
        ggplot2::labs(y = "Life expectancy") +
        ggplot2::labs(caption = "Vis: Gina Reynolds for 'Tidyverse in Action'") +
        ggplot2::theme_minimal()
    )

    p <- rlang::eval_tidy(p1)

    output$plot1 <- shiny::renderPlot({
      p
    })

    shiny::callModule(makeFlipbook, "test", p1)

    # with ggreverse ------------------------------
    # p1 <- gapminder::gapminder %>%
    #   ggplot2::ggplot() +
    #   ggplot2::aes(x = gdpPercap) +
    #   ggplot2::aes(y = lifeExp) +
    #   ggplot2::aes(size = pop) +
    #   ggplot2::aes(color = continent) +
    #   ggplot2::geom_point() +
    #   NULL
    #
    # p_reverse <- ggreverse::convert_to_code(p1)
    #
    # output$plot1 <- shiny::renderPlot({
    #   p1
    # })
    #
    # shiny::callModule(makeFlipbook, "test", p_reverse)
    # ------------------------------


  }

  shiny::shinyApp(ui, server)

}

shinyflipbookr("shinyflipbookr example")
