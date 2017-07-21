#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)
library(dplyr)
library(igraph)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$network_term <- renderUI({
    list(textInput('network_term', "Enter your network terms (low cases) separated by a space", placeholder = "e.g., romeo juliette"),
         actionButton("network_submit", "Submit") )
  })
  
  network_submitted <- eventReactive(input$network_submit, {
    input$network_term
  })
  output$network <- renderPlot({
    if (is.null(input$input.file)) { return() }
    if (is.null(network_submitted() )) { return() }
    text.scan <- scan(input$input.file$datapath, what="character", sep="\n",blank.lines.skip = FALSE)  
    data=enc2utf8(text.scan)
    chunks <- list()
    
    ### split in chunks 
    len <- length(data)
    
    chunks_length <- round(len/100,0)
    k = 100
    y = 1
    for (i in 1:chunks_length) {
      chunk1 <- data[y:k]
      y=y+100
      k=k+100
      chunks[[i]] <- chunk1
    }
    # build data frame
    
    textSet <- data.frame(chunks)
    
    for (i in 1:length(colnames(textSet))) {
      colnames(textSet)[i] <- paste0("text",i)
    }

      tagSet <- data.frame(unlist(strsplit(network_submitted()," ", perl=TRUE)))

   # tagSet <- data.frame(c("flamenca","archambaut","king","queen","william","marguerite","alice","father","knights","brother"))
    colnames(tagSet)[1] <- "tag"
    
    myCorpus <- Corpus(VectorSource(textSet))
    tdm <- TermDocumentMatrix(myCorpus, control = list(removePunctuation = TRUE, stopwords=TRUE))
    tdm.onlytags <- tdm[rownames(tdm)%in%tagSet$tag,]
    tdm.matrix <- as.matrix(tdm.onlytags)
    tdm.matrix <- as.matrix(tdm)
    
    tdm.matrix[tdm.matrix>=1] <-1  # create boolean
    termMatrix <- tdm.matrix %*% t(tdm.matrix)
    termMatrix[5:10,5:10]
    termMatrix <- as.matrix(tdm.onlytags) %*% t(as.matrix(tdm.onlytags))
    
    # build a graph from the above matrix
    g <- graph.adjacency(termMatrix, weighted=T, mode = "undirected")  
    g <- simplify(g)
    V(g)$label <- V(g)$name
    V(g)$degree <- degree(g)
    layout1 <- layout.fruchterman.reingold(g)
   # plot(g, layout=layout1)
    V(g)$label.cex <- 1.2 * V(g)$degree / max(V(g)$degree)+ .2
    V(g)$label.color <- rgb(0, 0, .2, .8)
    V(g)$frame.color <- NA
    #egam <- (log(E(g)$weight)+.4) / max(log(E(g)$weight)+.4)
    egam <- (log(E(g)$weight)+.3) / max(log(E(g)$weight)+.3)
    E(g)$color <- rgb(.5, .5, 0, egam)
    E(g)$width <- egam
    # plot the graph in layout1
  #  plot(g, layout=layout1)
    plot(g, layout=layout1,vertex.size=7.2 * V(g)$degree / max(V(g)$degree)+ 5.2)
    
  })
  
})
