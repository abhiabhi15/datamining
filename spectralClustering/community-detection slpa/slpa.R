#
#  Speaker-Listener Label Propagation Algorithm
#  @author : abhishek
#  @unityid : akagrawa
#	
#	 Note : Please refer README.md file for the code usage
#
rm(list=ls())
library(igraph)

getGraph <- function(x){ 
    x <- read.table(x)         # Reading graph from the directory
    gv <- x[1,1]   						 # Fetching the vertex count	
    ge <- x[2:nrow(x),] + 1		 # Adding 1 to move vertex id, because of 0 vertex-id
    G <- graph.empty() + vertices(1:gv)
    G <- add.edges(G, t(ge))
    G <- as.undirected(G)      # making the graph undirected
    G
}

slpa <- function(filename=NULL, iters=20, r=0.001){
    if(is.null(filename)){
        stop("Filename cannot be null")
    }
    graph <- getGraph(filename)
    
    # Helper Functions
    speakerRule <- function(matx, speaker){  # Speaker Rule : Selecting the label based on 
       inds <- which(matx[speaker,] > -1, arr.ind=TRUE)
       random <- sample(inds, 1)                  # probabilty of maximum frequency
       matx[speaker, random]                      # random selection will follow such probability 
    }
    
    listenerRule <- function(labels){  # Listener Rule : Finding the popular label
        ux <- unique(labels)
        popular <- -1
        if(length(ux) == length(labels)){    # If labels are unique, taking random label
          popular <- sample(labels,1)
        }else{
          popular <- ux[which.max(tabulate(match(labels, ux)))]   # Or, taking the mode of the labels
        }
        popular
    }
    
    groupCommunity <- function(nodelist){  # Grouping nodes based on labels to form community
        a <- list()
        for(i in 1:length(nodelist)){
          items <- nodelist[[i]]
          if(length(items) > 0){           # Mimicing hash-map structure to group nodes together
            for(j in 1:length(items)){         # Miss, then adding new community
              item <- as.character(items[j]-1)  
              if(length(a) == 0 || !is.element(item,names(a))){
                  t <- list(c(i-1))         # Vertex-id are starting from zero, hence vertex-id=index-1
              }else{                        # Hit, then updating the community
                t <- a[names(a) == item]
                a <- a[names(a) != item]
                t <- list(c(t[[1]], i-1))
              }
              names(t) <- item
              a <- append(a, t)
            }
          }
        }
        a
    }
    
    # Implementations Stages
    # Stage-1 Initialization
    nodes <- vcount(graph)
    M <- matrix(-1, nrow=nodes, ncol=iters+1)          
    M[,1] <- V(graph)           # Initial label assignment as vertex-id           
    
    #Stage-2 Evolution
    for(iter in 1:iters){
        shuffle <- sample(V(graph))
        for(i in 1:length(shuffle)){
            listener <- shuffle[i]   # Shuffle vertices
            speakers <- neighborhood(graph, order=1, nodes=listener)[[1]]  #Finding neighbours as speaker
            speakers <- speakers[-listener]
            labelist <- c()
            for(j in 1:length(speakers)){   # Fetching labels from speakers i.e. neighbours
                labelist <- append(labelist, speakerRule(M, speakers[j]))
            }
            if(length(labelist) > 0){
                w <- listenerRule(labelist)    # Selecting the popular label
                M[listener, iter+1] <- w       # Adding the popular label   
            }
        }
    }
    
    #Stage-3 Post-processing
    prob <- table(M)/length(M)        # Probability of occurence of label in the whole process        
    
    finalist <- list()            # Removal of labels whose probability < r
    for(i in 1:nrow(M)){              
        final <- c()           
        for(j in 1:ncol(M)){  
            if(M[i,j] != -1 && (prob[M[i,j]] > r)){
                final <- append(final, M[i,j])
            }
        }
        final <- unique(final)    # Selecting unique community id for each node
        finalist <- append(finalist, list(final))
    }
    result <- list()              # Saving result in form of overlapping node-list, communities and community-size
    result$nodes <- finalist  
    result$communities <- unique(groupCommunity(finalist))   # Grouping overlapping nodes to form communities
    result$size <- length(result$communities)
    output_file <- paste(paste("communities" ,filename, sep="."), "txt", sep=".")
    invisible(lapply(result$communities, write, output_file, append=TRUE, ncolumns=1000000)) # saving the communites in communities.txt file
    result
}

ptime <- proc.time()
res <- slpa(filename="youtube.graph.small")   # calling slpa algorithm with youtube-small graph as default
print(proc.time() - ptime)

