

sampleData <- read.csv("data/fb_caltech_small_attrlist.csv")

wss <- (nrow(x=sampleData)-1)*sum(apply(sampleData,2,var))
for (i in 2:40){
  wss[i] <- sum(kmeans(sampleData, centers=i )$withinss)
}

# Elbow Plot
plot(1:40, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares", main="Kmeans Optimal Number of Clusters",col="blue")

library("akmeans")
kk=akmeans(sampleData,d.metric=2,ths3=0.8,mode=3) ## cosine distance based
?akmeans
