rm(list=ls())
library(igraph)

## Generating igraph instances from individual graph files
getGraph <- function(x){ 
    x <- read.table(x)         # Reading graph from the directory
    if(x[1,2] <= 0){           # Checking for empty edges
       return()
    }
    gv <- x[1,1]     					 # Fetching the vertex count	
    ge <- x[2:nrow(x),] + 1    # Adding 1 to move vertex id, because of 0 vertex-id
    g <- graph.empty() + vertices(1:gv)
    g <- add.edges(g, t(ge))
    g <- as.undirected(g)      # making the graph undirected
    g
}

## Check for epidemic threshold
checkVal <- function(s){
    cat("--- Epidemic Threshold : ", s, " ---- \n")
    if( s >= 1 ){          # Condition over epidemic threshold
        cat("Epidemic Threshold reached.. Virus will result in an epidemic \n")
    }else{
        cat("Epidemic Threshold not reached.. Virus will die quickly")
    }
}

# Function to calculate epidemic threshold
epidemicThr <- function(graph, beta, delta){
    ev <- graph.eigen(graph, which=list(pos="LA", howmany=1))$values #Getting the largest eigen value given a graph
    ev * (beta/delta)          # Epidemic Threshold
}

# Function for spreading the virus(Virus Propagation)
spreadVirus <- function(graph, beta, delta, simulations=1, iterations=10, detail=F){
    # Internal simulation function for a single simulation
    simulation <- function(graph, beta, delta, iterations, detail=F){
        v <- vcount(graph)
        c <- ceiling(v/10)
        if(detail){ ## If detail flag is true, we can observe the virus propagation at each time tick
            plot(x=0, c, main="Virus Propagation", type="b", col="red", pch = 20, xlab="Iterations", ylab=" No. of Infected Nodes", xlim=c(1,iterations), ylim=c(0,1500))     
            legend("topleft", c(" No. of Infected Nodes", " No. of Healed Nodes "), pch = c(20,20),col=c("red","green"))
        }
        nodes <- data.frame(1:v)
        colnames(nodes) <- c("Id")
        infected <- sample(1:v, c) # Sampling the random c nodes as infected
        nodes$Color <- "green"     # Assiginig the green color to suspectibles  
        nodes[nodes$Id %in% infected, 2] <- "red" # Assiginig the red color to all infected ones
        avg_inf <- c(length(infected))  # Capturing infected nodes
        for(iter in 1:iterations){
          for(i in 1:length(infected)){
            node <- infected[i]
            neighbours <- neighbors(graph, node)
            if(length(neighbours) == 0){ # If no neighbours are found, continuing for the next infected node
                next
            }
            susceptibles <- nodes[nodes$Id %in% neighbours & nodes$Color == "green", 1]
            ids <- c()
            for(i in 1:length(susceptibles)){
              if(sample(1:100, 1) <= beta * 100){     # Stochastically determing if node will get infected, using beta transmission probability
                  ids <- append(ids, susceptibles[i])
              }  
            }
            nodes[which(nodes$Id %in% ids), 2] <- "red"
          }
          infected <- nodes[which(nodes$Color == "red"), 1]
          avg_inf <- append(avg_inf, length(infected))
          if(detail){
              cat("After Infection  : ", length(infected) , " |  ")
              points(x=iter, length(infected), col="red", pch=20)    
          }
          
          ## Healing process
          healed <- c()
          if(length(infected) > 0 ){
            for(i in 1:length(infected)){
              if(sample(1:100, 1) <= delta * 100){ # Stochastically determing if node will heal, using delta as healing probability
                  healed <- append(healed, infected[i])  
              }
            }  
          }
          nodes[which(nodes$Id %in% healed), 2] <- "green"
          infected <- nodes[which(nodes$Color == "red"), 1]
          if(detail){
              cat("Healed :", length(healed), " | ")
              cat("Still Infected :", length(infected), "\n")
              points(iter, length(healed), col="green", pch=20, type="b")  
          }
          if(length(infected) == 0){ # If no infected people are left, returning the average infected nodes
              if(length(avg_inf) < iterations){
                  avg_inf <- append(avg_inf, rep(0, iterations-length(avg_inf)))
              }
              return(avg_inf/v)
          }
        }
        avg_inf/v     # Fraction of  infected nodes for each time tick
    }
  
  ## Final Simulations : The below code will collect all the simulation data and plot the results
  # In log-log scale
  simMatrix <- c()
  for(sim in 1:simulations){
      infs <- simulation(graph=graph, beta=beta, delta=delta, iterations=iterations, detail=F)
      simMatrix <- rbind(simMatrix, infs)
  }
  # Plot for simulations in log-log scale
  xval <- colMeans(simMatrix) 
  plot(colMeans(simMatrix), pch=20, yaxt="n",xlab="Time ticks", log="xy", ylab="Fraction of Infected Nodes",col="red", type="b", main="SIS Infected Log-Log", ylim=c(10^-4, 1)) 
  aty <- axTicks(2)
  labVals <- seq(0,-4,-0.5)[1:length(aty)]
  labels <- sapply(labVals,function(i) as.expression(bquote(10^ .(i))))
  axis(2,at=aty,labels=rev(labels))
  legendText1 <- paste("Beta", beta, sep=" : ")
  legendText2 <- paste("Delta", delta, sep=" : ")
  legend("topright", c( legendText1, legendText2))
}

# Function for applying different immunization policy
immunization <- function(graph, policy=c("A","B","C","D"), beta, delta, k, only.graph=F){
    switch(policy,
         A = {
           pAgraph <- graph
           immuNodes <- sample(vcount(pAgraph), k) # Selecting k random nodes for immunization
           pAgraph <- delete.vertices(pAgraph, immuNodes)
           if(only.graph){return(pAgraph)}
           s <- epidemicThr(pAgraph, beta, delta)
           return(s)
         },
         B = {
           pBgraph <- graph
           immuNodes <- head(order(degree(pBgraph, loops=F), decreasing=T), k) #Select the k nodes with highest degree for immunization.
           pBgraph <- delete.vertices(pBgraph, immuNodes)
           if(only.graph){return(pBgraph)}
           s <- epidemicThr(pBgraph, beta, delta)
           return(s)
         },
         C = {
           pCgraph <- graph
           for(i in 1:k){  #Select the node with the highest degree for immunization. Remove this node (and its incident edges) from the contact network. Repeat until all vaccines are administered.
             immuNode <- which.max(degree(pCgraph)) 
             pCgraph <- delete.vertices(pCgraph, immuNode)
           }
           if(only.graph){return(pCgraph)}
           s <- epidemicThr(pCgraph, beta, delta)
           return(s)
         },
         D = {
           pDgraph <- graph
           vect <- graph.eigen(g, which=list(pos="LA", howmany=1))$vectors 
           immuNodes <- head(order(abs(vect), decreasing=T), k)  # Removal of k nodes corresponding k largest eigen vectors
           pDgraph <- delete.vertices(pDgraph, immuNodes)
           if(only.graph){return(pDgraph)}
           s <- epidemicThr(pDgraph, beta, delta)
           return(s)
         }
  )
}

# Function to estimate the optimal number of vaccines
optimalVaccine <- function(graph, policy=c("A","B","C","D"), beta, delta, k, increment=20, plot=T){
    eths <- c()
    vaccines <- c()
    s <- 100;
    while(s >= 1){ # Incrementing the number of vaccines till the epidemic threshold comes below 1
        s <- immunization(graph, policy=policy, beta=beta, delta=delta, k=k)
        vaccines <- append(vaccines, k)
        eths <- append(eths, s)
        #cat("s :" , s , " vaccines : " , k, "\n")
        k <- k + increment
        
    }
    # Ploting number of vaccines against epidemic threshold 
    if(plot){
        plot( x=vaccines, y=eths, pch=20, xlab="K Nodes Removal", type="b",ylab="Epidemic Threshold", col=6, main=paste("Finding optimal Vaccine : Policy ", policy))  
    }
    cat("Vaccines Needed", k)
    k
}


