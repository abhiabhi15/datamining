
getSimAttrMatrix <- function(attrvalue){
  sim <- matrix(0, nrow=vcount(g), ncol=vcount(g))
  for(i in 1:vcount(g)){
    sim[i,] <- ifelse(attrValue[i] == attrValue, 1,0)  
  }
  return(sim)  
}
