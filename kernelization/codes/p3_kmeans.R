source("helper.R")

## Q1) Bad K-means

## EX-1.a) Data Generation
set.seed(7)
d1 <- generateConcentricPoints(n=500, radius1=0, radius2=3)
d1 <- cbind(d1, 1)  ## With Label as 1
colnames(d1) <- c("x", "y", "label")
d2 <- generateConcentricPoints(n=500, radius1=5, radius2=8)
d2 <- cbind(d2, 2)  ## With Label as 2
colnames(d2) <- c("x", "y", "label")
data1 <- rbind(d1, d2)

## 1.d) Plot of Original Data for Bad Kmeans
plot(data1[,-ncol(data1)], col=data1[,ncol(data1)], xlab="x", ylab="y", main="Bad K-Means Original Data")

### Q 2 a) Bad K-means plot and performance

kc <- kmeans(data1[,-ncol(data1)], center=2)
plot(data1[,-ncol(data1)], col=kc$cluster, pch=22-(2 *data1[,ncol(data1)]), xlab="x", ylab="y", main="Bad K-Means")
legend("topleft", c("Cluster1", "Cluster2"), pch = list(20,18) ,col=c(1,2))

#a) K-means performance measure
# Ground Truths
GT1 <- which(K[,ncol(data1)] == 1)
GT2 <- which(K[,ncol(data1)] == 2)
CL1 <- which(kc$cluster == 1)
CL2 <- which(kc$cluster == 2)
computePerformanceMetrics(GT1, GT2, CL1, CL2)

## Question 3.a Kmeans
# a) RBF Kmeans
png(filename="Kmeans_Kernels.png", width=980, height=520, units="px")
par(mfrow = c(1,2)) 

kkc <- kkmeans(data1[,-ncol(data1)], centers=2, kernel = "rbfdot", kpar = "automatic", alg="kkmeans", p=1, na.action = na.omit)
plot(data1[,-ncol(data1)], col=kkc, pch=22-(2 *data1[,ncol(data1)]), xlab="x", ylab="y", main="Kernelized K-Means [ Radial Basis kernel]")
legend("topleft", c("Cluster1", "Cluster2"), pch = list(20,18) ,col=c(1,2))

kkc1 <- kkmeans(data1[,-ncol(data1)], centers=2, kernel = "anovadot", kpar = "automatic", alg="kkmeans", p=1, na.action = na.omit)
plot(data1[,-ncol(data1)], col=kkc1, pch=22-(2 *data1[,ncol(data1)]), xlab="x", ylab="y", main="Kernelized K-Means [ Anova RBF Kernel]")
legend("topleft", c("Cluster1", "Cluster2"), pch = list(20,18) ,col=c(1,2))

dev.off()
# Performance for RBF
KCL1 <- which(kkc == 1)
KCL2 <- which(kkc == 2)
computePerformanceMetrics(GT1, GT2, KCL1, KCL2)

# Performance for Anova
KCL1 <- which(kkc1 == 1)
KCL2 <- which(kkc1 == 2)
computePerformanceMetrics(GT1, GT2, KCL1, KCL2)
