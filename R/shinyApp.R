# library(gapminder)
# library(ggplot2)
# library(shiny)
# library(gganimate)
# library(rlang)
# library(magrittr)
#
# theme_set(theme_bw())

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
    shiny::titlePanel(appTitle),

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

    # p_first <- gapminder %>%
    #   ggplot(aes(gdpPercap, lifeExp, size = pop,
    #              color = continent)) +
    #   geom_point() +
    #   scale_x_log10() +
    #   NULL
    #
    # p1 <- ggreverse::convert_to_code(p_first)

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
        theme_minimal()
    )

    p <- rlang::eval_tidy(p1)

    output$plot1 <- shiny::renderPlot({
      p
    })

    shiny::callModule(makeFlipbook, "test", p1)

  }

  shiny::shinyApp(ui, server)

}

shinyflipbookr("shinyflipbookr example")
