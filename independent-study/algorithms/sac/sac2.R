## SAC1 Algorithm
rm(list=ls())
library(igraph)
source("helper.R")
cal <- read.csv("../facebook/data/Caltech36_adj.csv", header=F) 
mat1 <- data.matrix(cal,rownames.force=NA)
g <- graph.adjacency(mat1)

sampleData <- read.csv("../facebook/data/Caltech36.csv")
sampleData <- scale(sampleData, center = TRUE, scale = TRUE)

attrs <- c("year","dorm","gender")

wss <- (nrow(x=sampleData)-1)*sum(apply(sampleData,2,var))
for (i in 1:60){
  wss[i] <- sum(kmeans(sampleData, centers=i)$withinss)
}

# Elbow Plot
plot(1:60, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")


