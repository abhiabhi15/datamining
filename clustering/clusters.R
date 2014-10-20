#
#  Bisecting Kmeans Algorithm
#  @author : abhishek
#    
#	 Note : Please refer README.md file for the code usage
#


rm(list=ls())

# Note: Please change the path of source and input file accordingly, to locate and load these files in R directory
source("kmeans.R")
source("bikmeans.R")

## Reading File
data <- read.csv("d-c4hw2.csv")
names(data)

##Q(1) Plot of the given data.
plot(data, main="Raw Data")

##Q(2) (a) K-means with K = 4
km <- mykmeans(data, k=4)
plot(data, main="K-means clustering with K = 4", col=km$clusters)

##Q(2) (b) K-means with K = 8
km <- mykmeans(data, k=8)
plot(data, main="K-means clustering with K = 8", col=km$clusters)

##Q(3) a) bisecting k-means on the given data for K=2 to 8
clustering_sse = c()
for(i in 1:8){
  bkm <- bikmeans(data, k=i, trials=3)
  clustering_sse[i] <- bkm$totalSSE
  
}
plot(2:8, clustering_sse[2:8], type="b", xlab="Number of Clusters", ylab="SSE", main="Elbow Plot")

##Q(3) a) bisecting k-means on the given data for K=4 as optimal K
bkm_optimal <- bikmeans(data, k=4, trials=3)
plot(data, main="Bisecting K-means clustering with K = 4", col=bkm_optimal$clusters)

## END OF ASSIGNMENT
