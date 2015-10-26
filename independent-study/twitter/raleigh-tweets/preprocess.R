library(streamR)
library(tm)
library(SnowballC)


preprocess <- function(tweets){
    tweets <- VCorpus(VectorSource(tweets))
    #Removing punctuations and numbers.
    removePunctuations = function(x){
        return( gsub(pattern = "[^A-Za-z'[:space:]]", replacement = "", x = x, ignore.case = T) )
    }
    
    removeTwitterHandle = function(x){
        return( gsub(pattern = "@\\w+", replacement = "", x = x, ignore.case = T) )
    }
    
    removeURL = function(x){
      x = gsub(pattern = "www\\w+", replacement = "", x = x, ignore.case = T)
      x = gsub(pattern = "http\\w+", replacement = "", x = x, ignore.case = T)
      return( x )
    }
    
    removeSmallWords = function(x){
      x = gsub(pattern = "\\b\\w{1,2}\\b", replacement = "", x = x, ignore.case = T)
      return( x )
    }
    
    tweets <- tm_map(tweets,  content_transformer(removeTwitterHandle))
    tweets <- tm_map(tweets,  content_transformer(removePunctuations))
    tweets <- tm_map(tweets,  content_transformer(removeURL))
    tweets <- tm_map(tweets,  content_transformer(removePunctuation))
    tweets <- tm_map(tweets,  content_transformer(removeSmallWords))
    
    custom_stop_words <- readLines("stop-word.txt")
    tweets <- tm_map(tweets, content_transformer(tolower))
    tweets <- tm_map(tweets, removeWords, c(custom_stop_words,"rt") )
    tweets <- tm_map(tweets, stripWhitespace)  
    tweets <- tm_map(tweets, stemDocument)
    tweets<-data.frame(text=unlist(sapply(tweets, `[`, "content")), 
                          stringsAsFactors=F)
    return(tweets)
}

getTDM <- function(tweetDf, wordFreq){
  tweets <- VCorpus(VectorSource(tweetDf$text))
  tdm <- buildTDM(tweets, wordFreq)
  tdm <- as.data.frame(as.matrix(tdm))
  tdm <- t(tdm)
  tdm <- as.data.frame(tdm)
  tdm    
}

buildTDM <- function(tweets, freq){
    
    tdm <- TermDocumentMatrix(tweets)
    #Create dictionary of high freq words in order to perform feature selection
    my.dict <- as.vector(findFreqTerms(tdm, lowfreq = freq))
    #create tdm from the high freq words
    tdm <- TermDocumentMatrix(tweets, control = list(dictionary = my.dict))
    tdm
}

getTestTDM <- function(tweetDf, modelTerms){
  tweets <- VCorpus(VectorSource(tweetDf$text))
  tdm <- TermDocumentMatrix(tweets, control = list(dictionary = modelTerms))
  tdm <- as.data.frame(as.matrix(tdm))
  tdm <- t(tdm)
  tdm <- as.data.frame(tdm)
}

## For Word Cloud Visualization
worldCloud <- function(tdm){
    ae.v <- sort(rowSums(as.matrix(tdm)),decreasing=TRUE)
    ae.d <- data.frame(word = names(ae.v),freq=ae.v)
    pal2 <- brewer.pal(8,"Dark2")
    wordcloud(ae.d$word,ae.d$freq, scale=c(8,.2),min.freq=1,max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)
}
