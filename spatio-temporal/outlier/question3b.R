rm(list=ls())
source("installDependencies.R")


### Q3b) H0 check
library(ape)
ozoneData <- read.csv("spatial-oz.csv") ## Loading DataSet
distance <- as.matrix(dist(cbind(ozoneData$Lon, ozoneData$Lat)))
## Weight Matrix
distance_inv <- 1/distance 
diag(distance_inv) <- 0
Moran.I(ozoneData$oz, distance_inv) ## Computing Moran's I
