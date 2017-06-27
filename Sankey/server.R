# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
#options(shiny.maxRequestSize = 9*1024^2)
#library(networkD3)
#library(alluvial)
library(streamgraph)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(alluvial)
library(ggplot2movies)

function(input, output) {
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    else{
      inFile2 <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote)
      inFile3 <- as.data.frame(xtabs( ~ ., inFile2))
      inFile3 <- subset(inFile3, Freq != 0)
      return(inFile3)
    }
  })
  
  output$value <- renderPrint({
    str(input$file1)
  })
  
  # METHOD for alluvial Sankey
  output$alluvialPlot <- renderPlot({
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    else{
      inFile2 <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote)
      inFile3 <- as.data.frame(xtabs( ~ ., inFile2))
      inFile3 <- subset(inFile3, Freq != 0)
      alluvial( inFile3[1:(dim(inFile3)[2]-1)], freq=inFile3$Freq, border=NA,
              hide = inFile3$Freq < quantile(inFile3$Freq, .50) )
    }
    
  })
  
  # METHOD for networkD3 Sankey
  output$sankey <- renderSankeyNetwork({
    
    inFile <- input$file2
    
    if (is.null(inFile))
      return(NULL)
    
    Sankey <- jsonlite::fromJSON(input$file2$datapath, flatten=TRUE)
    sankeyNetwork(Links = Sankey$links, Nodes = Sankey$nodes, Source = "source",
                  Target = "target", Value = "value", NodeID = "name", colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20);"),
                  fontSize = 12, nodeWidth = 30, iterations = 0)
  })
  
  

  
  # METHOD for stream plot
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
  
}