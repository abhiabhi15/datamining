

attrData <- read.csv("data/fb_caltech_small_attrlist.csv")
library("akmeans")
clust1=akmeans(attrData,d.metric=2,ths3=0.8,mode=3) ## cosine distance based
