library(rmongodb)
library(plyr)
collection <- 'tweets.raleigh'
mg <- mongo.create() ## Mongo DB Instance Created
print("MongoDB Connection Opened")
cur <- mongo.find(mg, ns=collection)

getMongoTweets<-function(){
    if(mongo.is.connected(mg)){
        #print(mongo.get.databases(mg))
        #print(mongo.get.database.collections(mg, 'twitterstream'))
        buf <- mongo.bson.buffer.create()
        tweets<-data.frame(stringsAsFactors = F)
        while (mongo.cursor.next(cur)) {
            tmp = mongo.bson.to.list(mongo.cursor.value(cur))
            tmp.df = as.data.frame(t(unlist(tmp)), stringsAsFactors = F)
            text<-as.data.frame(tmp.df$txt)
            #print(text)
            tweets<-rbind.fill(tweets,text)
        }
        colnames(tweets)<-c("text")
        #print(tweets)
        return(tweets)
  }else {
    print("Not connected to MongoDB")
  }
}

getTotalTweetsCount <- function(){
    mongo.count(mg, collection)    
}


mongoDestroy <- function(){
    mongo.destroy(mg)
    print("MongoDB Connection Closed")
}
