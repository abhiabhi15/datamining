#### NetSimile #################

#  Algo-1 Feature Extraction
#  Algo-2 Feature Aggregation
#  Algo-3 Graph Comparison
#
#  @author : abhishek
#  @unityid : akagrawa
#  
#	 Note : Please refer README.md file for the code usage

rm(list=ls())
library(gtools) 
library(sna)
library(igraph)
library(e1071)

## Generating igraph instances from individual graph files
getGraph <- function(x){ 
  x <- read.table(x)         # Reading graph from the directory
  if(x[1,2] <= 0){           # Checking for empty edges
      return()
  }
  gv <- x[1,1]   						 # Fetching the vertex count	
  ge <- x[2:nrow(x),] + 1    # Adding 1 to move vertex id, because of 0 vertex-id
  g <- graph.empty() + vertices(1:gv)
  g <- add.edges(g, t(ge))
  g <- as.undirected(g)      # making the graph undirected
  g
}

## Algo 2 Extracting features from the graph
featExt <- function(graph){
    G <- graph
    A <- as.matrix(get.adjacency(G))
    v <- vcount(G)
    FM <- matrix(0, nrow=v, ncol=7) # Feature Matrix
    for(node in 1:v){
        #1) Degree: No of neighbours
        neighbours <- neighbors(G, node)
        FM[node,1] <- length(neighbours)
        
        #2) Clustering cofficient 
        FM[node,2] <- transitivity(G, type=c("local"), vids=node, isolates=c("zero"))
        
        #3) average number of node i's two hop away distance neighbours
        nsize <- neighborhood.size(G, order=1, nodes=neighbours)
        if(length(nsize) > 0){
            FM[node,3] <- mean(nsize)
        }else{
            FM[node,3] <- 0  # Replacing NaN with 0
        }

        # 4 average clustering cofficient of neighbours
        avgNC <- transitivity(G, type=c("local"), vids=neighbours, isolates=c("zero"))
        if(length(avgNC) > 0 ){
            FM[node,4] <- mean(avgNC)
        }else{
            FM[node,4] <- 0  # Replacing NaN with 0
        }
        
        # 5 No of edges in ego(i)
        FM[node,5] <- sapply(ego.extract(A, ego=node),sum)/2
        
        # 6 No of outgoing edges from ego(i)
        egoNetwork <- neighborhood(G, nodes=node, order=1)[[1]]
        allNeighbours <- unlist(neighborhood(G, order=1, nodes = egoNetwork))
        FM[node,6] <- length(allNeighbours[!allNeighbours %in% egoNetwork])
        
        # No of neighbours of ego(i)
        FM[node,7] <- sum(sapply(neighborhood(G, order=1, nodes=egoNetwork), length)) - length(egoNetwork)
    }
    FM
}

## Algo 3 Features Aggregation : Generating Signature Vectors 

featAggr <- function(FM){
    sig <- c()
    sig <- append(sig, apply(FM,2, median))    # Median of each feature
    sig <- append(sig, apply(FM,2, mean))      # Mean of each feature
    sig <- append(sig, apply(FM,2, sd))        # Standard Deviation of each feature
    sig <- append(sig, apply(FM,2, skewness, na.rm=T))  # Skewness of each feature
    sig <- append(sig, apply(FM,2, kurtosis, na.rm=T))  # Kurtosis of each feature
    sig
}
  
##### Algo 1: NetSimile, computing similarity scores between pair of graphs

netsimile <- function(directory, graphName){
    if(is.null(directory)){ 
        stop("Directory for graph files cannot be null")
    }
    fileNames <- mixedsort(list.files(directory)) # Performing file sort with respect to numeric digits in filename
    sigVectors <- list()
    for(i in 1:length(fileNames)){
        file <- paste(directory, fileNames[i], sep="/")
        if(file.exists(file)){
              graph <- getGraph(file)             # Generating igraph instance
              if(is.null(graph)){  next } 
              features <- featExt(graph)          # Extracting feature matrix (Algo1)
              sigVectors <- append(sigVectors, list(featAggr(features)))  # Aggregation (Algo2)
              cat("  Signature Vector computed for file :", file, "\n")  
        }
    }
    cat("  Signature Vectors for the graphs has been calculated \n")
    
    # Computing Distance measure as scores using canberra distance between adjacent 
    scores <- c()
    for(j in 1:length(sigVectors)){
        if((j+1) <= length(sigVectors)){
              scores <- append(scores, dist(rbind(sigVectors[[j]], sigVectors[[j+1]]), method="canberra"))        
        }
    }
    
    # Computinh moving range average and upper threshold
    MRs <- abs(diff(scores))
    mravg <- mean(MRs)
    med <- median(MRs)
    upThr <- med + 3 * mravg
    
    scores <- as.data.frame(scores)
    scores$color[scores[,1] >= upThr] <- 2 # Anomaly Points [Red Points]
    scores$color[scores[,1] < upThr] <- 4  # Not Anomaly Points [Blue Points]

    # Plotting similarity scores in time sequence, without any pruning
    main <- paste("Anamoly Detection : Time Series Plot ", graphName, sep="- ")
    plot(scores[,1], col=scores[,2], pch=20, ylab="Distance Scores[Canberra]", xlab="Time Sequence Graph", main=main)    
    abline(h=upThr)
    line  <- paste("Threshold = ", round(upThr,2), sep="")
    text(x=0.25 * nrow(scores), y=upThr + 2 , line, col=2)
    
    anomalies <- which(scores$color == 2)
    # To extract middle graph which anomalous in three adjacent graphs, if any.
    diff_points <- which(diff(anomalies) == 1)
    if(length(diff_points) > 0){
        anomalies <- anomalies[-(diff_points)]
    }
    
    # Storing anomalies in output file
    output <- list()
    output$total = length(anomalies)
    output$anomalies <- cbind(anomalies, cbind(fileNames[anomalies+1], fileNames[anomalies+2]))
    cat("\n --- Anomalies Output --- \n")
    
    print(output)
    output_file <- paste(paste("output_anomaly", graphName, sep="_"),"txt", sep=".")
    write.table(output$total, file=output_file, append=TRUE, row.names=F, col.names=F)
    write.table(output$anomalies, file=output_file, append=TRUE, row.names=F, col.names=F)
}  


## Calling netsimile with graph files directory and graph name as arguments
netsimile("datasets/enron_noempty", "enron-nonempty")

