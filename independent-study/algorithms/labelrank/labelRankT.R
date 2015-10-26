# LabelRank Algorithm :  Graph Community Detection
# Author : Abhishek Agrawal


rm(list=ls())
library(igraph)
library(hash)

## Helper Functions ###

getGraphX <- function(x){
    x <- read.table(x)         # Reading graph from the directory
    gv <- x[1,1]           				 # Fetching the vertex count	
    ge <- x[2:nrow(x),] + 1		 # Adding 1 to move vertex id, because of 0 vertex-id
    G <- graph.empty() + vertices(1:gv)
    G <- add.edges(G, t(ge))
    G <- as.undirected(G)      # making the graph undirected
    G[from=V(G), to=V(G)] <- 1 # Adding self loop
    G
}

getGraph <- function(x){ 
    x <- read.table(x, sep="\t")         # Reading graph from the edge list
    vcount <- 84       					 # vertex count	
    ge <- x		 
    G <- graph.empty() + vertices(1:vcount)
    G <- add.edges(G, t(ge))
    G[from=V(G), to=V(G)] <- 1 # Adding self loop
    E(G)$weight = runif(nrow(ge), min=0.1, max =0.9)
    G
}

cutoff <- function(x, phi=0.1){
    if(is.nan(x) || x < phi){
        return(0)
    }else{
        return(x)
    }
}

checkTime <- function(t){
    print(Sys.time() - t)
}


graph <- getGraph("data/social/graph.txt")
plot(graph, edge.label=round(E(graph)$weight,3))

W <- get.adjacency(graph, attr="weight")

v <- vcount(graph)

## Initializing Label Distribution Matrix
P <- matrix(0, nrow=v, ncol=v)
for(node in 1:v){
    nbs <- unique(neighbors(graph, node))
    sumW <- sum(W[node, nbs])
    P[node, nbs] <- W[node, nbs]/sumW    ## Node Degree Distribution
}

## Repeat Until Stopping Criterion NOT SATISFIED
# Parameters :
# inflation parameter : infl = 2
# Cutoff Parameter : phi = 0.1
# Conditional Update Parameter q = 0.6
# Stopping Criterion Threshold thr = 5

    
    ## Step1 - Propagation
    t1 = Sys.time()
    #    P1 = A %*% P
    
    P1 = P
    for(i in 1:v){
        C <- which(P[i,] > 0) 
        nbs <- unique(neighbors(graph, i))
        wk = sum(P[i, nbs])
        for(c in C){
            P1[i, c] <-  sum(P[nbs, c] * P[i, nbs])/wk    ## Node Degree Distribution
        }
    }
    
    ## Step2 - Inflation in=2
    infl = 2
    P2 = P1 ^ infl
    P2 = P2 / rowSums(P2)
    
    t3 = Sys.time()
    
    ## Step 3 - Cutoff
    for(i in 1:v){
        C <- which(P[i,] > 0) 
        P2[i,C] = sapply(P2[i,C] , cutoff)
    }
    
    checkTime(t3)
    t4 = Sys.time()
    
    ## Step 4 - Conditional Update
    q = 0.6
    numChange <- 0  ## Label Change Counter
    
    P3 = P
    for(i in 1:v){
        nbs <- unique(neighbors(graph, i))
        s1 <- which(P[i,] == max(P[i,]))
        cum <- 0
        for(j in nbs){
            s2 <- which(P[j,] == max(P[j,]))
            cum = cum + ifelse((length(setdiff(s1, s2)) > 0), 0, 1 )
        }
        if(ifelse((cum <= (length(nbs) * q)), TRUE, FALSE)){ 
            P3[i,] <- P2[i,]    
            numChange = numChange + 1
        }
    }
    P = P3
    checkTime(t4)
    
