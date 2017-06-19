#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(ggplot2movies)
library(streamgraph)
library(dplyr)
library(tidyverse)
library(shiny)
library(viridis)

# UI ####

ui = shinyUI(fluidPage(
  
  titlePanel("Stream Plot Visualization Tool"),
  sidebarLayout(
    
    # Side bar Panel ####
    
    sidebarPanel(
      
      p('Please upload a .csv file with a time, categorical and count field.'
      ),
      tags$hr(),
      fileInput('file1', 'Choose CSV file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"')
      
      ),
    
    # Main Panel ####
    mainPanel(
        tabsetPanel(
          tabPanel( "Streamgraph example 1 ",
            h3("Movie example ", style="text-align:center"),
            streamgraphOutput('sg1')
            ),
          
          tabPanel( "Streamgraph example 2 ",
                    h3("Stock Market example ", style="text-align:center"),
                    streamgraphOutput('sg2'),
                    selectInput("offtype", "Offset Type",
                                choices = c("silouhette","expand", "zero"))
            ),
          
          tabPanel( "Data upload plot ",
                   streamgraphOutput('streamPlot')
            )
        )
    ) 
  )
))

# SERVER ####

server = function(input, output) {
  
  # movie example ####
  
  output$sg1 <- renderStreamgraph({
    ggplot2movies::movies %>%
      select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
      tidyr::gather(genre, value, -year) %>%
      group_by(year, genre) %>%
      tally(wt=value) %>%
      ungroup %>%
      streamgraph("genre", "n", "year") %>%
      sg_axis_x(20) %>%
      sg_fill_brewer("PuOr") %>%
      sg_legend(show=TRUE, label="Genres: ")
  })
  
  # stock example ####
  
  output$sg2 <- renderStreamgraph({
    stocks_url <- "http://infographics.economist.com/2015/tech_stocks/data/stocks.csv"
    stocks <- read.csv(stocks_url, stringsAsFactors=FALSE)
    head(stocks)
    stock_colors <- viridis_pal()(100)
    
    stocks %>% 
      mutate(date=as.Date(quarter, format="%m/%d/%y")) %>% 
      streamgraph(key="ticker", value="nominal", offset=input$offtype) %>% 
      sg_fill_manual(stock_colors) %>% 
      sg_axis_x(5, "year", "%Y") %>% 
      sg_legend(TRUE, "Ticker: ")
  })
  
  
  # Data upload ####
  
  output$streamPlot <- renderStreamgraph({
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    else{
      stocks <- read.csv(inFile$datapath, stringsAsFactors=FALSE)
      
      stock_colors <- viridis_pal()(100)
      
      stocks %>% 
       mutate(date=as.Date(quarter, format="%m/%d/%y")) -> stocks2
      
      streamgraph(stocks2, key="ticker", value="nominal", offset="expand") %>% 
        sg_fill_manual(stock_colors) %>% 
        sg_axis_x(tick_interval=10, tick_units="year") %>% 
        sg_legend(TRUE, "Ticker: ")
      }
  })
  
}

shinyApp(ui = ui, server = server)