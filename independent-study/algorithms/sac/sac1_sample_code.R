## SAC1 Algorithm
rm(list=ls())
library(igraph)
library('proxy') # Library of similarity/dissimilarity measures for 'dist()'

#### SAC Helper Functions

similarity <- function(j, i, data){
    dist(data[c(i,j),], method="cosine")
}

sim.value <- function(j, data, comm, i){
    local_comm = comm[which(comm == j)]
    #local_comm = apply(data[local_comm,], 2, mean)
    sum(sapply(local_comm, similarity, i, data))/length(local_comm)
  # print(uu)
  # x = data[i,]
  # x = rbind(x, local_comm)              
  # dist(x, method="cosine")
}

mod.value <- function(j, g, comm, i){
  comm[i] <- j
  modularity(g, comm)
}

get_louvian_community <- function(g, data, alpha=0.5){

    comm <- 1:vcount(g)
    iter = 1
    csize = 0
    while(TRUE){
        cat("Iteration = ", iter, "\n")
        changes = 0
        org_mod = modularity(g, comm)
        if(iter > 15 && (csize == length(unique(comm)))){
            break;
        }
        csize = length(unique(comm))
        cat("Community Size =", csize)
        for(i in 1:vcount(g)){
            nbs <- neighbors(g, i)
            if(length(nbs) > 0){
                mod.vector = sapply(unique(comm[nbs]), mod.value , g, comm, i)
                delta.modularity = mod.vector - org_mod
                delta.similarity = sapply(unique(comm[nbs]), sim.value , data, comm, i)
                delta = alpha * delta.modularity + ((1 - alpha) * delta.similarity)
                max <- max(delta)
                if(!is.infinite(max) && max > 0){
                    ucomm <- unique(comm[nbs])
                    comm[i] <- ucomm[which.max(delta)]
                    changes <- changes + 1
                    #  cat("vertex = ", i , " max = " , max , "new comm = ", 
                    # ucomm[which.max(delta)] ,"\n");
                }  
            }
        }
    cat(", changes detected = ",  changes, "\n")
    cat("----------------------------------\n")
    if(changes == 0){
      break;
    }
    iter <- iter + 1
  }
  return(comm)
}

g <- read.graph(file="data/fb_caltech_small_edgelist.txt", format = c("edgelist"))

attrData <- read.csv("data/fb_caltech_small_attrlist.csv")
#attrData <- attrData[,1:34]
names(attrData)
t1 = Sys.time()
comm = get_louvian_community(g, data = attrData)
print(Sys.time() - t1)
