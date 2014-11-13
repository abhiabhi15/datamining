twoCrossConfusionMatrixMetrics <-
function(mat){
if((nrow(mat)!=2)&(ncol(mat)!=2)){
print("Not a 2X2 Matrix")
}
else
{
f11=mat[1,1]
f10=mat[1,2]
f01=mat[2,1]
f00=mat[2,2]
T = sum(mat)
AandB= colSums(mat)
CandD = rowSums(mat)

#List of Performance Metrics
a = (f11+f00)/T
ER = (f10+f01)/T
TPR=f11/CandD[1]
TNR=f00/CandD[2]
FPR=f01/CandD[2]
FNR=f10/CandD[1]
PrecisionPositive=f11/AandB[1]
PrecisionNegative=f00/AandB[2]
FMeasurePositive = (2*PrecisionPositive*TPR)/(PrecisionPositive+TPR)
FMeasureNegative = (2*PrecisionNegative*TNR)/(PrecisionNegative+TNR)
GMean=sqrt(TPR*TNR)
return(list("Accuray"=a,"Error Rate"=ER,"True Positive Rate"=TPR,"True Negative Rate"=TNR,"False Positive Rate"=FPR,"False Negative Rate"=FNR,"Precision+"=PrecisionPositive,"Precision-"=PrecisionNegative,"F-measure+"=FMeasurePositive,"F-measure-"=FMeasureNegative,"G-Mean"=GMean))
}



}

