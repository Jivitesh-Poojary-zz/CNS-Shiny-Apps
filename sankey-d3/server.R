#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(rjson)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  sankey_d3plus <- "file_name"
  var_json3 <- "file_name"
  sample_bar <- "file_name"
  
  session$sendCustomMessage(type="sankey_d3plus",sankey_d3plus)
  session$sendCustomMessage(type="jsondata3",var_json3)
  session$sendCustomMessage(type="sample_bar",sample_bar)
})
