rm(list=ls())
source("helper.R")

############## Only Spatial Clusters ################
## ST-DBScan

usaMooc <- read.csv("user_new_stats_USA_with_grades.csv")
rm(list=ls())
users <- read.csv("~/Downloads/rightNdupAlt.csv")
unique_user_data <- users[unique(users$user),2:4]

library(fpc)
data = na.omit(unique_user_data)
cdata <- data[,c(1,2,3)]

eps = 1.2
MinPts = 55
model = dbscan(cdata[,c(2,3)], eps = eps, MinPts = MinPts)
table(model$cluster)
cdata["cluster"]  <- model$cluster + 1

library(maps)
map('usa') 
map.axes()

map("state", boundary = FALSE, lty = 3, add = TRUE)
map("county", col="grey",boundary = FALSE, lty = 1, add = TRUE)
points(x=data$longitude, y=data$latitude, col=cdata$cluster, pch=20) 
title(paste(paste(paste("USA : Mooc Spatial DB Scan Eps", eps), " & MinPts "), MinPts))
table(model$cluster)

cdata <- cdata[c(1,4)]
data <- merge(usaMooc, cdata, by="username", all.x=T)
write.csv(file="clusterUSAData.csv",data, row.names=F)

