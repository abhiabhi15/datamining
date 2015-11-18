## SAC1 Algorithm
rm(list=ls())
library(igraph)
source("algorithms/sac/helper.R")

g <- read.graph(file= "polblogs/data/polblogs.gml", format=c("gml"))

mat <- as.matrix(read.table("algorithms/sample_graph1.txt", sep="\t", header=F))
rownames(mat) <- 1:10
colnames(mat) <- 1:10
g1 <- graph.adjacency(mat)
g1 = as.undirected(g1)
plot(g1)

## Checking graphs for comm detect algos
compareModularity(g1)

cal <- read.csv("~/pycharm-4.0.5//bin/Caltech36_adj.csv", header=F) 
dim(cal)
mat1 <- data.matrix(cal,rownames.force=NA)
g2 <- graph.adjacency(mat1)
g2 <- as.undirected(g2)
compareModularity(g2)
