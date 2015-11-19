
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
reviews 

p <- ggplot(freq, aes(Var1, Freq))
p + geom_point(aes(colour = Freq)) + ggtitle("Movie Reviews Count (Log Scale )") + ylab("Reviews Count") + xlab("Movies")  + theme( legend.position = "none")

mov_stats <- data.frame()
for(i in c(10,50,100,150, 200, 250, 300, 350, 400, 450, 500, 600, 700)){
  fil_rev <- reviews[(reviews$reviews > i),]
  cat("Review count > ", i , " For Movies  = ", nrow(fil_rev), "\n")
  mov_stats = rbind(mov_stats, c(i, nrow(fil_rev)))
}
names(mov_stats) = c("Count", "NumMovies")

ggplot(mov_stats, aes(x = as.factor(Count), y = NumMovies, fill = Count)) +
  ylab("Number of Movies") + xlab("Movies Having Greater than #Reviews") + ggtitle("Movies Reviews [2005-2011]") +
  geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1), 
                                      legend.position = "none")

filtered <- reviews[(reviews$reviews > 700),]
write.csv(filtered, file="movies_700_plus_reviews.csv", row.names=F, quote=FALSE)
