
getData <- function(filename){
  myData <- read.table(file=filename)
  myData
}

transform <- function(myData){
  colnames(myData) <- c("Degree", "Frequency")
  myData$Freq_Ratio <- myData$Frequency/sum(myData$Frequency)
  myData$Left_Limit <-  myData$Degree^-3
  myData$Right_Limit <-  myData$Degree^-2
  
  myData$Colour[myData$Freq_Ratio < myData$Right_Limit & myData$Freq_Ratio > myData$Left_Limit ] <- "red"
  myData$Colour[myData$Freq_Ratio > myData$Right_Limit] <- "blue"
  myData$Colour[myData$Freq_Ratio < myData$Left_Limit] <- "blue"
  
  myData
}

plotgraph <- function(graph){
  
  inputFile <- paste(graph, "txt", sep = ".")
  pngFileName <- paste(graph, "png", sep = ".")
  
  myData <- getData(inputFile)
  myData <- transform(myData)
  
  graph <- toupper(graph)
  main <- paste( "Degree Distribution :", graph , sep =" ")
  
  png(filename = pngFileName ,width = 480, height = 480, units = "px")
  plot(myData$Degree, myData$Frequency, log="xy", main=main, col=myData$Colour, xlab="Degree", ylab="Frequency", pch=19)
  legend("topright", c("Scale Free Degree Nodes", "Otherwise"), pch = c(19,19),col=c("red","blue"))
  rm(list=ls())
  dev.off()
}