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
plot(bstation$latitude, bstation$longitude, pch=20, col=2)
write.csv(file="beijing_station.csv", bstation, row.names = F)

bairData <- airData[airData$station_id %in% unique(bstation$station_id),]
write.csv(file="beijing_airquality.csv", bairData, row.names = F)

library(lubridate)
bairData$time <- as.POSIXct(bairData$time)
  
date1 <- as.POSIXct("2014-10-01 00:00:00")
date2 <- as.POSIXct("2014-12-31 23:00:00")
intrval <- interval(date1, date2)

bairDataWinter = bairData[bairData$time %within% intrval,]
write.csv(file="winter_beijing_airquality.csv", bairDataWinter, row.names = F)

hrs <- hour(bairDataWinter$time) 
sset <- which(hrs >=  11 & hrs <= 13)
bairDataT = bairDataWinter[sset,]
write.csv(file="winter_beijing_airquality_filter.csv", bairDataT, row.names = F)




### Meterology Features
mdata <- read.csv("data/meteorology.csv")
dists <- seq(101,116, 1)
bmdata <-  mdata[mdata$id %in% dists,]
bmdata$time <- as.POSIXct(bmdata$time)

date1 <- as.POSIXct("2014-10-00 00:00:00")
date2 <- as.POSIXct("2014-12-31 23:00:00")
intrval <- interval(date1, date2)

bmdataWinter = bmdata[bmdata$time %within% intrval,]
write.csv(file="meteorology_winter_beijing.csv", bmdataWinter, row.names = F)

mhrs <- hour(bmdataWinter$time) 
msset <- which(mhrs >= 11 & mhrs <= 14 )
mbairDataT = bmdataWinter[msset,]
write.csv(file="meteorology_winter_beijing_filter.csv", mbairDataT, row.names = F)

mbairDataT$uid = paste(mbairDataT$id , yday(mbairDataT$time) , sep="_")
mbairDataNew <- mbairDataT[mbairDataT$id == -1,]
length(unique(mbairDataT$uid))
for(i in unique(mbairDataT$uid)){
  indx = which(mbairDataT$uid == i)
  if(length(indx) > 1){
    indx = sample(indx, 1)
  }
  mbairDataNew = rbind(mbairDataNew, mbairDataT[indx,])
}
write.csv(file="meteorology_winter_beijing_filter_V1.csv", mbairDataNew, row.names = F)




#### Beijing Data Air Quality Pre-processing
bairDataT$id = paste(bairDataT$station_id , yday(bairDataT$time) , sep="_")
bairDataNew <- bairDataT[bairDataT$station_id == -1,]
length(unique(bairDataT$id))
for(i in unique(bairDataT$id)){
    indx = which(bairDataT$id == i)
    if(length(indx) > 1){
        indx = sample(indx, 1)
    }
    bairDataNew = rbind(bairDataNew, bairDataT[indx,])
}

bairDataNew = merge(bairDataNew, bstation, by="station_id")
bairDataNew <- bairDataNew[,-c(10,11)]
bairDataNew$duid = paste(bairDataNew$district_id , yday(bairDataNew$time) , sep="_")

write.csv(file="winter_beijing_filter_V1.csv", bairDataNew, row.names = F)


## Function to calculate AQI
aqiCalc <- function(df){
  dm <- as.matrix(df)
  class(dm) <- "numeric"
  apply(dm, 1, max, na.rm=T)
}

## merging polution data with meteorology data
fdata <- merge(bairDataNew, mbairDataNew, by.x="duid", by.y = "uid")
names(fdata)
fdata <- fdata[,-c(1,14,15)]
colnames(fdata)[2] = "time"
colnames(fdata)[9] = "id"
fdata <- fdata[c(9, 2, 1, 12, 10, 11, 3,4,5,6,7,8,13,14,15,16,17,18)]
fdata = fdata[with(fdata, order(id)), ]
fdata$aqi = aqiCalc(fdata[,7:12])

write.csv(file="winter_beijing_full.csv", fdata, row.names = F)


#### Time Layer Files
for(i in yday(fdata$time)){
    tdata <- fdata[yday(fdata$time) == i,]
    filename <- paste("time/winter_beijing_T", i, sep="")
    write.csv(file=paste(filename, "csv", sep="."), tdata, row.names = F)  
}

## AQI Distribution
rm(list=ls())
fdata <- read.csv("winter_beijing_full.csv")

udays = sort(unique(yday(fdata$time)))
df = as.data.frame(matrix(0, nrow=length(unique(fdata$station_id)), ncol=length(udays)+1))
m = 1
for(i in unique(fdata$station_id)){
    df[m,1] = i
    sData <- fdata[fdata$station_id == i,]
    n = 2
    for(j in udays){
        df[m,n] <- NA
        spData <- sData[yday(sData$time) == j,]
        if(nrow(spData) > 0){
            spData <- as.matrix(spData[,7:12])
            class(spData) <- "numeric"
            df[m,n] = max(spData[1,], na.rm = T)
        }
        n = n +1
    }
    m = m+1
}

colnames(df)[1] ="station_id"
udaynames = sapply(udays, function(x){ paste("T", x, sep="")})
colnames(df)[2:ncol(df)] <- udaynames
write.csv(file="winter_beijing_aqi_distribution.csv", df, row.names = F)
