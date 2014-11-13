source("helper.R")

## Q1) Bad PCA
## EX-1.b) Data Generation

set.seed(5)
d1 <- generateConcentricPoints(n=100, radius1=0, radius2=1)
d1 <- cbind(d1, 1)  ## With Label as 1
colnames(d1) <- c("x", "y", "label")

d2 <- generateConcentricPoints(n=100, radius1=3, radius2=5)
d2 <- cbind(d2, 2)  ## With Label as 2
colnames(d2) <- c("x", "y", "label")
data2 <- rbind(d1, d2)

d3 <- generateConcentricPoints(n=100, radius1=7, radius2=8)
d3 <- cbind(d3, 3)  ## With Label as 2
colnames(d3) <- c("x", "y", "label")
data2 <- rbind(data2, d3)

# 1.d) Plot of the data
plot(data2[,-ncol(data2)], col=data2[,ncol(data2)] , xlab="x", ylab="y", main="Bad PCA Original Data")

## Q:2  Measures of Bad PCA
pca = princomp (data2[,1:2], center=TRUE);

loadings(pca);      # matrix of eigenvectors
summary (pca); # check proportion of variance
P=pca$scores;     # projection of X onto eigenvectors
png(filename="PCA_Performance.png", width=980, height=520, units="px")
par(mfrow = c(1,2)) 
plot (pca, main="PCA Variances"); # screeplot
plot (P[ ,1], P[,2], col=data2[,ncol(data2)], main="Linear PCA", xlab="First Eigen Vector", ylab="Second Eigen Vector");
dev.off()
par(mfrow = c(1,1)) 


## Q:3 a) Using RBF Kernel
kpc <- kpca(~., data=as.data.frame(data2[,-ncol(data2)]), kernel="rbfdot", kpar=list(sigma=0.06))
kpcv <- pcv(kpc)
kpcaSummary(kpc)

kpc1 <- kpca(~., data=as.data.frame(data2[,-ncol(data2)]), kernel="laplacedot", kpar=list(sigma=0.19))
kpcv1 <- pcv(kpc1)
kpcaSummary(kpc1)

png(filename="KPCA_Performance.png", width=980, height=520, units="px")
par(mfrow = c(1,2)) 
plot(kpcv[,1], kpcv[,2], col=data2[,ncol(data2)], main="RBF Kernelized PCA", xlab="First Eigen Vector", ylab="Second Eigen Vector")
plot(kpcv1[,1], kpcv1[,2], col=data2[,ncol(data2)], main="Laplacian Kernelized PCA", xlab="First Eigen Vector", ylab="Second Eigen Vector")
dev.off()

