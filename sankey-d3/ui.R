#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
header <- dashboardHeader(
  title = "d3 Integration"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
   # menuItem("Simple Sankey d3", tabName = "sankey1", icon = icon("bar-chart-o")),
   menuItem("Sankey d3", tabName = "sankey3", icon = icon("bar-chart-o")),
   menuItem("Sankey R", tabName = "sankey2", icon = icon("bar-chart-o")),
    menuItem("References", icon = icon("fa fa-commenting"), tabName = "references")
  )
)

body <- dashboardBody(
  tags$div(class = "tab-content" ,
           tabItem(tabName = "dashboard", 
                   tags$head(tags$script(src="https://d3js.org/d3.v4.min.js")),
                   tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                   h3("d3 javascript"),
                   br(),
                   p("The integration of D3 poweful visualization into Shiny Web Applications brings 
                     new opportunities to Data Visualziation. Data can be reactively uploaded by web users, pre-processed in R and visualized in d3.
                     In addition to existing R visualization libraries, d3 codes allow for more comprehensive customization of visual fields.
                     Furthemore, shiny front-end provides a fast build for interactive interfaces via a variety of dashboard layouts.
                     "),         
                   fluidRow(column(width = 12,
                                           h4("Sample Bar Chart", align = "center"),
                                           br(),
                                           br(),
                                           box(width = 12,
                                               tags$div(id = "sample-bar", 
                                                        #to style to d3 output pull in css
                                                        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                                                        #load D3JS library
                                                        tags$head(tags$script(src="https://d3js.org/d3.v4.min.js")),
                                                        #load javascript
                                                        #tags$script(src="d3script.js"),
                                                        tags$head(tags$script(src="d3script-sample-bar.js") ),
                                                        br()
                                               )
                                           )
                           )
                           )
                   
           ),
           # tabItem(tabName="sankey1",
           #         fluidRow(column(width = 12,
           #                         h4("Sankey Using d3plus", align = "center"),
           #                         tags$script(src="d3.js"),
           #                         tags$script(src="d3plus.js"),
           #                         tags$script(src="d3plus.min.js"),
           #                         tags$script(src="d3.min.js"),
           #                         tags$script(src="sankey.js"),
           #                         br(),
           #                         br(),
           #                         box(width = 12,
           #                             tags$div(id = "sankeyd3plus", 
           #                                    #  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
           #                                             #load D3JS library
           #                                     # tags$head(tags$script(src="https://d3js.org/d3.v3.min.js")),
           #                                     # tags$head(tags$script(src="https://d3js.org/d3.v4.min.js")),
           # 
           #                                      #       tags$script(src="d3script2.js") 
           #                                      #to style to d3 output pull in css
           #                                   # tags$div(id = "sankey_d3plus",
           #                                      tags$head(tags$script(src="d3script-sankey-d3plus.js") ),
           #                                      br()
           #                             
           #                             )
           #                         )
           #         )
           #         )
           #         ),
           tabItem(tabName="sankey2",

                     fluidRow(
                       column(width = 12,
                       box(width = 12,
                           tags$div(id = "box", 
                                  #  dataTableOutput("sum"))
                       sankeyNetworkOutput("sankey"))
                       )
                       )
                       ),
                  # ),
                   fluidRow(
                     column(12,
                            sliderInput("fontsize", "Font Size:", min = 2, max = 20, value = 12),
                            sliderInput("nodewid", "Node Width:", min = 5, max = 100, value = 30),
                            sliderInput("nodepad", "Node Padding:", min = 0, max = 100, value = 5),
                            sliderInput("iter", "Iterations:", min = 0, max = 100, value = 0)
                     )
                   )
           ),
           tabItem(tabName="sankey3",
                   fluidRow(column(width = 12,
                                   h4("Sankey Using d3", align = "center"),
                                   br(),
                                   br(),
                                  # tags$script(src="d3.js"),
                                  # tags$script(src="d3plus.js"),
                                 #  tags$script(src="d3plus.min.js"),
                                  # tags$script(src="d3.min.js"),
                                  # tags$script(src="sankey.js"),
                                 #  tags$script(src="main.js"),
                                   box(width = 12,
                                       tags$div(id = "chart", # rename 
                                                tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                                                #load D3JS library
                                                tags$head(tags$script(src="https://d3js.org/d3.v3.min.js")),
                                                tags$head(tags$script(src="sankey.js")),
                                                tags$head(tags$script(src="http://gc.kis.v2.scr.kaspersky-labs.com/FF9B637C-C0D9-5941-A355-F5A0E3CB842F/main.js")),
                                                tags$head(tags$script(src="d3script-sankey-d3.js") ),
                                                br()
                                       )
                                   )
                   )
                   )
           )
      )
  
)
  
  dashboardPage(
    header,
    sidebar,
    #dashboardSidebar(disable = FALSE),
    body
  )