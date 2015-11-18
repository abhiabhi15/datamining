
rm(list=ls())
library(ggplot2)
library(reshape2)
library(gridExtra)

reviews <- read.csv("~/Downloads/ncsu/istudy/data/movie/year/review_freq.csv",
                    stringsAsFactor=FALSE)

reviews <- reviews[with(reviews, order(-reviews)),]
freq <- as.data.frame(table(reviews$reviews))
freq$Freq <- round(log(freq$Freq + 1))
head(freq)
qplot(freq)
reviews 

p <- ggplot(freq, aes(Var1, Freq))
p + geom_point(aes(colour = Freq)) + ggtitle("Movie Reviews Count (Log Scale )") + ylab("Reviews Count") + xlab("Movies")  + theme( legend.position = "none")

ff <- freq[freq$Freq > 200,]
sum(ff$Freq)
