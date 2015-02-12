rm(list=ls())

webData <-  read.csv("zappos/webdata.csv", header = T)
summary(webData)

# Feature Extraction and Engineering
webData <- rawData
webData$date <- substring(webData$day, 0, 7)
head(webData)

webData$day <- weekdays(as.Date(webData$date, "%m/%d/%y"))
webData$day <- as.factor(webData$day)

webData$month <- months(as.Date(webData$date, "%m/%d/%y"))
webData$month <- as.factor(webData$month)

webData$weekend[webData$day %in% c("Saturday","Sunday")] <- 1
webData$weekend[!(webData$day %in% c("Saturday","Sunday"))] <- 0

webData$convRate <- webData$orders/webData$visits;
webData$bounceRate <- webData$bounces/webData$visits;
webData$add2CartRate <- webData$add_to_cart/webData$visits;

webData$new_customer[which(is.na(webData$new_customer))] <- 2

### Questions
library(ggplot2)
library(reshape2)

# Q1 who visits and what they d

activity <- aggregate(list(webData$visits, webData$bounces, webData$add_to_cart, webData$orders), list(webData$new_customer), FUN="median")
names(activity) <- c("Customers","Visits","Bounces","Add to Cart", "Order")
activity <- activity[,-1]

Customers=c("New_User","Old User","Neither")     # create list of names
data=data.frame(cbind(activity),Customers)   # combine them into a data frame
data.m <- melt(data, id.vars='Customers')

# plot everything
ggplot(data.m, aes(Customers, value)) +   
    geom_bar(aes(fill = variable), position = "dodge", stat="identity") +  scale_y_log10() 
+ylab("Count")



###########################################################################
## Q2 Is there any significant patterns in visitors behavior on days of week?

webData <-  subset(webData, new_customer >= 0) 
activity <- aggregate(list(webData$visits, webData$bounces, webData$add_to_cart, webData$orders), list(webData$month), FUN="mean")
names(activity) <- c("Month","Visits","Bounces","Add to Cart", "Order")
activity <- activity[,-1]

Months=unique(webData$month)     # create list of names
data=data.frame(cbind(activity),Months)   # combine them into a data frame

data.m <- melt(data, id.vars='Months')
data.m$Months <- factor(data.m$Months, levels=c("January", "February", "June","July","August","September","October","November","December"))
ggplot(data.m, aes(x = Months, y = value)) + geom_line(size=1, aes(group=variable,color=factor(variable)))+geom_point(color="blue")

### Q3 Natural Clusters and Classification
clustData <- subset(webData, select=c("new_customer","visits","orders","bounces","add_to_cart","product_page_views"))

plot(clustData[,2:6], pch=20, col=clustData$new_customer+1)


## Q4 How is the website and platform share? 
qplot(factor(platform), data=webData, geom="bar", fill=factor(site))  + theme(axis.text.x = element_text(angle = 90, hjust = 1))

