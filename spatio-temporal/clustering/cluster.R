##############################################
# Course : Spatial and Temporal Data Mining
# Author : Abhishek Agrawal
# Unity ID : akagrawa
##############################################

rm(list=ls())

getSampleIndex <- function(data, binSize=20, selectSize=1){
    set.seed(2)
    asize <- nrow(data)
    sampleIndex <- c()
    i = 0
    while(i < asize){
        sampleIndex <- append(sampleIndex, i + sample(1:binSize, selectSize))
        i = i + binSize
    }
    sampleIndex
}

# Question 1 

library(rgdal)
library(flexclust)
library(mclust)

image <- readGDAL("hw2/ilk-3b-1024.tif")  # Reading image
imgData <- as.data.frame(image)

sampleIndex <- getSampleIndex(imgData, binSize=10)  # Sampling from data
sampleData <- imgData[sampleIndex,1:3]

# K Means on the sampled data
kClusters <- 6
km = kcca(sampleData, k=kClusters)
pred <- predict(km, imgData[-sampleIndex,1:3])   # Classifying the unlabeled samples

imgData$clust <- 0
imgData[sampleIndex, 6] <- km@cluster
imgData[-sampleIndex, 6] <- pred              # Merging the results

# Plotting the results with cluster as colors
plot(imgData$x, imgData$y, col=imgData$clust, pch=20, main="Image Clustering: Kmeans",
     xlab="X co-ordinate", ylab="Y co-ordinate")

## Finding Optimal Number of Clusters
wss <- (nrow(sampleData)-1)*sum(apply(sampleData,2,var))
for (i in 2:10){
    wss[i] <- sum(kmeans(sampleData, centers=i)$withinss)
}
# Elbow Plot
plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")

# Model Based Clustering

sampleIndex <- getSampleIndex(imgData, binSize=50)
sampleData <- imgData[sampleIndex,1:3]
mc = Mclust(sampleData)
predM <- predict(mc, imgData[-sampleIndex,1:3])

imgData$clust <- 0
imgData[sampleIndex, 6] <- mc$classification
imgData[-sampleIndex, 6] <- predM$classification

summary(mc)
plot(mc$BIC[,1])
plot(mc$BIC[,9])  # best

plot(imgData$x, imgData$y, col=imgData$clust+1, pch=20, main="Image Clustering: Model based Clustering",
     xlab="X co-ordinate", ylab="Y co-ordinate")


# Question 2 DB Scan

library(fpc)
cancerData <- read.csv("hw2/cancer-data.csv")   
dd <- dbscan(cancerData, eps=.6, MinPts=8)
par(mfcol=  c(1,1)) 
plot(cancerData)
plot( cancerData, col=dd$cluster, pch=dd$cluster)
points(cancerData[which(dd$cluster == 0),], pch=20, col="brown")
