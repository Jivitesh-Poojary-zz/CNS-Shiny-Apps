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
    menuItem("Simple Sankey d3", tabName = "sankey1", icon = icon("bar-chart-o")),
    menuItem("Sankey R", tabName = "sankey2", icon = icon("bar-chart-o")),
    menuItem("Sankey d3", tabName = "sankey3", icon = icon("bar-chart-o")),
    menuItem("References", icon = icon("fa fa-commenting"), tabName = "references")
  )
)

body <- dashboardBody(
  tags$div(class = "tab-content" ,
           tabItem(tabName = "dashboard", 
                   tags$head(tags$script(src="https://d3js.org/d3.v4.min.js")),
                   tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                   h3("Sample"),
                             
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
           tabItem(tabName="sankey1",
                   fluidRow(column(width = 12,
                                   h4("Sankey Using d3plus", align = "center"),
                                   tags$script(src="d3.js"),
                                   tags$script(src="d3plus.js"),
                                   tags$script(src="d3plus.min.js"),
                                   tags$script(src="d3.min.js"),
                                   tags$script(src="sankey.js"),
                                   br(),
                                   br(),
                                   box(width = 12,
                                       tags$div(id = "sankeyd3plus", 
                                              #  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                                                       #load D3JS library
                                               # tags$head(tags$script(src="https://d3js.org/d3.v3.min.js")),
                                               # tags$head(tags$script(src="https://d3js.org/d3.v4.min.js")),

                                                #       tags$script(src="d3script2.js") 
                                                #to style to d3 output pull in css
                                             # tags$div(id = "sankey_d3plus",
                                                tags$head(tags$script(src="d3script-sankey-d3plus.js") ),
                                                br()
                                       
                                       )
                                   )
                   )
                   )
                   ),
           tabItem(tabName="sankey1",
                   fluidRow(column(width = 12,
                                   h4("Sankey Using R", align = "center"),
                                   br(),
                                   br(),
                                   box(width = 12,
                                       tags$div(id = "sankey2", 
                                                tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                                                #load D3JS library
                                               
                                                br()
                                       )
                                   )
                   )
                   )
           ),
           tabItem(tabName="sankey3",
                   fluidRow(column(width = 12,
                                   h4("Sankey Using d3", align = "center"),
                                   br(),
                                   br(),
                                   box(width = 12,
                                       tags$div(id = "sankey3", # rename 
                                                tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                                                #load D3JS library
                                                tags$head(tags$script(src="https://d3js.org/d3.v4.min.js")),
                                                # add sankey.js
                                                # add your d3code
                                               # tags$head(tags$script(src="d3script2.js") ),
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