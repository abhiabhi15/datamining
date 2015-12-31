
# Input : Get Community and graph as input
# Propagation Ration or Influenced nodes
# For each comm -> Select a random node
#
msgPropagation <- function(graph, comm, beta=0.7){
    #graph = g
    v = vcount(graph)
    #comm = km$cluster
    avg_inf = c()    
    for(iter in 1:1){
        nodes <- data.frame(1:v)
        colnames(nodes) <- c("Id")
        nodes$comm = comm
        nodes$color = "green"
        
        influencers =c()
        for(k in unique(comm)){
            influencer = sample(nodes[which(nodes$comm %in% k), c("Id")],1)
            influencers = append(influencers, influencer)           
        }
        nodes[nodes$Id %in% influencers, c("color")] <- "red"
        count =1        
        total_influencers = length(influencers)
        for(i in influencers){
          candidates <- nodes[nodes$comm == nodes[i, c("comm")] & nodes$color == "green", c("Id")]
          ids <- c()
          for(j in candidates){
              if(sample(1:100, 1) <= beta * 100){     # Stochastically determing if node will get infected, using beta transmission probability
                  ids <- append(ids, j)
              }  
          }
          nodes[which(nodes$Id %in% ids), c("color")] <- "red" 
          tot_influencers = nrow(nodes[nodes$color == "red",])
          cat("Count = ", count , " ,Influenced Nodes Proportion : ", tot_influencers/v , "Influenced Nodes = " , tot_influencers , "\n")
          count = count+1
        }
        
        ratio = nrow(nodes[nodes$color == "red",])/v
        #cat("Influenced Nodes Proportion : ", ratio , "\n")
        avg_inf <- append(avg_inf, ratio)
    }
    mean(avg_inf)
}

print(msgPropagation(graph=g, comm = kk$cluster, beta = 0.85))
print(msgPropagation(graph=g, comm = comm, beta = 1))
