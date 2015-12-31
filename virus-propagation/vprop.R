#### Virus Propagation #################
#
#  @author : abhishek
#  @unityid : akagrawa
#  Note : Please refer README.md file for the code usage

# Loading the library file
source("vproplib.R")

### Variable Declarations
beta1 <- 0.20
delta1 <- 0.70
beta2 <- 0.01
delta2 <- 0.60
k1 <- 200

## Program Variables
g <- getGraph(x="static.network")
ev <- graph.eigen(g, which=list(pos="LA", howmany=1))$values
v <- vcount(g)

##########################################
## Option 1 Code
## Problem 1
## a) Epidemic Threshold : beta1 = 0.20 , delta1 = 0.70
s <- epidemicThr(g, beta1, delta1)          # Epidemic Threshold
checkVal(s)                                 # Checking if threshold crossed epidemic level   

## b) Keeping delta constant, varying beta 
es <- c()
betaSeq <- seq(0.005, 0.05, 0.001)
for(beta in betaSeq){
   es <- append(es, epidemicThr(g, beta, delta1))
}
# Plot of the above results
xlab <- paste("Transmission Probability(beta)" ,paste(paste( " [ Constant Delta = ", delta1), " ]"))
plot(betaSeq, es, pch = 20, col = "blue", xlab=xlab, ylab="Epidemic Threshold (s)", main="Epidemic Threshold Vs Transmission Probability(SIS VPM)")
beta <- round(((1/ev) * delta1), 3)
abline(h=1, col = "red"); abline(v= beta, col ="dark green")
text(paste("Minimum beta ", beta, sep=": ") , y=1.1 , x= beta + 0.015, col ="dark green")

# c) Keeping beta constant, vary delta 
es <- c()
deltaSeq <- seq(8, 10, 0.1)
for(delta in deltaSeq){
    es <- append(es, epidemicThr(g, beta1,delta))
}

# Plot of the above results
xlab <- paste("Healing Probability(delta)" ,paste(paste( " [ Constant Beta = ", beta1), " ]"))
plot(deltaSeq, es, pch = 20, col = "blue", xlab=xlab, ylab="Epidemic Threshold (s)", main="Epidemic Threshold Vs Healing Probability(SIS VPM)")
delta <- round((ev * beta1), 3)
abline(h=1, col = "red"); abline(v= delta, col ="dark green")
text(paste("Maximum delta ", delta, sep=": ") , y=1.01 , x= delta + 0.5, col ="dark green")

## Repeating above process for beta2 and delta2
# d) For beta2 = 0.01 , delta2 = 0.60
s <- epidemicThr(g, beta2, delta2)  # Epidemic Threshold
checkVal(s)                         # Checking if threshold crossed epidemic level   

# Keeping delta constant, vary beta 
es <- c()
betaSeq <- seq(0.005, 0.05, 0.001)
for(beta in betaSeq){
    es <- append(es, epidemicThr(g, beta,delta2))
}

# Plot of the above results
xlab <- paste("Transmission Probability(beta)" ,paste(paste( " [ Constant Delta = ", delta2), " ]"))
plot(betaSeq, es, pch = 20, col = "blue", xlab=xlab, ylab="Epidemic Threshold (s)", main="Epidemic Threshold Vs Transmission Probability(SIS VPM)")
beta <- round(((1/ev) * delta2), 3)
abline(h=1, col = "red"); abline(v= beta, col ="dark green")
text(paste("Minimum beta ", beta, sep=": ") , y=1.1 , x= beta + 0.02, col ="dark green")

# Keeping beta constant, vary delta 
es <- c()
deltaSeq <- seq(0.1, 1, 0.05)
for(delta in deltaSeq){
   es <- append(es, epidemicThr(g, beta2, delta))
}

# Plot of the above results
xlab <- paste("Healing Probability(delta)" ,paste(paste( " [ Constant Beta = ", beta2), " ]"))
plot(deltaSeq, es, pch = 20, col = "blue", xlab=xlab, ylab="Epidemic Threshold (s)", main="Epidemic Threshold Vs Healing Probability(SIS VPM)")
delta <- round((ev * beta2), 3)
abline(h=1, col = "red"); abline(v= delta, col ="dark green")
text(paste("Maximum delta ", delta, sep=": ") , y=1.3 , x= delta + 0.2, col="dark green")

########################################

## Option 1 Problem 2
## Simulation of virus spread and plot of average infected nodes
## Simulation for beta1 =0.2, delta1=0.7 
spreadVirus(graph=g, beta=beta1, delta=delta1, simulations=10, iterations=100) # Virus Spread Simulation Function
## Simulation for beta2 =0.01, delta2=0.6 
spreadVirus(graph=g, beta=beta2, delta=delta2, simulations=10, iterations=100)

#######################################

## Option 1 Problem 3
### For Immunization Policy
##  Problem 3 d)  Immunizations using different policy
# Policy A: Select k random nodes for immunization
set.seed(10)
s <- immunization(graph=g, policy="A", beta=beta1, delta=delta1, k=k1) # Immunization function for different policy
checkVal(s)

# Policy B: Select the k nodes with highest degree for immunization.
s <- immunization(graph=g, policy="B", beta=beta1, delta=delta1, k=k1)
checkVal(s)

# Policy C: Select the node with the highest degree for immunization. Remove this node (and its incident edges) from the contact network. Repeat until all vaccines are administered.
s <- immunization(graph=g, policy="C", beta=beta1, delta=delta1, k=k1)
checkVal(s)

# Policy D: Removal of k nodes corresponding k largest eigen vectors
s <- immunization(graph=g, policy="D", beta=beta1, delta=delta1, k=k1)
checkVal(s)

######################################

# Problem 3 e) Finding optimal Number of vaccines Policy A
k <- optimalVaccine(graph=g, policy="A", beta=beta1, delta=delta1, k=1, increment=100, plot=T) # Function to find optimal Number of vaccines
k <- optimalVaccine(graph=g, policy="A", beta=beta1, delta=delta1, k=k-100, increment=1, plot=F)
text( paste("Minimum Vaccine Needed : ", k) , y=12 , x= k-1400, col="dark blue")

# Problem 3 e) Finding optimal Number of vaccines Policy B
k <- optimalVaccine(graph=g, policy="B", beta=beta1, delta=delta1, k=1, increment=20, plot=T)
k <- optimalVaccine(graph=g, policy="B", beta=beta1, delta=delta1, k=k-20, increment=1, plot=F)
text( paste("Minimum Vaccine Needed : ", k) , y=10 , x= k-70, col="dark blue")

# Problem 3 e) Finding optimal Number of vaccines Policy C
k <- optimalVaccine(graph=g, policy="C", beta=beta1, delta=delta1, k=100, increment=40, plot=T)
k <- optimalVaccine(graph=g, policy="C", beta=beta1, delta=delta1, k=k-40, increment=1, plot=F)
text( paste("Minimum Vaccine Needed : ", k) , y=1.3 , x= k-50, col="dark blue")

# Problem 3 e) Finding optimal Number of vaccines Policy D
k <- optimalVaccine(graph=g, policy="D", beta=beta1, delta=delta1, k=3000, increment=100, plot=T)
k <- optimalVaccine(graph=g, policy="D", beta=beta1, delta=delta1, k=k-20, increment=1, plot=F)
text( paste("Minimum Vaccine Needed : ", k) , y=1.7 , x= k-650, col="dark blue")

######################################

# Problem 3 f) Running virus spread simulation over immunized network
# Running simulation for policy A immunized network
pAgraph <- immunization(graph=g, policy="A", beta=beta1, delta=delta1, k=k1, only.graph=T)
spreadVirus(graph=pAgraph, beta=beta1, delta=delta1, simulations=10, iterations=100)

# Running simulation for policy B immunized network
pBgraph <- immunization(graph=g, policy="B", beta=beta1, delta=delta1, k=k1, only.graph=T)
spreadVirus(graph=pBgraph, beta=beta1, delta=delta1, simulations=10, iterations=100)

# Running simulation for policy C immunized network
pCgraph <- immunization(graph=g, policy="C", beta=beta1, delta=delta1, k=k1, only.graph=T)
spreadVirus(graph=pCgraph, beta=beta1, delta=delta1, simulations=10, iterations=100)

# Running simulation for policy D immunized network
pDgraph <- immunization(graph=g, policy="D", beta=beta1, delta=delta1, k=k1, only.graph=T)
spreadVirus(graph=pDgraph, beta=beta1, delta=delta1, simulations=10, iterations=100)

#########################################################
#########################################################
