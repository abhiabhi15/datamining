rm(list=ls())
library(ggplot2)
library(reshape2)
library(gridExtra)

crDates <- read.csv("../data/medline/created_date_raw.csv", stringsAsFactor=FALSE)

getAggregate <- function(funcName, pivot, pnames){
    pubStats <- aggregate(list(crDates$count), pivot, FUN=funcName)
    names(pubStats) <- pnames
    pubStats
}

yearWise <- getAggregate(sum, list(crDates$year), c("year","count")) 
ggplot(yearWise, aes(x = as.factor(year), y = count, fill = year)) +
    ylab("Number of Publications") + xlab("Year") + ggtitle("Publication Created Date Distribution") +
    geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1), 
                                        legend.position = "none")
