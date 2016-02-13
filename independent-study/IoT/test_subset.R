rm(list=ls())

fdata = read.csv("winter_beijing_full.csv")
bstation = read.csv("data/beijing_station.csv")
distdata <- read.csv("winter_beijing_aqi_distribution.csv")
# Small Test Subsets
timesteps = 10  
# labeled stations = 10 , unlabeled = 10

for(i in 274:284){
  tdata <- fdata[yday(fdata$time) == i,]
  tdata <- tdata[1:15,]
  tdata$label <- "unknown"
  tdata[1:10, c("label")] <- "known"
  filename <- paste("test/winter_beijing_T", i, sep="")
  write.csv(file=paste(filename, "csv", sep="."), tdata, row.names = F)  
}
