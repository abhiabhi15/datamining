source("helper.R")

## Q1) BAD SVM
## EX-1.c) Data Generation

set.seed(11)
d1 <- generateConcentricPoints(n=500, radius1=2, radius2=3)
d1 <- cbind(d1, 1)  ## With Label as 1
colnames(d1) <- c("x", "y", "label")
d2 <- generateConcentricPoints(n=500, radius1=5, radius2=8)
d2 <- cbind(d2, 2)  ## With Label as 2
colnames(d2) <- c("x", "y", "label")
data3 <- rbind(d1, d2)

plot(data3[,-ncol(data3)], col=data3[,ncol(data3)], pch = c("+","-")[data3[,ncol(data3)]], xlab="x", ylab="y", main="Bad Linear SVM Original Data")
legend("topleft", c("Class +", "Class -"), pch = c("+","-"),col=c(1,2))

## Bad SVM Performance Evaluation
sample_index <- sample(1:nrow(data3), 0.9 * (nrow(data3)))
train_data <- data3[sample_index,]
labels <- train_data[,ncol(train_data)]
test_data <- data3[-sample_index,]
gtruth <- test_data[,ncol(test_data)]

x <- train_data[,-ncol(train_data)]
model <- ksvm(x , labels, type = "C-svc", kernel="vanilladot", prob.model=TRUE)
plot(model, data = x)
pred <- predict(model, test_data[,-ncol(test_data)])
plot(test_data[,-3], pch=c("+","-")[pred], xlab="x", col = test_data[,ncol(test_data)], ylab="y", main="Bad SVM Prediction [Linear Kernel]")
legend("topleft", c("Pred+", "Pred-", "Actual+", "Actual-"), pch = c("+","-","Black","Red"),col=c(1,2))
abline(h=2.25)

## Performance Metrics : Confusion Matrix and other measures

GT1 <- which(test_data[,ncol(test_data)] == 1)
GT2 <- which(test_data[,ncol(test_data)] == 2)
CL1 <- which(pred == 1)
CL2 <- which(pred == 2)
computePerformanceMetrics(GT1, GT2, CL1, CL2)


## Q:3 Using Kernel Trick

model <- ksvm(x, labels, type = "C-svc", kernel="rbfdot", prob.model=TRUE)
model1 <- ksvm(x, labels, type = "C-svc", kernel="tanhdot", prob.model=TRUE, kpar=list(scale=3.3))
model1
plot(model, data = x, main="SVM classification with RBF Kernel")
plot(model1, data = x, main="SVM classification with Hyperbolic tangent  Kernel ")

## Prediction of test data
pred <- predict(model, test_data[,-ncol(test_data)])
pred1 <- predict(model1, test_data[,-ncol(test_data)])

png(filename="KSVM_Prediction.png", width=980, height=520, units="px")
par(mfrow = c(1,2)) 

plot(test_data[,-3], pch=c("+","-")[pred], xlab="x", col = test_data[,ncol(test_data)], ylab="y", main="SVM Prediction [RBF Kernel]")
legend("topleft", c("Pred+", "Pred-", "Actual+", "Actual-"), pch = c("+","-","Black","Red"),col=c(1,2))

plot(test_data[,-3], pch=c("+","-")[pred1], xlab="x", col = test_data[,ncol(test_data)], ylab="y", main="SVM Prediction [Hyperbolic tangent  Kernel ]")
legend("topleft", c("Pred+", "Pred-", "Actual+", "Actual-"), pch = c("+","-","Black","Red"),col=c(1,2))
dev.off()

## Performance Metrics RBF
KCL1 <- which(pred == 1)
KCL2 <- which(pred == 2)
computePerformanceMetrics(GT1, GT2, KCL1, KCL2)

## Performance Metrics Tanh Kernel
TKCL1 <- which(pred1 == 1)
TKCL2 <- which(pred1 == 2)
computePerformanceMetrics(GT1, GT2, TKCL1, TKCL2)
