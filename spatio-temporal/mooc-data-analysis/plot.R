

rm(list=ls())

data <- read.csv("~/Downloads/usa_user_satscan (5).csv")
data <- data[data$cluster %in% c(2,3,4,5,8,9,10,11,14),]

library(maps)
map('usa') 
map.axes()

colors =c("xx","orange","red", "blue", "dark green", "xx","xx","magenta","cyan",
          "brown", "steel blue","xx","xx","green")
map("state", boundary = FALSE, lty = 3, add = TRUE)
points(x=data$longitude, y=data$latitude, col=colors[data$cluster], pch=20)