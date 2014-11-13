source("helper.R")

## 1) Bad K-means

## a) Data Generation in High Dimension d=6
set.seed(7)
d1 <- generateConcentricPoints(n=500, radius1=0, radius2=3)
extra_d1 <- extraDimensions(n=500, means=c(2,4,6,8))
d1 <- cbind(d1, extra_d1)
d1 <- cbind(d1, 1)  ## With Label as 1

d2 <- generateConcentricPoints(n=500, radius1=5, radius2=8)
extra_d2 <- extraDimensions(n=500, means=c(1,3,5,7))
d2 <- cbind(d2, extra_d2)
d2 <- cbind(d2, 2)  ## With Label as 2

data4 <- rbind(d1, d2)
colnames(data4) <- c("x","y","z","u","v","w", "label")

png(filename="Kmeans_hD.png", width=980, height=620, units="px")
plot(as.data.frame(data4), col=data4[,ncol(data4)], main="Scatter Matrix for higher dimension Kmeans Data")
dev.off()

## b) Kmeans on High Dimesion
kc <- kmeans(data4[,-ncol(data4)], center=2)
plot(data4, col=kc$cluster, pch=22-(2 *data4[,ncol(data4)]), xlab="x", ylab="y", main="Bad K-Means in High Dimension")

## Bad Performance

GT1 <- which(data4[,ncol(data4)] == 1)
GT2 <- which(data4[,ncol(data4)] == 2)
CL1 <- which(kc$cluster == 1)
CL2 <- which(kc$cluster == 2)
computePerformanceMetrics(GT1, GT2, CL1, CL2)

## RBF Kernel PCA for High Dimension PCA

kpar <- list(sigma=0.025)
dkpc <- kpca(~., data=as.data.frame(data4[,-ncol(data4)]), kernel="rbfdot", kpar=kpar)
kpcv <- pcv(dkpc)
proportion <- kpcaSummary(dkpc)
plot(proportion$Proportion, type="b", pch=20, main ="Variabilty Scree Plot", xlab="eigen value", ylab="Variability", col="blue")


## Plot of Data in m=2 Dimension
plot(kpcv[,1], kpcv[,2], col = data4[,ncol(data4)] ,main="RBF Kernelized PCA", xlab="First Eigen Vector", ylab="Second Eigen Vector")

## Running K-meams on projected data in 2D

cc1 <- kmeans(kpcv[,1:2], centers=2)
plot(kpcv[,1], kpcv[,2], col = cc1$cluster, pch=22- 2*data4[,ncol(data4)], xlab="x", ylab="y", main="Kernelized K-Means [ RBF Kernel] in 2D data")
legend("topright", c("Cluster1", "Cluster2"), pch = list(20,18) ,col=c(1,2))

## Performance
MCL1 <- which(cc1$cluster == 1)
MCL2 <- which(cc1$cluster == 2)
computePerformanceMetrics(GT1, GT2, MCL1, MCL2)

## KKMeans on Higher Dimension Data

kkc <- kkmeans(data4[,-ncol(data4)], centers=2, kernel = "rbfdot", kpar = "automatic", alg="kkmeans", p=1, na.action = na.omit)
plot(data4, col=kkc, pch=22-(2 *data4[,ncol(data4)]), xlab="x", ylab="y", main="Kernelized K-Means [ Radial Basis kernel on 6D]")
legend("topleft", c("Cluster1", "Cluster2"), pch = list(20,18) ,col=c(1,2))

