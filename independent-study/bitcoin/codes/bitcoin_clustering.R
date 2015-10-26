rm(list=ls())

getMinMaxNormalizedData <- function(data){
  for( col in 2:6){
    col_max <- max(data[,col], na.rm=TRUE)
    col_min <- min(data[,col], na.rm=TRUE)
    norm_col <- log((data[,col] - col_min)/(col_max - col_min))
    data[,col] <- norm_col
  }
  data
}

library(flexclust)
library(mclust)

data <- read.csv("../data/bitcoin/users-stats.csv")
head(data)

df1 <- as.data.frame(scale(data[-1]))  
head(df1)

sampleIndex <- sample(1:nrow(df1), 800000)
sampleData <- as.data.frame(df1[sampleIndex,])

plot(sampleData$num_sent_txns, sampleData$num_received_txns)

kClusters <- 6
km = kcca(sampleData, k=kClusters)

pred <- predict(km, df1[-sampleIndex,-1])   # Classifying the unlabeled samples
df1$clust <- 0
df1[sampleIndex, 6] <- km@cluster
df1a[-sampleIndex, 6] <- pred              # Merging the results


## Finding Optimal Number of Clusters
wss <- (nrow(x=sampleData)-1)*sum(apply(sampleData,2,var))
for (i in 2:10){
  wss[i] <- sum(kmeans(sampleData, centers=i)$withinss)
}

# Elbow Plot
plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")


