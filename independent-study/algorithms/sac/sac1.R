## SAC1 Algorithm
rm(list=ls())
library(igraph)
source("algorithms/sac/helper.R")

g <- read.graph(file= "polblogs/data/polblogs.gml", format=c("gml"))

mat <- as.matrix(read.table("~/Desktop/check.txt", sep="\t", header=F))
g <- graph.adjacency(mat)
comm <- 1:vcount(g)

##Similarity Matrix
#attrValue <- vertex_attr(g, "value") 
actualComm <- comm

mod.value <- function(j, g, comm, i){
  comm[i] <- comm[j]
  modularity(g, comm)
}

for(i in 1:vcount(g)){
    org_mod = modularity(g, comm)
    mod.vector <- sapply(1:vcount(g), mod.value , g, comm, i)
    
    delta_Q = mod.vector - org_mod
    cat("replacing community for node = ", i, "\n")
    cat( "Max dQ " , max(delta_Q), "\n")
    if(max(delta_Q) > 0){
      actualComm[i] <- which.max(delta_Q)  
      cat( "Max Pos dQ " , actualComm[i], "\n")
    }
}
print(actualComm)


# simAttr <- getSimAttrMatrix(attrValue)
# list.vertex.attributes(g)
# vertex_attr(g, "value") 
# vertex_attr(g, "label")
# table(vertex_attr(g, "source"))
# 
# structSim <- function(){
#   m = ecount(g)
#   (1/2*m ) mod.matrix(g)
#   modularity(g)
# }

