rm(list=ls())
source("helper.R")
source("preprocess.R")
source("rmongo.R")

  
tweets <- getMongoTweets()
  
## Pre-process
tweets_text <- tweets$text
tweets_text <- preprocess(tweets_text)

write.table(tweets_text, file="raleigh-tweets_less_process.txt", row.names=F)
