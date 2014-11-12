# Function to calculate distance vector
dist <- function(data, centroids){
   distVect <- c()
   for(i in  1:nrow(centroids)){ 
       distVect <- append(distVect, sqrt(sum((data-centroids[i,])^2)))
   }
   distVect 
}

mykmeans <- function(x=NULL, k=NULL, iterations=10){

  if(is.null(x) || is.null(k)){
    stop(" Either x or k is null")
  }

	# Sampling Data: Random centers
  sampling <- function(data, k){
    data[sample(nrow(data), k),]
  }
  
	# Compute the Total SSE of the clustering
  totSSE <- function(x, centroids){
    SSE <- function(x, centroid){ sum(dist(centroid, x)^2) }
    withinsse <- c()
    for(i in 1:nrow(centroids)){
      sub <- x[x$cluster == i,names(x) != "cluster"]
      withinsse <- c(withinsse, SSE(sub, centroids[i,]))
    }
    res <- list()
    res$total <- sum(withinsse)
    res$withinsse <- withinsse
    res
  }
  
	# Assignment function, which assign cluster label to its nearest centroid
  assign <- function(data, centroids){
      clusters <- c()
      for( i in 1:nrow(data)){
          dists <- dist(data[i,], centroids)
          cluster <- which.min(dists)
          clusters <- c(clusters, cluster)
      }
      clusters
  }
  
  centroids <- sampling(x, k)
  x$cluster <- assign(x, centroids)
  for( iter in 1:iterations){
      for(i in 1:k){
          sub <- x[x$cluster == i,names(x) != "cluster"]
          new_centroid <- t(as.matrix(colMeans(sub)))
          diff <- dist(new_centroid ,centroids[i,])
          if(diff > 0.00001){
              centroids[i,] <- new_centroid
          }
      }
    x$cluster <- assign(x[,1:2], centroids)  
  }
  sse <- totSSE(x, centroids)
  res <- list()
  res$size <- table(x$cluster)
  res$centers <- centroids
  res$clusters <- x$cluster
  res$withinsse <- sse$withinsse 
  res$totalSSE <- sse$total 
  res
}

