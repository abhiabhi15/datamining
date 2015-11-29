
comps <- decompose.graph(g)
g = comps[[1]]

rmIndex <- which(comm %in% c(111, 227, 231, 271, 381, 493, 499, 503, 506, 673))
gs = delete.vertices(g, rmIndex)
scomm <- get_louvian_community(gs)
print(scomm)
modularity(gs, scomm)
