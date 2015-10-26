
rm(list=ls())
library(ggplot2)
library(reshape2)
library(gridExtra)

movies <- read.csv("../data/review_time.csv", stringsAsFactor=FALSE)

getAggregate <- function(funcName, pivot, pnames){
    movieStats <- aggregate(list(movies$reviews), pivot, FUN=funcName)
    names(movieStats) <- pnames
    movieStats
}

yearWise <- getAggregate(sum, list(movies$year), c("year","reviews")) 
quarterWise <- getAggregate(sum, list(movies$quarter, movies$year), c("quarter","year","reviews"))
monthWise <- getAggregate(sum, list(movies$month, movies$year), c("month","year","reviews"))

write.csv(quarterWise, file="quarter_movie.csv", row.names=F)
write.csv(monthWise, file="month_movie.csv", row.names=F)
write.csv(yearWise, file="yearr_movie.csv", row.names=F)

ggplot(yearWise, aes(x = as.factor(year), y = reviews, fill = year)) +
    ylab("Number of Reviews") + xlab("Year") + ggtitle("YEARWISE Movie Reviews Distribution") +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1), 
    legend.position = "none")

quarterWise <- quarterWise[quarterWise$year > 1997,]
quarterWise$quarter = as.factor(quarterWise$quarter)
quarterWise$year = as.factor(quarterWise$year)

data <- quarterWise$reviews
data=matrix(data,ncol=4,byrow=T)
#Label the columns and rows
colnames(data)=c("Q1","Q2","Q3","Q4")
rownames(data)=levels(quarterWise$year)


barplot(t(data), main="Quarter Wise Reviews [1998 to 2012]",
        xlab="Years", col=c("pink","blue","light green","red"), ylab="Reviews"
        , beside=TRUE, legend.text=colnames(data), args.legend = list(x="topleft"))



DF1 <- melt(data , id.var=quarter)
names(DF1) <- c("Year","Quarters","Reviews")

DF1$Year <- as.factor(DF1$Year)
DF1$Quarters <- as.factor(DF1$Quarters)

library(ggplot2)
ggplot(DF1, aes(x = Year, y = Reviews, fill = Quarters)) + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    geom_bar(stat = "identity",  position = "dodge") + ggtitle("Quarter Wise Reviews [1998 to 2012] ")

