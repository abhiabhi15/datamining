## SAC1 Algorithm
rm(list=ls())
library(igraph)
source("helper.R")

#### SAC Helper Functions
simFunc <- function(index, attrDF){
  ifelse(attrDF[1,index] == attrDF[2,index], 1,0)  
}

mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

commSimAttr <- function(i, data, comm, attrs){
  t1 = Sys.time()
  attrDF <- data[i,] 
  # Attributes of the majority value of community = cmIndex
  lcomm <- data[which(comm == comm[i]),]
  attrDF <- rbind(attrDF, apply(lcomm, 2, mode)) 
  print(Sys.time() - t1)  
  #Computing sum using 
  sum(sapply(1:length(attrs), simFunc, attrDF))/length(attrs)    

  stop()
}

similarity <- function(data, comm, attrs){
  data <- data[,attrs]
  sumSim <- sum(sapply(1:nrow(data), commSimAttr, data, comm, attrs))
  sumSim
}


mod.value <- function(j, g, comm, i, data, attrs){
  comm[i] <- j
  modularity(g, comm)
}

get_louvian_community <- function(g){
  
  data <- attrData
  attrs <- c("year","dorm","gender")
  
  comm <- 1:vcount(g)
  newComm <- comm
  iter = 1
  while(TRUE){
    cat("Iteration = ", iter, "\n")
    changes = 0
    org_mod = modularity(g, comm)
    print(unique(comm))
    for(i in 1:vcount(g)){
      mod.vector = sapply(unique(comm), mod.value , g, comm, i, data, attrs)
      delta_Q = mod.vector - org_mod
      max <- max(delta_Q)
      if(!is.infinite(max) && max > 0){
        ucomm <- unique(comm)
        newComm[i] <- ucomm[which.max(delta_Q)]
        changes <- changes + 1
        cat("vertex = ", i , " max = " , max , "new comm = ", ucomm[which.max(delta_Q)] ,"\n");
      }
      comm <- newComm
    }
    
    cat(", changes = ",  changes, "\n")
    if(changes == 0){
      break;
    }
    iter <- iter + 1
  }
  return(newComm)
}


#g <- read.graph(file= "../polblogs/data/polblogs.gml", format=c("gml"))

# mat <- as.matrix(read.table("sample_graph1.txt", sep="\t", header=F))
# g <- graph.adjacency(mat)

 cal <- read.csv("../facebook/data/Caltech36_adj.csv", header=F) 
 mat1 <- data.matrix(cal,rownames.force=NA)
 g <- graph.adjacency(mat1)
 attrData <- read.csv("../facebook/data/Caltech36.csv")

 data <- attrData
 attrs <- c("year","dorm","gender")
 
# t1 = Sys.time()
# similarity(data, 1:769, attrs)
# print(Sys.time() - t1)
# 
g <- as.undirected(g)
comm <- get_louvian_community(g)
print(comm)
modularity(g, comm)

#plot(g, vertex.color= comm)
# 
#similarity(data, comm, attrs)/nrow(data)
