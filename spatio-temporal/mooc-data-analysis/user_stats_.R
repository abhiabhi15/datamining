library(sqldf);
library(noncensus);

x=read.csv(file = "user_stats.csv")
x=x[c(-1,-2)]


#1st obj
data1 = read.csv(file="user_stats.csv")
data2 = read.csv(file="username_session_count.csv")
data2 = data2[c(-1)]

save = sqldf("select d1.username, d1.numLecture, d1.numQuiz, d1.numForum, d1.numActions, d1.numSession, d2.count as numIP from data3 d1,data4 d2 where d1.username=d2.username")
plot(log(data3$numActions),data3$numSession,col='red',main="Action vs Session",xlab="Number of action(log)", ylab="Number of sessions")

save1 = sqldf("select username, count (distinct user_ip) as 'count' from data group by username")
data4 = as.data.frame(save1)

data3 = as.data.frame(save)
write.csv(data3,"d2.csv")

u2=data[data$username=='868b0197293ac505681a89d1804e336a11909cc4',]
u3=data[data$username=='186500df292fe932e2d2555c33d07add85cf7b96',]
plot(data3$numSession,data3$numIP,ylim =c(0,70))

data5=read.csv(file = "weekData.csv")
save2 = sqldf("select d.username, d.week, count(*) from data5 d group by d.username")
save3 = sqldf("select d.username, count(distinct d.week) from data5 d group by d.username")
data6= as.data.frame(save3)
save = sqldf("select d1.username, d1.numLecture, d1.numQuiz, d1.numForum, d1.numActions, d1.numSession, d1.numIP, d2.weekcount from data3 d1,data6 d2 where d1.username=d2.username")

data = as.data.frame(save)
write.csv(data, "user_moocData.csv")


data = read.csv(file = "user_new_stats.csv")
kdata = data[c(2,3,4,5,7)]
k1=kmeans(kdata,centers = 1)
k2=kmeans(kdata,centers = 2)
k3=kmeans(kdata,centers = 3)
k4=kmeans(kdata,centers = 4)
k5=kmeans(kdata,centers = 5)
k6=kmeans(kdata,centers = 6)
k7=kmeans(kdata,centers = 7)
k8=kmeans(kdata,centers = 8)
k9=kmeans(kdata,centers = 9)
k10=kmeans(kdata,centers = 10)

elbow = data.frame(k=numeric(), sse=numeric())
elbow=rbind(elbow,c(1,k1$withinss))
elbow=rbind(elbow,c(2,k2$withinss))
elbow=rbind(elbow,c(3,k3$withinss))
elbow=rbind(elbow,c(4,k4$withinss))
elbow=rbind(elbow,c(5,k5$withinss))
elbow=rbind(elbow,c(6,k6$withinss))
elbow=rbind(elbow,c(7,k7$withinss))
elbow=rbind(elbow,c(8,k8$withinss))
elbow=rbind(elbow,c(9,k9$withinss))
elbow=rbind(elbow,c(10,k10$withinss))

plot(elbow)

data$cl=k3$cluster
plot(data$numLecture,data$weekcount,col=data$cl,pch=data$numQuiz)


data1=read.csv("moocData.csv")
data2 = data1[c(8,13,14)]
save = sqldf("select distinct username, country from data2 group by username order by count(*) DESC Limit 1")
savedf = as.data.frame(save)
save1 = sqldf("select * from data d1 left outer join savedf d2 on d1.username=d2.username")
data = as.data.frame(save1)
data=data[c(-28)]

save = sqldf("select username, city from data2 group by username order by count(*) DESC")
savedf = as.data.frame(save)
save1 = sqldf("select * from data d1 left outer join savedf d2 on d1.username=d2.username")
data = as.data.frame(save1)
data=data[c(-27)]

write.csv(data,"user_new_stats_with_geov2.csv")


data3=read.csv("postalData.csv")
save = sqldf("select username, postalCode from data3 group by username order by count(*) DESC")
savedf = as.data.frame(save)
save1 = sqldf("select * from data d1 left outer join savedf d2 on d1.username=d2.username")
data = as.data.frame(save1)
data=data[c(-29)]
write.csv(data,"user_new_stats_with_geov3.csv")

#us data
save = sqldf("select * from data where country='United States'")
savedf = as.data.frame(save)
length(which(is.na(savedf$postalCode)))
write.csv(savedf,"user_new_stats_USA.csv")

temp = merge(savedf,zip_codes, by.x="postalCode", by.y="zip")
save2 = sqldf("select * from savedf d1 left outer join zip_codes d2 on d1.postalCode=d2.zip")
savedf1=as.data.frame(save2)
savedf2 = savedf1[c(-30,-31)]
write.csv(savedf2,"user_new_stats_USA.csv")

kmeansElbow <- function(data, clust=c(2:10)){
  wss <- (nrow(x=data)-1)*sum(apply(data,2,var))
  for (i in clust){
    wss[i] <- sum(kmeans(data, centers=i)$withinss)
  }
  print(wss)
  # Elbow Plot
  plot(1:10, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")
}

usdata = read.csv("user_new_stats_USA.csv")
data = read.csv("scaled_userstats.csv")
save2 = sqldf("select * from data d1 INNER join usdata d2 on d1.username=d2.username")
data = as.data.frame(save2)

clustdata = data[,c(2,3,4,5,6,7,8,12,13,14,15,16,17,18,19,20,21,22)]
cor(clustdata)
clustdata = clustdata[,-c(5,6)]
cl = kmeans(x = clustdata, centers = 3)
table(cl$cluster)
kmeansElbow(clustdata)


usdata = data[,-c(27:53)]
clustdata = usdata[,c(2,3,4,7,8,12,13,14,15,16,17,18,19,20,21,22)]
cl = kmeans(x = clustdata, centers = 3)
table(cl$cluster)
usdata$cluster = cl$cluster

save = sqldf("select fips,count(*) from usdata group by fips")
aggregate(x = usdata, FUN = )


getAggregate <- function(funcName){
  fipsData <- aggregate(list(usdata$cluster), list(usdata$fips), FUN=funcName)
  names(fipsData) <- c("fips", "cluster")
  fipsData
}

majority = function(x){
    return (as.numeric(names(sort(table(x),decreasing=TRUE)[1])))
}

data = read.csv("user_new_stats_USA_with_grades.csv")
library(fpc)
db = dbscan(data[c(3,4,5,6)],eps = 5, MinPts = 10)

grades = read.csv("coursera.course_grades.csv")
data = read.csv("user_new_stats_USA.csv")
save = sqldf("select * from data d left outer join grades g on d.username=g.session_user_id")
savedf = as.data.frame(save)
savedf1 = savedf[-c(1,38,40,41,42)]
write.csv(savedf1,"user_new_stats_USA_with_grades.csv",row.names=FALSE)

dbscandata = savedf1[c(2,3,5,31,32)]
dbscandata = na.omit(dbscandata)
model = dbscan(dbscandata, eps = 5, MinPts = 5)
table(model$cluster)


claradata = data[c(2,3,5)]
claradata = na.omit(claradata)
clarax = clara(x = claradata, k=5)

