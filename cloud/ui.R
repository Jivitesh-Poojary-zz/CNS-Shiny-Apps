#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Word cloud"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput('input.file', 'Choose File(s) in TEXT format',multiple=FALSE, accept=c('txt'))

    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      wordcloud2Output("print_cloud")
    )
  )
))
