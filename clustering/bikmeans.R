# Code for bisecting k means
bikmeans <- function(x=NULL, k=NULL, trials=3){

	# Updating clusters and subsetting the high SSE cluster for further bi-section
  updateClusters <- function(update, clust1, clust2, y){
    if(is.null(update$clusterlist)){
      clusterlist <- list(clust1, clust2)  
      update$x$cluster <- y$cluster
      update$clusterlist <- clusterlist
    }else{
      cl <- clust1[[1]]
      cc <- clust2[[1]]
      clusterlist <- update$clusterlist
      clusterlist[[cl]] <- clust1
      clusterlist[[cc]] <- clust2
      update$x[update$x$cluster == cl, ]$cluster <- y$cluster
      update$clusterlist <- clusterlist
    }
    max <- 0; indx <- 1
    for(i in 1:length(update$clusterlist )){
      iclust <- update$clusterlist [[i]]
      if(iclust[[2]] > max){
        max <- iclust[[2]]
        indx <- i
      }
    }
    clust <- update$clusterlist [indx][[1]]
    cl <- clust[[1]]
    y <- update$x[update$x$cluster == cl,] 
    update$cl <- cl
    update$y <- y[, -ncol(y)]
    update
  }

	# Summarizing the final output data with clusters,total SSE and centroids
  getFinalClusters <- function(update){
    result <- list()
    result$size <- table(update$x$cluster)
    for(i in 1:length(update$clusterlist)){
      iclust <- update$clusterlist[[i]]
      result$centers <- c(result$centers, as.vector(iclust[[3]]))
      result$withinsse <- c(result$withinsse, as.vector(iclust[[2]]))
    }
    result$clusters <- update$x$cluster
    result$totalSSE <- sum(result$withinsse) 
    result
  }
  
  x$cluster <- 1
  cl <- 1; cc = 1;
  y <- x[,-ncol(x)]
  update <- list()
  update$x <- x
  
  while(cc != k){
    results <- list()
    sse <- c()
    for( j in 1:trials){
        result <- mykmeans(y, 2, iterations=4)  
        results <- append(results, list(result))
        sse <- c(sse, result$totalSSE)
    }
    res <- results[[which.min(sse)]]
    clusters <- res$clusters
    clusters <- replace(clusters, clusters == 2, cc+1)
    clusters <- replace(clusters, clusters == 1, cl)
    res$clusters <- clusters
    y$cluster <- res$clusters
    clust1 <- list(cl, res$withinsse[1], res$centers[1])
    clust2 <- list(cc+1, res$withinsse[2], res$centers[2])
    update <- updateClusters(update, clust1, clust2, y)  
    y <- update$y
    cl <- update$cl
    cc <- cc+1	
  }
  result <- getFinalClusters(update)
  result
}



