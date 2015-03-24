library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

shinyUI(fluidPage(
  titlePanel("Monetary Return of University Degree by Area of Study"),
  fluidRow(
    column(3,
      wellPanel(
        h4("Filter"),
        sliderInput("Value", "Value of a University",
          -208, 1620, value=c(-208,1620),post='k'),
        sliderInput("Tuition", "Total Cost of a University",
                    53, 242, value=c(53,242),post='k'),        
        
        textInput("name", "Uni name contains (e.g. University of California)")
      )
    ),
    column(9,
      ggvisOutput("plot1"),
      wellPanel(
        span("Number of universities selected:",
          textOutput("n_uni")
        )
      )
    )
  )
))
