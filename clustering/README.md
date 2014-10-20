## Bisecting K-means

 Language : `R`
 
 Version :  `3.1.0`
 
 Author : Abhishek
 

### Algorithm
````
 Bisecting K-means Algorithm
1: Initialize the list of clusters to contain the cluster consisting of all points.
2: repeat
3:      Remove a cluster from the list of clusters with highest SSE
4:      {Perform several "trial" bisections of the chosen cluster.}
5:      for i : 1 to number of trials do
6:          Bisect the selected cluster usins basic K-means
7:      end for
8:      Select the two clusters from the bisection with the lowest total SSE.
9:      Add these two clusters to the list of clusters.
10: until  the list of clusters contains k clusters.
```

## Implementation Code 

Bikmeans.R contains two functions mykmeans and bikmeans 

### Usage

We can call clusters.R for direct results
```
source("clusters.R")
```
Individual functions

```
bkm <- bikmeans(x=data, k=3, trials=3)

```

Plot of the output clusters 
```

plot(data[,2], data[,3], col=bkm$clusters, pch=data$cl, xlab="X1", ylab="X2", main="Bisecting-K means Plot")   
```

###Arguments
[x] = It is the data frame which contains the entire data or subset of the data for clustering

[k] = number of desired clusters in the data

[trials] = no of trails for calling kmeans internally

------
