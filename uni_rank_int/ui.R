library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

shinyUI(fluidPage(
  titlePanel("Monetary Return of a University Degree"),
  fluidRow(
    column(3,
      wellPanel(
        h4("Filter"),
        sliderInput("rank", "Ranking of a University", 1, 260, value = c(1, 260)),
        sliderInput("Accept", "Admission Rate of a University",
          0, 100, value=c(0,100),post='%'),
        sliderInput("Grad", "Graduation Rate of a University",
          0, 100, value=c(0,100),post='%'),
        sliderInput("Total_Cost", "Total Cost of a University in 1k",
          60, 250, value=c(60,250),post='k'),
        textInput("name", "Uni name contains (e.g. University of California)")
      ),
      wellPanel(
        selectInput("xvar", "X-axis variable", axis_vars, selected = "Ranking"),
        selectInput("yvar", "Y-axis variable", axis_vars, selected = "Return_Value"),
        tags$small(paste0(
          "Note: Return Value is (the cumulative salary of an alumni - ",
          "(an average salary by a high school graduate) - (4 Yr Tuition)"
        ))
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
