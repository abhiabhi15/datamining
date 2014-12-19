rm(list=ls())
library(igraph)
# Function for creating graph
getGraph <- function(){ 
    data <- c(0,1, 0,3, 1,4, 2,3, 2,6, 5,6, 5,7, 6,7, 7,9, 8,9)
    data <- matrix( data, nrow=10, ncol=2)
    ge <- data + 1    # Adding 1 to move vertex id, because of 0 vertex-id
    g <- graph.empty() + vertices(1:10)
    g <- add.edges(g, ge)
    g <- as.undirected(g)      # making the graph undirected
    g
}

epidemicThr <- function(graph, beta, delta){
    ev <- graph.eigen(graph, which=list(pos="LA", howmany=1))$values #Getting the largest eigen value given a graph
    ev * (beta/delta)          # Epidemic Threshold
}

checkVal <- function(s){
  cat("--- Epidemic Threshold : ", s, " ---- \n")
  if( s >= 1 ){          # Condition over epidemic threshold
    cat("Epidemic Threshold reached.. Virus will result in an epidemic \n")
  }else{
    cat("Epidemic Threshold not reached.. Virus will die quickly")
  }
}


g <- getGraph()
plot(g)
sr <- graph.eigen(g, which=list(pos="LA", howmany=1))$values
cat("Spectral Radius : ", sr)
s <- epidemicThr(g, beta=0.3, delta=0.5)
cat("Effective Strength of the virus : ", s)

checkVal(s)

#Netshield Algorithm 
lambda <- sr
u1 <- graph.eigen(g, which=list(pos="LA", howmany=1))$vectors 
A <- as.matrix(get.adjacency(g))

shieldScore <- function(j){
    (2 * lambda - A[j,j]) * (u1[j])^2
}

V <- sapply(1:vcount(g), shieldScore)
S <- c()
calb <- function(S) {
   b <- rep(0, vcount(g))
   if(length(S) == 0){
      return(b)
   }
   b <- A[,S] %*% as.matrix(u1[S])
}

for(iter in 1:5){
    b <- calb(S)
    scores <- rep(0, vcount(g))
    for(j in 1:vcount(g)){
        if(j %in% S){
            scores[j] <- -1 
        }else{
            scores[j] <- V[j] - (2 * b[j] * u1[j])    
        }
    } 
    i <- which.max(scores)
    cat(scores, "\n")
    S <- append(S, i)
}
cat("Nodes to be immunized => ", S)

## Deleting vertices
newg <- delete.vertices(g, S)
s1 <- epidemicThr(newg,  beta=0.3, delta=0.5)
checkVal(s1)


