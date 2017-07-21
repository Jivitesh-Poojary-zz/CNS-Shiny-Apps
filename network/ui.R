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
  titlePanel("Network Graph"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput('input.file', 'Choose File in TEXT format',multiple=TRUE, accept=c('txt')),
      tags$h4("Extract Network Terms"),
      helpText("Ex. Type name entities (low cases) to find their relation separated by a space"),
      uiOutput("network_term")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("network")
    )
  )
))
