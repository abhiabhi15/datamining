##############################################
# Course : Spatial and Temporal Data Mining
# Author : Abhishek Agrawal
# Unity ID : akagrawa
##############################################

rm(list=ls())
source("helper.R")
# Question 1 
############## Reading and Processing Data
library(rgdal)

image <- readGDAL("ilk-3b-1024.tif")  # Reading image
imgData <- as.data.frame(image)

trainData <- read.csv("ilk-tr-xy.csv")
trainData <- trainData[,c("x","y","label")]

testData <- read.csv("ilk-te-xy.csv")
testData <- testData[,c("x","y","label")]

imgData$x = imgData$x - min(imgData$x)
imgData$y = imgData$y - min(imgData$y)
imgData$y = rev(imgData$y)

trainData <- extendData(trainData)
trainData <- merge(trainData, imgData, by= c("x","y"), all.x=TRUE)
trainSet <- trainData[,c("band1","band2","band3", "label")]
trainSet$label <- as.factor(trainSet$label)

testData <- merge(testData, imgData, by= c("x","y"), all.x=TRUE)
testSet <- testData[,c("band1","band2","band3", "label")]
testSet$label <- as.factor(testSet$label)

###############################################################
## State of the Art, Classifiers

## Decision Tree
library(rpart)

model <- rpart(label ~ ., data=trainSet)
plot(model, uniform=TRUE, margin=0.2)
text(model, minlength=3, fancy=TRUE)
pred <- predict(object = model, newdata = testSet[,1:3], type="class")  

mm <- confusionMatrix(pred, testSet$label)
mm$table
mm

pred <- predict(object = model, newdata = imgData[,1:3], type="class")  
#par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
plot(imgData$x, rev(imgData$y), col=pred, pch=20 , main="Classifier : Decision Tree", xlab="x cord",ylab="y cord")

legend( "topright",  # places a legend at the appropriate place
c("House","Road", "Grass", "Trees","Water"), # puts text in the legend 
pch=rep(15,5), # gives the legend appropriate symbols (lines)
lwd=c(2.5,2.5),col=1:5)

#### Naive Bayesian

library(e1071)
model <- naiveBayes(label ~ ., data = trainSet)
pred <- predict(object = model, newdata = testSet[,-c(4)], type="class")  
table(as.numeric(pred), as.numeric(testSet$label))
confusionMatrix(pred, testSet$label)

pred <- predict(object = model, newdata = imgData[,1:3])  

plot(imgData$x, rev(imgData$y), col=pred, pch=20 , main="Classifier : Naive Bayesian", xlab="x cord",ylab="y cord")

legend( "topright",  # places a legend at the appropriate place
        c("House","Road", "Grass", "Trees","Water"), # puts text in the legend 
        pch=rep(15,5), # gives the legend appropriate symbols (lines)
        lwd=c(2.5,2.5),col=1:5)



## Neural Network
library(nnet)
model = nnet(x = trainSet[c(1:3)], y = class.ind(trainSet$label), size = 10, softmax=TRUE)
summary(model)
pred = predict(model, testSet[c(1:3)], type="class")
pred <- as.factor(pred)
mm <- confusionMatrix(pred, testSet$label)
mm$table

pred <- predict(object = model, newdata = imgData[,1:3], type="class")  


plot(imgData$x, rev(imgData$y), col=pred, pch=20 , main="Classifier : Neural Network", xlab="x cord",ylab="y cord")

legend( "topright",  # places a legend at the appropriate place
        c("House","Road", "Grass", "Trees","Water"), # puts text in the legend 
        pch=rep(15,5), # gives the legend appropriate symbols (lines)
        lwd=c(2.5,2.5),col=1:5)

## SVM
model <- svm(label ~ ., data = trainSet, gamma=0.5, cost=4, type="C-classification")
summary(model)
pred2 <- predict(object = model, newdata = testSet[,1:3])  
mm <- confusionMatrix(pred2, testSet$label)
mm$table

pred <- predict(object = model, newdata = imgData[,1:3])  

plot(imgData$x, rev(imgData$y), col=pred, pch=20 , main="Classifier : Support Vector Machine", xlab="x cord",ylab="y cord")

legend( "topright",  # places a legend at the appropriate place
        c("House","Road", "Grass", "Trees","Water"), # puts text in the legend 
        pch=rep(15,5), # gives the legend appropriate symbols (lines)
        lwd=c(2.5,2.5),col=1:5)

### KNN
library(class)
res <- knn(trainSet[,1:3] ,k=17, imgData[,1:3], cl=trainSet$label)

res <- knn(trainSet[,1:3] ,k=17, testSet[,1:3], cl=trainSet$label)
confusionMatrix(res, testSet$label)

plot(imgData$x, rev(imgData$y), col=res, pch=20 , main="Classifier : K-Nearest Neighbour", xlab="x cord",ylab="y cord")

legend( "topright",  # places a legend at the appropriate place
        c("House","Road", "Grass", "Trees","Water"), # puts text in the legend 
        pch=rep(15,5), # gives the legend appropriate symbols (lines)
        lwd=c(2.5,2.5),col=1:5)



####################################################################
## Q:3b
## Equal binning
equalFreq <-function(x,n,include.lowest=TRUE){
    nx <- length(x)    
    id <- round(c(1,(1:(n-1))*(nx/n),nx))
    breaks <- sort(x)[id]
    cut(x,breaks,include.lowest=include.lowest)
}

convertIntoBin <- function(x){
    if(x >= 35 && x <= 90){
        return(1)
    }else if( x > 90 && x <= 102){
        return(2)
    }else if(x > 102 && x <= 109){
        return(3)
    }else if(x > 109 && x <= 115){
        return(4)
    }else if(x > 115 && x <= 123){
        return(5)
    }else if(x > 123 && x <= 132){
        return(6)
    }else if(x > 132 && x <= 146){
        return(7)
    }else if(x > 146 && x <= 164){
        return(8)
    }else if(x > 164 && x <= 186){
        return(9)
    }else if(x > 186){
        return(10)
    }
}


band <- c(imgData$band1, imgData$band2, imgData$band3)
tbl <- table(equalFreq(x=band, 10))
df <- as.data.frame(tbl)
df

imgBin <- as.data.frame(lapply(imgData[,1:3], function(x) { sapply(x,convertIntoBin) }))
trainBin <- as.data.frame(lapply(trainSet[,1:3], function(x) { sapply(x,convertIntoBin) }))
trainBin$label <- trainSet$label

testBin <- as.data.frame(lapply(testSet[,1:3], function(x) { sapply(x,convertIntoBin) }))
testBin$label <- testSet$label

library(rpart)

model <- rpart(label ~ ., data=trainBin)
plot(model, uniform=TRUE, margin=0.2)
text(model, minlength=3, fancy=TRUE)
pred <- predict(object = model, newdata = testBin[,1:3], type="class")  

confusionMatrix(pred, testBin$label)

pred <- predict(object = model, newdata = imgBin[,1:3], type="class")  

plot(imgData$x, rev(imgData$y), col=pred, pch=20 , main="Classifier : Decision Tree :: 10-bins", xlab="x cord",ylab="y cord")

legend( "topright",  # places a legend at the appropriate place
        c("House","Road", "Grass", "Trees","Water"), # puts text in the legend 
        pch=rep(15,5), # gives the legend appropriate symbols (lines)
        lwd=c(2.5,2.5),col=1:5)


