colors <- c("#FF0000","#8A0808","#BDBDBD","#0B3B0B","#19070B","#DF01D7","#013ADF",
            "#01DFD7","#3ADF00","#FFFF00","#FACC2E","#585858","#3B170B","#2F0B3A",
            "#0B614B","#4B610B","#BEF781","#5FB404")


## For scaling attributes
getScaled <- function(x, max, min){
    round(((x-min)/(max-min)),3)
}


getScaledData <- function(data){
    for( col in 1:ncol(data)){
        col_max <- max(data[,col], na.rm=TRUE)
        col_min <- min(data[,col], na.rm=TRUE)
        data[,col] <- sapply(data[,col], getScaled, col_max, col_min)
    }
    data
}


mostFreq <- function(x){
    names(which.max(table(x)))
}


getNormalize <- function(x, mu, sigma){
    round((x-mu)/sigma,3)
}

getNormalizedData <- function(data){
    for( col in 2:ncol(data)){
        col_mean <- mean(data[,col], na.rm=TRUE)
        col_sd <- sd(data[,col], na.rm=TRUE)
        data[,col] <- sapply(data[,col], getNormalize, col_mean, col_sd)
    }
    data
}

kmeansElbow <- function(data, clust=c(2:10)){
    wss <- (nrow(x=data)-1)*sum(apply(data,2,var))
    for (i in clust){
        wss[i] <- sum(kmeans(data, centers=i)$withinss)
    }
    print(wss)
    # Elbow Plot
    plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")
}



getAggregate <- function(funcName){
    fipsData <- aggregate(list(new_users$numActions, new_users$user, new_users$actionPerWeek, new_users$Week1,new_users$Week2, new_users$Week3,
                               new_users$Week4, new_users$Week5, new_users$Week6, new_users$Week7, new_users$Week8,
                               new_users$Week9, new_users$Week10, new_users$Week11,
                               new_users$Week11,new_users$Week12,new_users$Week13,new_users$Week14,
                               new_users$Week15,new_users$Week16,new_users$Week18), list(new_users$fips), FUN=funcName)
    names(fipsData) <- c("fips", "numActions", "numOfUsers", "avgActionWeek","week1","week2","week3","week4","week5","week6",
                         "week7","week8","week9","week10","week11","week12","week13","week14","week15","week16",
                         "week17","week18")
    fipsData
}


colMedians <- function(x){
    if(is.data.frame(x) || is.matrix(x)){
        return(apply(x, 2, median))
    }
}


### Plots

#library(scales)
#symbols(x=c11$longitude, y=c11$latitude, circle=c11$weekcount, bg=alpha(c11$cluster_intra, 0.4), inches=0.5) 
#symbols(x=c1$longitude, y=c1$latitude, circle=c1$weekcount, bg=alpha(c1$cluster_intra, 0.4), inches=0.5) 
