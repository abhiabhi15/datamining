##############################################
# Course : Spatial and Temporal Data Mining
# Author : Abhishek Agrawal
# Unity ID : akagrawa
##############################################

rm(list=ls())

getSampleIndex <- function(data, binSize=20, selectSize=1, seed=1){
    set.seed(seed)
    asize <- nrow(data)
    sampleIndex <- c()
    i = 0
    while(i < asize){
        sampleIndex <- append(sampleIndex, i + sample(1:binSize, selectSize))
        i = i + binSize
    }
    sampleIndex
}

library(rgdal)
library(mclust)

# Model Based Clustering

runMClust <- function(imgData, binSize, selectSize, seed){
    
    binSize = 200
    selectSize = 2
    seed = 42
    sample_Index <- getSampleIndex(imgData, binSize=binSize, selectSize=selectSize, seed=seed)
    sample_Data <- imgData[sample_Index,1:3]
    nrow(sample_Data)
    naIndex <- which(is.na(sample_Data))
    sample_Data <- na.omit(sample_Data)
    #sample_Data[is.na(sample_Data)] <- 130.15
    model = Mclust(sample_Data,G=6)
    predM <- predict(model, imgData[-sample_Index,1:3])
    
    imgData$clust <- 0
    imgData[sample_Index, 6] <- model$classification
    imgData[-sample_Index, 6] <- predM$classification
    
    output <- list()
    output$data <- imgData$clust
    output$model <- model
    output$pred <- predM
    output
}

plot2D <- function(imgData, clust, index){
    
#    filename <- paste(paste("Mclust", index, sep="-"), "png", sep=".")
#    png(filename = filename ,width = 1323, height = 1024, units = "px")    
    main <- paste("Image Clustering: Model based Clustering Sample ", index, sep="- ")
    plot(imgData$x, imgData$y, col=clust+1, pch=20, main=main,
         xlab="X co-ordinate", ylab="Y co-ordinate")
 #   dev.off()
}

image <- readGDAL("exams/ilk-3b-1024.tif")  # Reading image
imgData <- as.data.frame(image)

## Sample 1 , model and plot
output1 <- runMClust(imgData, binSize=50, selectSize=1, seed=1)
output1 <- output
clusts <- output$data
plot2D(imgData, clusts, 1)

## Sample 2 , model and plot
#output2 <- runMClust(imgData, binSize=40, selectSize=1, seed=2)
output2 <- output
clusts <- output2$data
plot2D(imgData, clusts, 2)

## Sample 3 , model and plot
output3 <- output
clust3 <- output3$data
plot2D(imgData, clust3, 3)

## Sample 4 , model and plot
#output4 <- runMClust(imgData, binSize=40, selectSize=1, seed=4)
output4 <- output
clust4 <- output4$data
plot2D(imgData, clust4, 4)

## Sample 5 , model and plot
#output5 <- runMClust(imgData, binSize=100, selectSize=3, seed=5)
output5 <- output
clust5 <- output5$data
plot2D(imgData, clust5, 5)


