#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(networkD3)
library(rCharts)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("IVMOOC Student Enrollment Data"),
  
    tabsetPanel(
      
      # Google Sankey ####
      tabPanel("Sankey Network", 
               #checkboxInput(label = "Sink Right (Uncheck to collapse)", "sinksRight", value = TRUE),
               fluidPage(
                 fluidRow(
                  sankeyNetworkOutput("sankey"))
                ),
                 fluidRow(
                   column(12,
                   sliderInput("fontsize", "Font Size:", min = 2, max = 20, value = ,12),
                   sliderInput("nodewid", "Node Width:", min = 5, max = 100, value = ,30),
                   sliderInput("nodepad", "Node Padding:", min = 0, max = 100, value = ,5),
                   sliderInput("iter", "Iterations:", min = 0, max = 100, value = ,0)
                   )
                 )
               ),
               #plotOutput("distPlot2")),
      
      
      # NetworkD3 Sankey ####
      tabPanel("Alluvial Sankey Network",
                fluidRow(
                  splitLayout(
                    cellArgs = list(style = "padding: 26px"),
                  plotOutput("distPlot", width = "100%", height = "600px"))
                ),
                br(),
                fluidRow(
                 column(12,
                  sliderInput("limit", "Number of enrollments:", min = 1, max = 700, value = 1)
                 )
                ),
                fluidRow(
                 column(4,
                  selectInput("gender", "Gender:", choices = c('Male'='male','Female'='female', 'Not Specified' = 'Not Specified')),
                  selectInput("education", "Education Level:", 
                           choices = c("College", "Graduate", "High School", "Ph.D.", "Unknown"))
                  ),
                 column(4,
                  selectInput("blocks", "Block present:", 
                           choices = c("TRUE","FALSE")),
                  sliderInput("gap", "Gap between blocks:", min = 0.01, max = 1, value = ,0.05)
                  ),
                 column(4,
                  sliderInput("xw", "Set axis to the control points:", min = 0.01, max = 1, value = ,0.1),
                  sliderInput("cw", "Width of Category Axis:", min = 0.01, max = 1, value = ,0.1)
                 )
                )
               ),
      
      
      # GoogleViz Sankey ####
      tabPanel("GoogleViz Sankey Network", 
               htmlOutput("ggvisplot")
      )
      
      
      # rCharts Sankey ####
    #tabPanel("rCharts Sankey Network",
     #          showOutput("myChart", "polycharts")
     # )
    )

))
