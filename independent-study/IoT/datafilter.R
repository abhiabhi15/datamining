rm(list=ls())

airData <- read.csv("data/airquality.csv")
summary(airData)
dim(airData)

city <- read.csv("data/city.csv")

district <- read.csv("data/district.csv")
bdist <- district[district$city_id == 1,]
write.csv(file="beijing_district.csv", bdist, row.names = F)

station <- read.csv("data/station.csv")  
bstation <- station[station$district_id %in% unique(bdist$district_id),]
write.csv(file="beijing_station.csv", bstation, row.names = F)

bairData <- airData[airData$station_id %in% unique(bstation$station_id),]
write.csv(file="beijing_airquality.csv", bairData, row.names = F)

library(lubridate)
bairData$time <- as.POSIXct(bairData$time)
  
date1 <- as.POSIXct("2014-10-22 00:00:00")
date2 <- as.POSIXct("2014-10-25 23:00:00")
intrval <- interval(date1, date2)

bairDataWinter = bairData[bairData$time %within% intrval,]
write.csv(file="winter_beijing_airquality.csv", bairDataWinter, row.names = F)

hrs <- hour(bairDataWinter$time) 
sset <- which(hrs == 12 )
bairDataT = bairDataWinter[sset,]
write.csv(file="winter_beijing_airquality_filter.csv", bairDataT, row.names = F)


plot(bstation$latitude, bstation$longitude, pch=20, col=2)
