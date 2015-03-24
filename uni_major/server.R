library(ggvis)
library(dplyr)
library(data.table)
library(RSQLite)

# Set up handles to database tables on app start
uni_major <- read.csv("uni_major.csv")
uni_major <- uni_major %>% group_by(Major) %>% mutate(res= Value-mean(Value)) %>% ungroup()
uni_major$Name <- as.character(uni_major$Name)
colnames(uni_major)[1]<-'id'
uni_major<-data.table(uni_major)


shinyServer(function(input, output, session) {

  # Filter the universities, returning a data frame
  unis <- reactive({
    # Due to dplyr issue #318, we need temp variables for input values
    minvalue <- input$Value[1] * 1e3
    maxvalue <- input$Value[2] * 1e3
    mincost <- input$Tuition[1] * 1e3
    maxcost <- input$Tuition[2] * 1e3
    
    # Apply filters
    uni <- uni_major %>%
      filter(
        Value>= minvalue,
        Value<= maxvalue,
        Tuition>=mincost,
        Tuition<=maxcost         
      )

    # Optional: filter by university name
    if (!is.null(input$name) && input$name != "") {
      name <- paste0("%", input$name, "%")
      uni <- uni %>% filter(toupper(Name) %like% toupper(input$name))
    }

    #Store uni as a dataframe
    uni <- as.data.frame(uni)
    
    uni
  })

  # Function for generating tooltip text
  uni_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$id)) return(NULL)

    # Pick out the uni with this Name
    uni_major <- isolate(unis())
    uni <- uni_major[uni_major$id == x$id,]
    
    # Print what I want
    paste0("<b>", uni$Name, "</b><br>",
      'ROI: $', format(uni$Value, big.mark = ",", scientific = FALSE), "<br>",
      ' Total Cost: $', format(uni$Tuition, big.mark = ",", scientific = FALSE))
  }

  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes

    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    graph<-      
      unis %>%
      ggvis(~Major , ~Value,fill=~res) %>%
      layer_points(opacity:=.4/1,size:=30,size.hover:=50, key:=~id) %>%
      add_tooltip(uni_tooltip, "hover") %>%
      add_axis("x",title="Major",title_offset=70, properties = axis_props (
      labels=list(angle=45,align="left",fontSize=9)))%>%
      add_axis("y",title="Return ",title_offset=60,format='$d') %>%
      scale_numeric("fill",range=c("firebrick","green"))
    if (nrow(unis())==914) {
     graph<- graph %>% 
        group_by(Major) %>% 
        layer_boxplots(width=.6,opacity:=0.2,fill:='blue',size:=0.0) }
    graph
  })

  vis %>% bind_shiny("plot1")
  output$n_uni <- renderText({nrow(unis())})
})