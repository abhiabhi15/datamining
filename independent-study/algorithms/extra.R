rm(list=ls())
comps <- decompose.graph(g)
g = comps[[1]]


library(igraph)
g = read.graph("../polblogs/data/polblogs.gml", format = "gml")
list.vertex.attributes(g)
vertex_attr(g, "id")
attrDF$value <- as.data.frame(vertex_attr(g, "value"))
attrDF$value <- table(vertex_attr(g, "source"))

df <- read.csv(file="../polblogs/data/polblogs_columns.csv")
df$value = vertex_attr(g, "value")

dfs <- df[-rmIndex,]
write.csv(file="data/polblogs_small_attrlist.csv", dfss, row.names = F)


## Small Graphs
comps <- decompose.graph(g)
g = comps[[1]]
comm <- get_louvian_community(g)
table(comm)

rmIndex <- which(!comm %in% c(869, 835, 672, 782, 404, 111))
gs = delete.vertices(g, rmIndex)
scomm <- get_louvian_community(gs)
summary(gs)
write.graph(gs, file="data/polblogs_small_edgelits.txt", format="edgelist")
write.graph(g, file="data/fb_caltech_org_edgelist.txt", format="edgelist")

attrDFs <- as.data.frame(vertex_attr(gs, "value"))
dfss <- read.csv("../polblogs/data/polblogs_small_attr.csv")
dfss$value = vertex_attr(gs, "value")

## Small Caltech Graph
g <- read.graph(file="data/fb_caltech_org_edgelist.txt", format = "edgelist")
comm <- get_louvian_community(g)
table(comm)

rmIndex <- which(!comm %in% c(233, 388, 500, 702, 237, 710))

gs = delete.vertices(g, rmIndex)

scomm <- get_louvian_community(gs)
print(scomm)
modularity(gs, scomm)
write.graph(gs, file="data/fb_caltech_small_edgelist.txt", format="edgelist")

dim(d)
d <- d[-rmIndex,]
write.csv(d, file="data/fb_caltech_small_attrlist.csv", row.names = F)


attrs <- c("year","dorm","gender")

wss <- (nrow(x=sampleData)-1)*sum(apply(sampleData,2,var))
for (i in 1:60){
  wss[i] <- sum(kmeans(sampleData, centers=i)$withinss)
}

# Elbow Plot
plot(1:60, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")


attrData <- read.csv("../facebook/data/Caltech36.csv")
attrs <- c("year","dorm","gender","student_fac","major")
attrData <- attrData[, attrs]
attrData[,attrs] <- lapply(attrData[,attrs] , factor)
d = model.matrix(~ . + 0, data=attrData, contrasts.arg = lapply(attrData, contrasts, contrasts=FALSE))
write.csv(file="data/fb_caltech_org_attrlist.csv", d, row.names = F)


