fluidPage(
  titlePanel("Sankey Visualization Tool"),
  sidebarLayout(
    sidebarPanel(
      p('Please upload a .csv file with categorical data. If a row identifier exists 
        kindly remove it before uploading the data.'
      ),
      tags$hr(),
      fileInput('file1', 'Choose file to upload',
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
    mainPanel(
      tabsetPanel(
        tabPanel("Data Summary", 
          column(2, tableOutput('contents'))
        ),
        tabPanel("Sankey Network", 
                 plotOutput("alluvialPlot")
        )
        )
    )
  )
)