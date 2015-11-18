## SAC1 Algorithm
rm(list=ls())
library(igraph)
source("helper.R")

#g <- read.graph(file= "../polblogs/data/polblogs.gml", format=c("gml"))

#mat <- as.matrix(read.table("sample_graph1.txt", sep="\t", header=F))
#g <- graph.adjacency(mat)

cal <- read.csv("../facebook/data/Caltech36_adj.csv", header=F) 
mat1 <- data.matrix(cal,rownames.force=NA)
g <- graph.adjacency(mat1)

g <- as.undirected(g)
comm <- get_louvian_community(g)
modularity(g, comm)

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

