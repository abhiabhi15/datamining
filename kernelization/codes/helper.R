rm(list=ls())
library(kernlab)
source("twoCrossConfusionMatrixMetrics.R")

generateConcentricPoints <- function(n=1000, radius1=2, radius2=3){
  
  theta <- runif(n,-pi,pi)
  r <- runif(n, max=radius2, min=radius1)
  x <- r * cos(theta)
  y <- r * sin(theta)
  matrix(c(x,y),nrow=n, ncol=2)
}

computePerformanceMetrics <- function(GT1, GT2, CL1, CL2){
  TP <- length(intersect(GT1, CL1))
  FP <- length(intersect(GT1, CL2))
  FN <- length(intersect(GT2, CL1))
  TN <- length(intersect(GT2, CL2))
  
  CM <- matrix(c(TP, FP, FN, TN), ncol=2, nrow=2, byrow=TRUE)
  print(CM)
  twoCrossConfusionMatrixMetrics(CM)
}

kpcaSummary <- function(kpc){
    result <- list()
    kpcv <- pcv(kpc)
    eigSum <- sum(kpc@eig)
    Eratio <- kpc@eig/eigSum 
    result$Proportion <- Eratio
    result$Cumulative <- cumsum(Eratio)
    result
}

extraDimensions <- function(n, means){
  x <- NULL
  for(i in 1:length(means)){
    if(is.null(x)){
      x <- rnorm(n, means[i])    
    }else{
      x <- cbind(x, rnorm(n, means[i]))    
    }
  }  
  x
}
