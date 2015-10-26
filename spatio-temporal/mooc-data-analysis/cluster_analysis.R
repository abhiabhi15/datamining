rm(list=ls())
source("helper.R")
data <- read.csv("clusterUSAData.csv")

table(data$cluster)

### Analysis of Cluster 9 [Big Size]

c1 <- data[data$cluster == 9,]
c1 <- na.omit(c1)
dim(c1)


library(maps)
map('usa') 
map.axes()

map("state", boundary = FALSE, lty = 3, add = TRUE)
map("county", col="grey",boundary = FALSE, lty = 1, add = TRUE)
points(x=c1$longitude, y=c1$latitude, col=c1$cluster, pch=20) 
title(paste(paste(paste("USA : Mooc Spatial DB Scan Eps", eps), " & MinPts "), MinPts))


c1data <- c1[,c(2,3,5)]
c1scaled <- getScaledData(c1data)

kmeansElbow(data=c1scaled, clust=2:10)

m1 <- kmeans(c1scaled, centers=4)

table(m1$cluster)


c1["cluster_intra"] <- m1$cluster
summary(c1)


c1[c1$cluster_intra == 1,]$cluster_intra <- "A"
c1[c1$cluster_intra == 2,]$cluster_intra <- "B"
c1[c1$cluster_intra == 3,]$cluster_intra <- "C"
c1[c1$cluster_intra == 4,]$cluster_intra <- "D"

c1[c1$cluster_intra == "A",]$cluster_intra <- 3
c1[c1$cluster_intra == "B",]$cluster_intra <- 1
c1[c1$cluster_intra == "C",]$cluster_intra <- 4
c1[c1$cluster_intra == "D",]$cluster_intra <- 2



c11 <- c1[c1$cluster_intra %in% c(1,3,4),]
map('state', region = c('california'))
map.axes()

points(x=c1$longitude, y=c1$latitude, col=c1$cluster_intra, pch=20) 
points(x=c11$longitude, y=c11$latitude, col=c11$cluster_intra,pch=20) 
#title("USA State California Bay Area For All Users")
title("USA State California Bay Area For Active Users")

c1$cluster_intra <- as.numeric(c1$cluster_intra)

library(car)
## Number of Actions
scatterplot(c1$cluster_intra, log(c1$numActions), xlab='Cluster', ylab='Log(Number of Actions)', main= 'Box Plot: Number of Actions Among Clusters', col=rainbow(3), 
            labels = row.names(c1), span=T)

## Number of Lecturess
scatterplot(c1$cluster_intra, sqrt(c1$numLecture), xlab='Cluster', ylab='Sqrt(Number of Lectures)', main= 'Box Plot: Number of lectures Among Clusters', col=rainbow(3), 
            labels = row.names(c1), span=T)

## Number of Quizes
scatterplot(c1$cluster_intra, c1$numQuiz, xlab='Cluster', ylab='Number of Quizes', main= 'Box Plot: Number of Quizes Among Clusters', col=rainbow(3), 
            labels = row.names(c1), span=T)

## Grades
scatterplot(c1$cluster_intra, c1$normal_grade, xlab='Cluster', ylab='Grades', main= 'Box Plot: Grade Distribution Among Clusters', col=rainbow(3), 
            labels = row.names(c1), span=T)


table(c1$cluster_intra)

summary(c1[c1$cluster_intra == 2,36])


clust <- as.data.frame(table(c1$cluster_intra))
names(clust) <- c("Cluster Number", "Freq")
write.csv(clust,"cluster-2_NY_Region.csv")

