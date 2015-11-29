rm(list=ls())

edge.between <- function(g, members){
  e = 0
  for(i in 1:length(members)){
    for(j in i+1:length(members)){
      if(j > length(members)){
        next
      }
      if(are_adjacent(g, members[i], members[j])){
        e = e+1
      }
    }
  }
  e
}

delta_Q <- function(j, g, comm, i, nbs, m, k_i, total_inc){
  #t1 = Sys.time()
  members = which(comm == j)
  members <- append(members, i)
  k_in <- length(intersect(members, nbs))
  #cat("Indiviual : k_in" ,  length(members), " ", Sys.time() - t1, "\n")
  tot <- sum(total_inc[members])
  #tot <- sum(degree(g, v=members))
  #cat("Indiviual : tot" , Sys.time() - t1, "\n")
  delta_Q = k_in - (tot * k_i)/(m)
  #cat(" Node j = " ,j, ", k_i =",k_i, ", k_in = ",k_in ,", tot = ", tot ,", delta Q = ", delta_Q , "\n")
  #cat("Indiviual : Total" , Sys.time() - t1, "\n")
  delta_Q
}

delta.modularity <- function(i, g, comm, m, nbs, ncomm, total_inc){
  #t1 = Sys.time()
  #k_i <- sum(total_inc[i])
  k_i = degree(g, i)
  #cat("k_i : ", Sys.time() - t1, "\n")
  delta.vector = sapply(ncomm, delta_Q, g, comm, i, nbs, m, k_i, total_inc)
 # cat("Total" ,Sys.time() - t1, "\n")
  delta.vector
}    


get_louvian_community <- function(g){
  m = ecount(g)
  comm <- 1:vcount(g)
  total_inc <- rowSums(as.matrix(get.adjacency(g)))
  iter = 1
  while(TRUE){
    t1 = Sys.time()
    cat("Iteration = ", iter, "\n")
    changes = 0
    cat("Community Size =", length(unique(comm)), "\n")
    for(i in 1:vcount(g)){
      nbs <- neighbors(g, i)
      ncomm <- setdiff(unique(comm[nbs]) , comm[i])
  #   cat(" Node i = " , i , ", ncomm = ", length(ncomm) ,  "\n") 
      if(length(ncomm) == 0 ){
        next
      }
      delta.vector = delta.modularity(i, g, comm, m, nbs, ncomm, total_inc)
      if(is.null(delta.vector)){
        next
      }
      
      max <- max(delta.vector)
      if(!is.infinite(max) && max > 0){
        comm[i] <- ncomm[which.max(delta.vector)]
        changes  = changes + 1
      }
    }
    print(comm)
    cat(", changes = ",  changes, "\n")
    if(changes == 0){
      break;
    }
    iter <- iter + 1
    cat("Total" ,Sys.time() - t1, "\n")
  }
  return(comm)
}

# mat <- as.matrix(read.table("sample_graph1.txt", sep="\t", header=F))
# g <- graph.adjacency(mat)

cal <- read.csv("../facebook/data/Caltech36_adj.csv", header=F)
mat1 <- data.matrix(cal,rownames.force=NA)
g <- graph.adjacency(mat1)

g <- as.undirected(g)

comm <- get_louvian_community(g)
print(comm)
modularity(g, comm)
