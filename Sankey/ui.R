library(networkD3)
library(tidyverse)

fluidPage(
  titlePanel("Sankey Visualization Tool"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      
      # Alluvial plot ####
      
      p('Please upload a .csv file with categorical data. If a row identifier exists 
        kindly remove it before uploading the data.'
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
                   '"'),
      
      # Sankey NetworkD3 ####
      tags$hr(),
      
      fileInput('file2', 'Choose JSON file to upload',
                accept=c('.json'))
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data Summary", 
          column(2, tableOutput('contents'))
        ),
        tabPanel("Alluvial Network", 
                 plotOutput("alluvialPlot")
        ),
        tabPanel("Sankey Network", 
                  #checkboxInput(label = "Sink Right (Uncheck to collapse)", "sinksRight", value = TRUE),
                  fluidPage(
                    sankeyNetworkOutput("sankey"))
        )
        )
    )
  )
)