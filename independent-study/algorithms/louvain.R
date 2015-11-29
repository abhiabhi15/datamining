rm(list=ls())

mod.value <- function(j, g, comm, i){
  comm[i] <- j
  modularity(g, comm)
}

get_louvian_community <- function(g){
  comm <- 1:vcount(g)
  iter = 1
  while(TRUE){
    cat("Iteration = ", iter, "\n")
    changes = 0
    org_mod = modularity(g, comm)
    cat("Community Size =", length(unique(comm)))
    for(i in 1:vcount(g)){
      nbs <- neighbors(g, i)
      if(length(nbs) > 0){
          mod.vector = sapply(unique(comm[nbs]), mod.value , g, comm, i)
          delta.modularity = mod.vector - org_mod
          max <- max(delta.modularity)
          if(!is.infinite(max) && max > 0){
              ucomm <- unique(comm[nbs])
              comm[i] <- ucomm[which.max(delta.modularity)]
              changes <- changes + 1
              #  cat("vertex = ", i , " max = " , max , "new comm = ", ucomm[which.max(delta.modularity)] ,"\n");
          }  
      }
    }
    cat(", changes = ",  changes, "\n")
    if(changes == 0){
      break;
    }
    iter <- iter + 1
  }
  return(comm)
}

#g = read.graph("../polblogs/data/polblogs.gml", format = "gml")

# mat <- as.matrix(read.table("sample_graph1.txt", sep="\t", header=F))
# g <- graph.adjacency(mat)

cal <- read.csv("../facebook/data/Caltech36_adj.csv", header=F)
mat1 <- data.matrix(cal,rownames.force=NA)
g <- graph.adjacency(mat1)
g <- as.undirected(g)

comm <- get_louvian_community(g)
print(comm)
modularity(g, comm)
