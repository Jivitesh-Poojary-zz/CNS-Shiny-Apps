#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
 myfile <- reactive({
    if (is.null(input$file1)){return()}
   mydata <- read.csv(input$file1$datapath, header=TRUE, sep=',')
 return(mydata) 
 })
 
output$summary <- renderPrint({
  summary(myfile())
})

  output$distPlot <- renderPlot({
    if (is.null(input$file1)) {
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    }
    else {
      x <- myfile()$budget
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col='red', main = 'My New Histogram')
    }
  })
  
  output$table <- renderDataTable({
    myfile()
  })
  
})
