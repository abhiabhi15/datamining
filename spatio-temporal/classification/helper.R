extendData <- function(data){
    tmp <- apply(data ,1, getNeighbors)
    tmp <- do.call(rbind.data.frame, tmp)
    names(tmp) <- names(data)
    data <- rbind(data, tmp)
    data
}


getNeighbors <- function(row){
    x <- row[1]
    y <- row[2]
    tData <- data.frame(ncol=2,nrow=8)
    tData[1,] <- c(x+1,y)
    tData[2,] <- c(x+1,y+1)
    tData[3,] <- c(x+1,y-1)
    tData[4,] <- c(x,y+1)
    tData[5,] <- c(x,y-1)
    tData[6,] <- c(x-1,y)
    tData[7,] <- c(x-1,y+1)
    tData[8,] <- c(x-1,y-1)
#     tData[9,] <- c(x, y+2)
#     tData[10,] <- c(x+1, y+2)
#     tData[11,] <- c(x-1, y+2)
#     tData[12,] <- c(x, y-2)
#     tData[13,] <- c(x+1, y-2)
#     tData[14,] <- c(x-1, y-2)
#     tData[15,] <- c(x-2, y-2)
#     tData[16,] <- c(x-2, y+2)
#     tData[17,] <- c(x+2, y-2)
#     tData[18,] <- c(x+2, y+2)
     tData[,3] <- row[3]
    tData
}
