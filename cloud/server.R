#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(wordcloud2)
library(tm)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   

  #########print_cloud########
  output$print_cloud <-renderWordcloud2({
    if (is.null(input$input.file)) { return() }
  #  input.file <- "http://cl.indiana.edu/~obscrivn/antonyCleopatra.txt"
    text.scan <- scan(input$input.file$datapath, what="character", sep="\n",blank.lines.skip = FALSE)
    
    ## declare UTF-8 encoding
    text.utf=enc2utf8(text.scan)
    
    ## combined lines and collapse them by a space
    mytext <- paste(text.utf, collapse = " ")
    
    ## creating a corpus
    mycorpus <- Corpus(VectorSource(mytext))
    # lower case
    mycorpus <- tm_map(mycorpus, tolower)
    # remove punctuation
    mycorpus <- tm_map(mycorpus, removePunctuation)
    # remove numbers
    mycorpus <- tm_map(mycorpus, removeNumbers)
    # remove stopwords
    mycorpus <- tm_map(mycorpus, removeWords, stopwords('english'))
    ### if you have additional stop words - uncomment the next two lines
    mystopwords <- c("thou","thy","thee")
    mycorpus <- tm_map(mycorpus, removeWords, mystopwords)
    mycorpus <- tm_map(mycorpus, stripWhitespace)
    mycorpus <- tm_map(mycorpus, PlainTextDocument)
    #frequency matrix
    myfreq <- TermDocumentMatrix(mycorpus)
    ## find the most frequent terms with the low frequency cut-off = 100 
    findFreqTerms(myfreq, lowfreq = 100)
    
    mymatrix <- as.matrix(myfreq)
    # sort the frequency table
    mymatrix.sorted <- sort(rowSums(mymatrix), decreasing = TRUE)
    
    myNames <- names(mymatrix.sorted)
    
    myfrequency.table <- data.frame(word = myNames, frequency = mymatrix.sorted)
    
    wordcloud2(myfrequency.table)
  })
  
})
