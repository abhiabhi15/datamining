## SAC1 Algorithm
rm(list=ls())
library(igraph)
source("algorithms/sac/helper.R")


g <- read.graph(file= "polblogs/data/polblogs.gml", format=c("gml"))

mat <- as.matrix(read.table("~/Desktop/check.txt", sep="\t", header=F))

g1 <- graph.adjacency(d1)
comm <- c(1,1,1,2,2,2,3,3,3,1)
modularity(g1, comm)
