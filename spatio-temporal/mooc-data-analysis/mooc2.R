
new_users <- read.csv("data/user_new_stats_USA.csv")
new_users["user"] <- 1
head(new_users)
new_users["actionPerWeek"] <- new_users$numActions/new_users$weekcount
 
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

moocData <- getAggregate(mean)
write.csv(moocData, file="county_moocData.csv", row.names=F)
moocData <- merge(moocData, county.fips, by = "fips", all.y=TRUE)
moocData[is.na(moocData)] <- 0

drawCountyMap(moocData, c(4:21))
drawCountyMap <- function(moocData, cols){
    library("mapproj")
    data(county.fips)    
    avgActionPerWeek <- moocData$avgActionWeek
    #numOfUsers[which(numOfUsers == 1)] = numOfUsers[which(numOfUsers == 1)] + 1
    #table(numOfUsers)
    #moocData$numOfUsers <- numOfUsers
    
    for(i in 1:length(cols)){
        logScale <-  ceiling(log(moocData[,cols[i]]))
        summary(logScale)
        table(logScale)
        logScale <- logScale +1
        colors = heat.colors(max(logScale))
        colors[1] <- 0
        cat("Number of colors", length(colors))
        ## Heat Maps
        map("county", col = colors[logScale], fill = TRUE, resolution = 0,
            lty = 0, projection = "polyconic")    
        
        map("county", col = "gray", fill = FALSE, add = TRUE, lty = 1, lwd = 0.5,
            projection="polyconic")
        
        
        map("state", col = "black", fill = FALSE, add = TRUE, lty = 3, lwd = 2,
            projection="polyconic")
        title <- paste("USA County : Mooc Data Distributions : ", names(moocData)[cols[i]])
        title(title)
        Sys.sleep(2)
    }
}

table(moocData$numOfUsers)
names(new_users)

### Clustered Data Distribution

clusterData <- read.csv("fips_clusternum.csv")
clusterData$cluster <- clusterData$cluster+1
clusterData <- merge(clusterData, county.fips, by = "fips", all.y=TRUE)
clusterData[is.na(clusterData)] <- 0
table(clusterData$cluster)


map("county", col = clusterData$cluster, fill = TRUE, resolution = 0,
    lty = 0, projection = "polyconic")    

map("county", col = "gray", fill = FALSE, add = TRUE, lty = 1, lwd = 0.5,
    projection="polyconic")


map("state", col = "black", fill = FALSE, add = TRUE, lty = 3, lwd = 2,
    projection="polyconic")
title <- paste("USA County : Mooc Data Distributions : ", names(moocData)[cols[i]])
