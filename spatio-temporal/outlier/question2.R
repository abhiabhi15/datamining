rm(list=ls())
source("installDependencies.R")
source("gaussian.R")
library(caret)

trainData <- read.csv("ilk-tr-d.csv")
testData <- read.csv("ilk-te-d.csv")
trainData$CL <- as.factor(trainData$CL)
testData$CL <- as.factor(testData$CL)
names(trainData)

## Q 2 a)MLC (Maximum Likelihood Classification)

model <- gaussian(data=trainData, label=4)
pred <- predictGauss(model, newdata=testData[,-c(4)], method="discriminant", 
                     classification="mlc")
table(as.numeric(pred), as.numeric(testData$CL))
confusionMatrix(pred, testData$CL)

allData <- rbind(testData, trainData)
pred <- predictGauss(model, newdata=allData[,-c(4)], method="discriminant", 
                     classification="mlc")
confusionMatrix(pred, allData$CL)

## Q2 b) Naive Bayesian
library(e1071)
model <- naiveBayes(CL ~ ., data = trainData)
pred <- predict(object = model, newdata = testData[,-c(4)])  
table(as.numeric(pred), as.numeric(testData$CL))
confusionMatrix(pred, testData$CL)

allData <- rbind(testData, trainData)
pred <- predict(object = model, newdata = allData[,-c(4)])  
confusionMatrix(pred, allData$CL)

## Q2 c) MAP (Maximum Apriori Classification)

model <- gaussian(data=trainData, label=4)
pred <- predictGauss(model, newdata=testData[,-c(4)], method="discriminant", 
                     classification="map")
table(as.numeric(pred), as.numeric(testData$CL))
confusionMatrix(pred, testData$CL)

allData <- rbind(testData, trainData)
pred <- predictGauss(model, newdata=allData[,-c(4)], method="discriminant", 
                     classification="map")
confusionMatrix(pred, allData$CL)





