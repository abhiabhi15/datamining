rm(list=ls())

library(flexclust)
library(mclust)

data <- read.csv("../data/bitcoin/users-stats.csv")
head(data)

df <- as.data.frame(scale(data[-1]))  
head(df)

sampleIndex <- sample(1:nrow(df), 800000)
sampleData <- as.data.frame(df[sampleIndex,])

plot(sampleData$num_sent_txns, sampleData$num_received_txns)

kClusters <- 6
km = kcca(sampleData, k=kClusters)

pred <- predict(km, df[-sampleIndex,-1])   # Classifying the unlabeled samples
df$clust <- 0
df[sampleIndex, 6] <- km@cluster
df[-sampleIndex, 6] <- pred              # Merging the results


## Finding Optimal Number of Clusters
wss <- (nrow(x=sampleData)-1)*sum(apply(sampleData,2,var))
for (i in 2:10){
  wss[i] <- sum(kmeans(sampleData, centers=i)$withinss)
}

# Elbow Plot
plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")


