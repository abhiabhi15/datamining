## SAC1 Algorithm

rm(list=ls())
library(igraph)
g <- read.graph(file= "../data/polblog/polblogs.gml", format=c("gml"))

##Similarity Matrix

table(vertex.attributes(g))

list.edge.attributes(g)
vcount(g)
