## SAC1 Algorithm
rm(list=ls())
library(igraph)
library('proxy') # Library of similarity/dissimilarity measures for 'dist()'
source("helper.R")

#### SAC Helper Functions

similarity <- function(j, i, data){
    as.numeric(dist(data[c(i,j),], method="cosine")) 
}

sim.value <- function(j, data, i, comm){
    local_comm = comm[which(comm == j)]
    sum(sapply(local_comm, similarity, i, data))
}

get_louvian_community <- function(g, data){
  comm <- 1:vcount(g)
  iter = 1
  while(TRUE){
    cat("Iteration = ", iter, "\n")
    changes = 0
    #org_mod = modularity(g, comm)
    cat("Community Size =", length(unique(comm)), "\n")
    for(i in 1:vcount(g)){
      nbs <- neighbors(g, i)
      if(length(nbs) > 0){
        delta.similarity = sapply(unique(comm[nbs]), sim.value , data, i, comm)
        print(delta.similarity)
        max <- max(delta.similarity)
        if(!is.infinite(max) && max > 0){
          ucomm <- unique(comm[nbs])
          comm[i] <- ucomm[which.max(delta.similarity)]
          changes <- changes + 1
          cat("vertex = ", i , ", max = " , max , ", new comm = ", ucomm[which.max(delta.similarity)] ,"\n");
        }  
      }
    }
    print(comm)
    cat(", changes = ",  changes, "\n")
    if(changes == 0){
      break;
    }
    iter <- iter + 1
  }
  return(comm)
}


# mat <- as.matrix(read.table("sample_graph1.txt", sep="\t", header=F))
# g <- graph.adjacency(mat)

cal <- read.csv("../facebook/data/Caltech36_adj.csv", header=F)
mat1 <- data.matrix(cal,rownames.force=NA)
g <- graph.adjacency(mat1)

comps <- decompose.graph(g)

attrData <- read.csv("../facebook/data/Caltech36.csv")
attrs <- c("year","dorm","gender","student_fac","major")
attrData <- attrData[, attrs]
attrData[,attrs] <- lapply(attrData[,attrs] , factor)
d = model.matrix(~ . + 0, data=attrData, contrasts.arg = lapply(attrData, contrasts, contrasts=FALSE))
 
t1 = Sys.time()
get_louvian_community(g, d)
print(Sys.time() - t1)
 
# g <- as.undirected(g)
# comm <- get_louvian_community(g)
# print(comm)
# modularity(g, comm)
