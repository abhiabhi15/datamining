
transform <- function(fileName, graphName){
  myGraph <- read.table(fileName, skip=8)
  myGraph <- myGraph[,2:3]
  graphFile <- paste(graphName, "graph", sep=".")
  write.table(myGraph, graphFile, col.names=FALSE, row.names=FALSE)
}


