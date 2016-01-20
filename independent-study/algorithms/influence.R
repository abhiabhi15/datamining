library(igraph)

## Influence Propagation
# Arguments:
# Graph = Initial Graph
# Comm  = Communiity/Clusters
# Beta = Influence Propagation Rate
influence_propagation <- function(graph, comm, beta=0.5){
    v = vcount(graph)
    nodes <- data.frame(1:v)
    colnames(nodes) <- c("Id")
    nodes$comm = comm
    nodes$color = "green"
        
    influencers = c()
    for(k in unique(comm)){
        influencer = sample(nodes[which(nodes$comm %in% k), c("Id")],1)
        influencers = append(influencers, influencer)           
    }
    
    nodes[nodes$Id %in% influencers, c("color")] <- "red"
    new_influencers = influencers
    total_influencers = length(influencers)
        
    timestep = 1
    old_influencers = 0
    ratio = total_influencers/v
    
    cat("Time Step = " , timestep,", Total Influencers = ", total_influencers, ", Network Coverage = " , ratio ,"\n")
    timestep = timestep + 1

        while(total_influencers - old_influencers > 0 && ratio < 1){
        old_influencers = total_influencers
        influencers = new_influencers
        for(i in influencers){
          candidates <- nodes[nodes$comm == nodes[i, c("comm")] & nodes$color == "green", c("Id")]
          ids <- c()
          for(j in candidates){
              if(sample(1:100, 1) <= beta * 100){     # Stochastically determing if node will get infected, using beta transmission probability
                  ids <- append(ids, j)
              }  
          }
          nodes[which(nodes$Id %in% ids), c("color")] <- "red" 
          total_influencers = nrow(nodes[nodes$color == "red",])
          new_influencers = append(new_influencers, unique(ids))
        }  
        ratio = nrow(nodes[nodes$color == "red",])/v
        cat("Time Step = " ,timestep,", Total Influencers = ", total_influencers, ", Network Coverage = ", ratio ,"\n")
        timestep = timestep + 1
      }
}

## Influence Propagation Example

# ===== Reading the graph ====== #
g <- read.graph(file="data/fb_caltech_small_edgelist.txt", format = c("edgelist"))

# ===== Clusters From Adaptive K-means ===== #
 attrData <- read.csv("data/fb_caltech_small_attrlist.csv")
 #install.packages("akmeans")
 library("akmeans")
 akm = akmeans(attrData, d.metric=2, ths3=0.8, mode=3) ## cosine distance based

# ===== Influence Propagation Using adaptive k-means clusters ===== #
 influence_propagation(graph=g, comm = akm$cluster)

# ===== Influence Propagation Using SAC-1 communities  ===== #
 #comm = # Vector representing your SAC-1 communities for all the nodes in the graph 
 influence_propagation(graph=g, comm = comm)
