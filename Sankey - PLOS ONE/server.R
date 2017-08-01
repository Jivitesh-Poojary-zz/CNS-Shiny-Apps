#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# INSTALLING rCharts package
#--------------------------------------
# install.packages("devtools")
# install.packages("Rcpp")
# library(devtools)
# library(Rcpp)
# install_github('ramnathv/rCharts')
#--------------------------------------


library(shiny)
library(alluvial)
library(networkD3)
library(googleVis)
library(jsonlite)
library(rCharts)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  student.df <- read.csv("LA-enrollments-sankey.csv", header=TRUE)

  prefinal.df <- as.data.frame(xtabs( ~ education.level + gender + X2013.Enrollments + X2014.Enrollments + 
                                        X2015.Enrollments, student.df))
  
  
  prefinal.df$X2013.Enrollments <- as.character(prefinal.df$X2013.Enrollments)
  prefinal.df$X2013.Enrollments[prefinal.df$X2013.Enrollments == "Not Enrolled"] <- "Not Enrolled 2013"
  
  prefinal.df$X2013.Enrollments <- as.character(prefinal.df$X2013.Enrollments)
  prefinal.df$X2013.Enrollments[prefinal.df$X2013.Enrollments == "Not Enrolled"] <- "Not Enrolled 2013"
  prefinal.df$X2014.Enrollments <- as.character(prefinal.df$X2014.Enrollments)
  prefinal.df$X2014.Enrollments[prefinal.df$X2014.Enrollments == "Not Enrolled"] <- "Not Enrolled 2014"
  
  prefinal.df$X2014.Enrollments <- as.character(prefinal.df$X2014.Enrollments)
  prefinal.df$X2014.Enrollments[prefinal.df$X2014.Enrollments == "Not Enrolled"] <- "Not Enrolled 2014"
  prefinal.df$X2015.Enrollments <- as.character(prefinal.df$X2015.Enrollments)
  prefinal.df$X2015.Enrollments[prefinal.df$X2015.Enrollments == "Not Enrolled"] <- "Not Enrolled 2015"
  
  prefinal.df <- subset(prefinal.df, Freq != 0)
  
  prefinal.df <- data.frame(prefinal.df, LinkGroup = c(0:93))
  
  ed.gen.df <- data.frame(prefinal.df$education.level, prefinal.df$gender, prefinal.df$LinkGroup, prefinal.df$Freq)
  gen.X2013.df <- data.frame(prefinal.df$gender, prefinal.df$X2013.Enrollments, prefinal.df$LinkGroup, prefinal.df$Freq)
  X2013.X2014.tab.df <- data.frame(prefinal.df$X2013.Enrollments, prefinal.df$X2014.Enrollments, prefinal.df$LinkGroup, prefinal.df$Freq)
  X2014.X2015.tab.df <- data.frame(prefinal.df$X2014.Enrollments, prefinal.df$X2015.Enrollments, prefinal.df$LinkGroup, prefinal.df$Freq)
  
  names(ed.gen.df) <- c("Source", "Target", "LinkGroup","Count")
  names(gen.X2013.df) <- c("Source", "Target", "LinkGroup", "Count")
  names(X2013.X2014.tab.df) <- c("Source", "Target", "LinkGroup", "Count")
  names(X2014.X2015.tab.df) <- c("Source", "Target", "LinkGroup", "Count")
  
  final.df <- rbind(ed.gen.df, gen.X2013.df, X2013.X2014.tab.df, X2014.X2015.tab.df)
  rm(ed.gen.df, gen.X2013.df, X2013.X2014.tab.df, X2014.X2015.tab.df)
  
  
  # CREATING NODE DATA
  col1.df <- data.frame(unique(final.df$Source))
  names(col1.df) <- c("Node.name")
  col2.df <- data.frame(unique(final.df$Target))
  names(col2.df) <- c("Node.name")
  node.names <- data.frame(unique(rbind(col1.df , col2.df)))
  
  node.names.order <- data.frame(Node.name= c("High School", "College", "Graduate", "Ph.D.", "Unknown", 
                                              "female", "male", "Not Specified",
                                              "S637-2013", "IVMOOC-2013", "Not Enrolled 2013", 
                                              "S637-2014", "IVMOOC-2014", "Not Enrolled 2014",
                                              "SP15-BL-ILS-Z637-32593", "SP15-BL-ILS-Z637-33781", "IVMOOC-2015", "Not Enrolled 2015"))
  
  Nodes.df <- data.frame(name = node.names.order, node = c(0:17))
  names(Nodes.df) <- c("name", "node")
  
  Nodes.df = Nodes.df[, c(2,1)]
  
  # NODES TO JSON
  x <- toJSON(Nodes.df)
  
  # CREATING LINK DATA
  final.df2 <- final.df
  final.df2$Source <- as.character(final.df2$Source)
  final.df2$Target <- as.character(final.df2$Target)
  
  for (i in 1:nrow(final.df2)){
    if(final.df$Source[i] %in% Nodes.df$name)
      final.df2$Source[i] <- Nodes.df$node[Nodes.df$name == as.character(final.df$Source[i])]
    
    if(final.df$Target[i] %in% Nodes.df$name)
      final.df2$Target[i] <- Nodes.df$node[Nodes.df$name == as.character(final.df$Target[i])]
  }
  
  names(final.df2) <- c("source", "target", "LinkGroup","value")
  
  final.df2$source <- as.numeric(final.df2$source)
  final.df2$target <- as.numeric(final.df2$target)
  
  final.df2 <- final.df2[order(final.df2$source, final.df2$target, final.df2$value),]
  
  #final.df2 <- final.df2[order(final.df2$value),]
  
  # LINK TO JSON
  y <- toJSON(final.df2)
  
  # FINAL JSON FILE
  final.json <- paste0('{"nodes":', x, ',"links":', y, '}' )
  
  
  
  # METHOD for alluvial Sankey
  output$distPlot <- renderPlot({
    
    colnames(prefinal.df) <- c("Education", "Gender", "Enrollment 2013", "Enrollment 2014","Enrollment 2015", "Freq")
    
    prefinal.df.sub <- subset(prefinal.df, Freq >= input$limit)
    
    alluvial( prefinal.df.sub[,1:5], 
              freq=prefinal.df.sub$Freq, 
              border=NA,
              hide = prefinal.df.sub$Freq < quantile(prefinal.df.sub$Freq, .50),
              alpha = 0.6,
              gap.width = input$gap,
              xw = input$xw, 
              cw = input$cw,
              blocks = input$blocks,
              col=ifelse( prefinal.df.sub$Gender == input$gender & prefinal.df.sub$Education == input$education, 
                          "red", "gray") )
    
  })
  
  # METHOD for networkD3 Sankey
  output$sankey <- renderSankeyNetwork({
    
    Sankey <- jsonlite::fromJSON(final.json, flatten=TRUE)
    sankeyNetwork(Links = Sankey$links, 
                  Nodes = Sankey$nodes, 
                  Source = "source",
                  Target = "target", 
                  Value = "value", 
                  NodeID = "name", 
                  colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20);"),
                  width = 1000, 
                  height=1000,
                  fontSize = input$fontsize, 
                  nodeWidth = input$nodewid, 
                  nodePadding = input$nodepad,
                  iterations = input$iter)
  })
  
  # METHOD for Google Vis Sankey
  output$ggvisplot <- renderGvis({
    
    gvisSankey(final.df, from="source", to="target", weight="Count",
                          options=list(width=1500, height=900,
                            sankey="{link: {color: { fill: '#d799ae' } },
                        node: { color: { fill: '#a61d4c' },
                        label: { color: '#871b47' } }}"))
  })
  
  
  #-----------------------------------------------
  #----------- NEW DATA CREATION -----------------
  #-----------------------------------------------
  ed.gen.df <- as.data.frame(xtabs( ~ education.level + gender, student.df))
  
  gen.X2013.df <- as.data.frame(xtabs( ~ gender + X2013.Enrollments, student.df))
  gen.X2013.df$X2013.Enrollments <- as.character(gen.X2013.df$X2013.Enrollments)
  gen.X2013.df$X2013.Enrollments[gen.X2013.df$X2013.Enrollments == "Not Enrolled"] <- "Not Enrolled 2013"
  
  X2013.X2014.tab.df <- as.data.frame(xtabs( ~ X2013.Enrollments + X2014.Enrollments, student.df))
  X2013.X2014.tab.df$X2013.Enrollments <- as.character(X2013.X2014.tab.df$X2013.Enrollments)
  X2013.X2014.tab.df$X2013.Enrollments[X2013.X2014.tab.df$X2013.Enrollments == "Not Enrolled"] <- "Not Enrolled 2013"
  X2013.X2014.tab.df$X2014.Enrollments <- as.character(X2013.X2014.tab.df$X2014.Enrollments)
  X2013.X2014.tab.df$X2014.Enrollments[X2013.X2014.tab.df$X2014.Enrollments == "Not Enrolled"] <- "Not Enrolled 2014"
  
  X2014.X2015.tab.df <- as.data.frame(xtabs( ~ X2014.Enrollments + X2015.Enrollments, student.df))
  X2014.X2015.tab.df$X2014.Enrollments <- as.character(X2014.X2015.tab.df$X2014.Enrollments)
  X2014.X2015.tab.df$X2014.Enrollments[X2014.X2015.tab.df$X2014.Enrollments == "Not Enrolled"] <- "Not Enrolled 2014"
  X2014.X2015.tab.df$X2015.Enrollments <- as.character(X2014.X2015.tab.df$X2015.Enrollments)
  X2014.X2015.tab.df$X2015.Enrollments[X2014.X2015.tab.df$X2015.Enrollments == "Not Enrolled"] <- "Not Enrolled 2015"
  
  names(ed.gen.df) <- c("Source", "Target", "Count")
  names(gen.X2013.df) <- c("Source", "Target", "Count")
  names(X2013.X2014.tab.df) <- c("Source", "Target", "Count")
  names(X2014.X2015.tab.df) <- c("Source", "Target", "Count")
  
  final.type2.df <- rbind(ed.gen.df, gen.X2013.df, X2013.X2014.tab.df, X2014.X2015.tab.df)
  rm(ed.gen.df, gen.X2013.df, X2013.X2014.tab.df, X2014.X2015.tab.df)
 
  
   
  # METHOD for rCharts Sankey 
  output$myChart <- renderChart({
    sankeyPlot2 <- rCharts$new()
    sankeyPlot2$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey/')
    gallery.edge <- final.type2.df[c("Source", "Target", "Count")]
    names(gallery.edge) <- c("source","target","value")
    
    sankeyPlot2$set(
      data = gallery.edge,
      nodeWidth = 15,
      nodePadding = 10,
      layout = 32,
      width = 960,
      height = 500
    )
    return(sankeyPlot2)
  })
  

  
  
  # METHOD for riverPlot Sankey 
  output$myRivChart <- renderChart({
    rp <- list(nodes = nodes, edges = edges, styles = styles)
    class(rp) <- c(class(rp), "riverplot")
    plot(rp, plot_area = 0.95, yscale=0.06)
  })
    
})
