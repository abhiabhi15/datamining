
getSimAttrMatrix <- function(attrvalue){
  sim <- matrix(0, nrow=vcount(g), ncol=vcount(g))
  for(i in 1:vcount(g)){
    sim[i,] <- ifelse(attrValue[i] == attrValue, 1,0)  
  }
  return(sim)  
}

## Compare Modularity of different Community Detection Algos
compareModularity <- function(g){
  cat("Modularity Comparison of Graph : #Nodes = ", vcount(g) , " #Edges = ", ecount(g), "\n")
      #c1 <- edge.betweenness.community(g)
      #cat("Edge Betweenness = ", modularity(c1) ,"\n")
      
      c2 <- fastgreedy.community(g)
      cat("fastgreedy = ", modularity(c2) ,"\n")
      
      c3 <- label.propagation.community(g)
      cat("label.propagation = ", modularity(c3) ,"\n")
      
      #c4 <- leading.eigenvector.community(g)
      #cat("leading.eigenvector = ", modularity(c4) ,"\n")
      
      c5 <- multilevel.community(g)
      cat("louvain method = ", modularity(c5) ,"\n")
      
      #c6 <- optimal.community(g)
      #cat("optimal.community = ", modularity(c6) ,"\n")
      
      #c7 <-spinglass.community(g)
      #cat("spinglass.community = ", modularity(c7) ,"\n")
      
      c8 <-walktrap.community(g)
      cat("walktrap.community = ", modularity(c8) ,"\n")
}

mod.value <- function(j, g, comm, i){
  comm[i] <- j
  modularity(g, comm)
}

get_louvian_community <- function(g){
  
  comm <- 1:vcount(g)
  newComm <- comm
  iter = 1
  while(TRUE){
    cat("Iteration = ", iter)
    changes = 0
    for(i in 1:vcount(g)){
      org_mod = modularity(g, comm)
      nbs <- unique(neighbors(g, i))
      mod.vector = sapply(nbs, mod.value , g, comm, i)
      delta_Q = mod.vector - org_mod
      max <- max(delta_Q)
      if(!is.infinite(max) && max > 0){
          newComm[i] <- nbs[which.max(delta_Q)]  
          changes <- changes + 1
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
