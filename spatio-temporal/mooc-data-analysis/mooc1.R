

userstats <- read.csv("data/user_stats.csv")
userstats <- userstats[,4:7]
userstats <- na.omit(userstats)

head(userstats)
options(scipen = 1)

kc <- kmeans(userstats, centers=7)

## Finding Optimal Number of Clusters
wss <- (nrow(x=userstats)-1)*sum(apply(userstats,2,var))
for (i in 2:10){
    wss[i] <- sum(kmeans(userstats, centers=i)$withinss)
}
# Elbow Plot
plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")



###################
sessionData <- read.csv("data/username_session_count.csv")
hist(log(sessionData$count), col="blue", main="Session Distribution of Users [Log Scale]", xlab="Session Count[Log]")

table(sessionData$count)


##########################
moocUserData <- read.csv("data/user_moocData.csv")
weekData <- read.csv("data/weekData.csv")

users <- as.vector(moocUserData$username)
weeks <- sort(unique(weekData$week))
weekVector <- as.data.frame(t(rbind(weeks,0)))
names(weekVector) <- c("weekNum", "freq")

weekActivity <- as.data.frame(t(sapply(users, getWeekVector)), row.names=F)
backWeeks <- weekActivity[,-c(1:5)]
weekActivity <- cbind(backWeeks, weekActivity[,c(1:5)])
names(weekActivity) <- c("Week1","Week2","Week3","Week4","Week5","Week6","Week7","Week8",
                         "Week9","Week10","Week11","Week12","Week13","Week14","Week15","Week16",
                         "Week17","Week18")
moocUserData <- cbind(moocUserData, weekActivity)
write.csv(moocUserData, "moocWeekUserData.csv", row.names=F)

getWeekVector <- function(user){
    currWeek <- weekVector
    userWeek <- as.data.frame(table(weekData[weekData$username == user, "week"]))
    currWeek[which(currWeek$weekNum %in% userWeek$Var1),]$freq <- userWeek$Freq
    as.vector(currWeek[,2])
}

############################################################
### Cleaning Part

nchar("1eab03175dec76539d579d099dcbd64e7663728c")
moocUserData[nchar(moocUserData$username) < 40, ]
length(which(is.na(uu) == T))
uu <- as.data.frame(sapply(users, checkChar))
names(uu) <- c("usr")
checkChar <- function(user){
    if(nchar(user) == 40){
        return (user);
    }else{
        return (NA);
    }
}
##########################################
## Transformation
rm(list=ls())
moocUserData <- read.csv(file="data/user_new_stats.csv")
names(moocUserData)

nData <- getNormalizedData(data=moocUserData)
sData <- getScaledData(data=moocUserData)

plot(sData$numActions,sData$numSession)

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

getScaled <- function(x, max, min){
    round(((x-min)/(max-min)),3)
}


getScaledData <- function(data){
    for( col in 2:ncol(data)){
        col_max <- max(data[,col], na.rm=TRUE)
        col_min <- min(data[,col], na.rm=TRUE)
        data[,col] <- sapply(data[,col], getScaled, col_max, col_min)
    }
    data
}

write.csv(sData, "scaled_userstats.csv", row.names=F)
write.csv(nData, "standardized_userstats.csv", row.names=F)
#######################################################
#Clustering
rm(list=ls())
sData <- read.csv("standardized_userstats.csv")
nData <- read.csv("scaled_userstats.csv")
data <- nData

kc <- kmeans(data[,-1], centers=7)
kmeansElbow(data[,-1])

data$numActions <- log(data$numActions)
plot(data$numActions, data$numQuiz)

ff <- princomp(sData[,-1])
plot(ff)
newD <- ff$scores
dim(newD)

jj<-kmeans(newD[,1:5] , centers=5)

plot(newD[,1], newD[,2], col=jj$cluster)

kmeansElbow(newD[,1:5])

kmeansElbow <- function(data, clust=c(2:10)){
    wss <- (nrow(x=data)-1)*sum(apply(data,2,var))
    for (i in clust){
        wss[i] <- sum(kmeans(data, centers=i)$withinss)
    }
    print(wss)
    # Elbow Plot
    plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")
}



