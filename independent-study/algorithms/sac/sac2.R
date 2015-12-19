## SAC1 Algorithm
rm(list=ls())

library(igraph)
library('proxy') # Library of similarity/dissimilarity measures for 'dist()'
source("helper.R")

simScore <- function(j, data, g, i, alpha=0.5){
    (alpha *  ifelse(are_adjacent(g, i, j), 1, 0)) + round((1-alpha)*(dist(data[c(i,j),], method="cosine")), 3) 
}

g = read.graph("data/fb_caltech_small_edgelist.txt", format = "edgelist")
g = as.undirected(g)

data <- read.csv("data/fb_caltech_small_attrlist.csv")
set.seed(3)

mdegree = round(mean(degree(g)))
n = vcount(g)
g_k = matrix(0, nrow=n, ncol=n)
for(i in 1:n){
  knn = sapply(1:n, simScore, data, g, i)
  r = rank(knn, ties.method = c("random"))
  cols = which(r >= (n - mdegree))
  g_k[i, cols] = 1 
  cat("Graph Created for = ", i, "\n")
}

g <- graph.adjacency(g_k)
g <- as.undirected(g)

c5 <- multilevel.community(g)
cat("louvain method = ", modularity(c5) ,"\n")
