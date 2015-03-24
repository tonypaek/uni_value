library(ggvis)
library(dplyr)
library(data.table)
library(RSQLite)

# Set up handles to database tables on app start
db <- read.csv("uni.csv")
db$Graduation_Rate<-as.numeric(as.character(db$Graduation_Rate))
db$Name<-as.character(db$Name)
db<-data.table(db)

# Clean data so that I only have what I want!
all_uni <- db %>%
  select(Name, Rank, Acceptance_Rate, Graduation_Rate, Total_Cost,Return_Value)

shinyServer(function(input, output, session) {

  # Filter the universities, returning a data frame
  unis <- reactive({
    # Due to dplyr issue #318, we need temp variables for input values
    minrank <- input$rank[1] 
    maxrank <- input$rank[2] 
    min_accept <- input$Accept[1] / 100.0
    max_accept <- input$Accept[2] / 100.0
    min_grad <- input$Grad[1] / 100.0
    max_grad <- input$Grad[2] / 100.0
    min_cost <- input$Total_Cost[1] * 1e3
    max_cost <- input$Total_Cost[2] * 1e3
    
    # Apply filters
    uni <- all_uni %>%
      filter(
        Rank>= minrank,
        Rank<= maxrank,
        Acceptance_Rate>= min_accept,
        Acceptance_Rate<= max_accept,
        Graduation_Rate>=min_grad,
        Graduation_Rate<=max_grad,
        Total_Cost>=min_cost,
        Total_Cost<=max_cost         
      )

    # Optional: filter by university name
    if (!is.null(input$name) && input$name != "") {
      name <- paste0("%", input$name, "%")
      uni <- uni %>% filter(toupper(Name) %like% toupper(input$name))
    }

    #Store uni as a dataframe
    uni <- as.data.frame(uni)
    
    # Fit a regression line and get residuals
    f <- paste(input$yvar,'~',input$xvar)
    fit <- lm(f, data=uni)
    # Store distance from 
    uni$res<-residuals(fit)

    uni
  })

  # Function for generating tooltip text
  uni_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$Name)) return(NULL)

    # Pick out the uni with this Name
    all_uni <- isolate(unis())
    uni <- all_uni[all_uni$Name == x$Name,]

    # Print what I want
    paste0("<b>", uni$Name, "</b><br>",
      'Rank: ', uni$Rank, "<br>",
      'ROI: $', format(uni$Return_Value, big.mark = ",", scientific = FALSE),
      ' Total Cost: $', format(uni$Total_Cost, big.mark = ",", scientific = FALSE) 
    )
  }
  
  # Function for determining the display type and reversibility
  displaytype <- function  (x) {
    if (x=="Rank") {
      display='d'
      rev=TRUE}
    else if (x=="Acceptance_Rate") {
      display='%d'
      rev=TRUE }
    else if (x=="Graduation_Rate") {
      display='%d'
      rev=FALSE }
    else if (x=="Total_Cost") {
      display='$d'
      rev=FALSE }
    else if (x=="Return_Value") {
      display='$d'
      rev=FALSE
    }
    newList=list("display"=display,"rev"=rev)
    return (newList)
  }  

  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]

    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    dis_type_x<-displaytype(input$xvar)
    dis_type_y<-displaytype(input$yvar)
    dis_x<-dis_type_x$display
    rev_x<-dis_type_x$rev
    dis_y<-dis_type_y$display
    rev_y<-dis_type_y$rev
    
graph <-  unis %>%
      ggvis(x = xvar, y = yvar,fill=~res) %>%
      layer_model_predictions( model='lm', se=FALSE) %>%
      layer_points(size := 30, size.hover := 100,
        fillOpacity := 0.7, fillOpacity.hover := 0.5,
        key := ~Name) %>%
      add_tooltip(uni_tooltip, "hover") %>%
      add_axis("x", title = xvar_name,format=dis_x) %>%
      add_axis("y", title = yvar_name,title_offset=70,format=dis_y) %>%
      scale_numeric("fill",range=c("firebrick","lightgreen")) %>%
      scale_numeric("x",reverse=rev_x) %>%
      scale_numeric("y",reverse=rev_y) %>%
      set_options(width = 500, height = 500)


# if (nrow(unis())==1) {
#   graph <- graph %>%
#   scale_numeric("x",reverse=rev_x,domain=c(unis$as.character(input$xvar)(xvar[1])*.9,as.numeric(xvar[1])*1.1)) %>%
#   scale_numeric("y",reverse=rev_y,omain=c(as.numeric(yvar[1])*.9,as.numeric(yvar[1])*1.1))
# }
graph
  })
  vis %>% bind_shiny("plot1")
  output$n_uni <- renderText({nrow(unis())})
})
