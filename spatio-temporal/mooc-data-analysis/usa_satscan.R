rm(list=ls())
users <- read.csv("~/Downloads/rightNdupAlt.csv")
unique_user_data <- users[!duplicated(users[,c('user')]),2:4]
unique_user_data$latitude <- as.numeric(as.character(unique_user_data$latitude))
unique_user_data$longitude <- as.numeric(as.character(unique_user_data$longitude))

data <- na.omit(unique_user_data)

library(fpc)
eps = 1.2
MinPts = 55
model = dbscan(data[,2:3], eps = eps, MinPts = MinPts)
table(model$cluster)
data["cluster"]  <- model$cluster + 1

library(maps)
map('usa') 
map.axes()

map("state", boundary = FALSE, lty = 3, add = TRUE)
points(x=data$longitude, y=data$latitude, col=data$cluster, pch=20) 
length(unique(data$user))
write.csv(file="~/Downloads/usa_user_satscan.csv", data, row.names=F, quote=FALSE)




