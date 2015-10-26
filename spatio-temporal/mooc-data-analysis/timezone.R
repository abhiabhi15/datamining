
rm(list=ls())
users <- read.csv("~/Downloads/rightNdupAlt.csv")

unique(users$user)
usersDF <- users[,2:4]
write.csv(file="mooc_user.csv", usersDF, row.names=F, quote=FALSE)


check  <- read.csv("~/Downloads/check.csv", header=F)
names(check) <- c("uid", "timezone")
write.csv(file="mooc_user_tz.csv", check, row.names=F, quote=FALSE)


length(unique(users$user))

sort(table(check$V1))
users[users$user == "868b0197293ac505681a89d1804e336a11909cc4",2:4]

check[check$V1 == "868b0197293ac505681a89d1804e336a11909cc4",]

head(usersDF)

sort(table(usersDF$user))
usersDF[usersDF$user == "868b0197293ac505681a89d1804e336a11909cc4",]


#===================================
rm(list=ls())
moocData <- read.csv("moocData.csv")
names(moocData)
moocData <- moocData[,c(8,11,12)]
unique_user_data <- moocData[!duplicated(moocData[,c('username')]),]
unique_user_data <- na.omit(unique_user_data)


write.csv(file="mooc_world_user.csv", unique_user_data, row.names=F, quote=FALSE)


dd <- read.csv("~/Downloads/offset.csv", header=F)

length(unique(dd$V1))
