## Virus Propagation
---

#### Key Roles

Virus Propagation code is implemented for the following tasks:

1. **Checking for epidemic threshold :** If epidemic threshold of a network(graph) is greater than 1, then epidemic will break out otherwise not.
2. ** Simulation for virus spread  :**  For different transmission probability(beta) and different healing probability(delta), the simulation of virus spread over the contact network.
3. **Immunization policy :** Given fixed number of vaccines, immunzing the network using different immunization policies and then checking for epidemic threshold mention in task1.
4. ** Optimal Number of Vaccines : ** Estimating the minimum number of vaccines required for different immunization policies in order to stop/control virus propagation.
5. ** Simulation of Virus Spread for Immunized Network : ** Running the task2 simulations over the immunized network obtained from task3.
 
----
#####Code : `vprop.R` , `vproplib.R`
#####R version : `3.1.0`
#####OS : `Ubuntu 12.04 (Linux 3.2.0-58-generic)`
##### Author : `Abhishek (Unity id : akagrawa)`
 ---

### Code Description
The code is written in R script with functions for the above mentioned tasks.
### Usage

* Install Packages

```
    install.packages("igraph")
```
For generating graph, igraph package is needed to be installed
###Run Commands
The following command will execute the above mention tasks

````
    rm(list=ls())
    source("vprop.R") ## Locate the vprop.R file with relative to your file system path
```

### Methods 
The following functions are implemented to the perform above tasks. There is no need to run these functions explicitly.

1. To load graph from a file. Output is a igraph graph object.
```
    getGraph(filename) 
```
2. Checking Epidemic Threshold . Output is the the epidemic threshold
```
    epidemicThr(graph, beta, delta)
```   
3. Virus Propagation Simulation. Output is the plot of simulatios over timeticks(iterations).
```
spreadVirus(graph, beta, delta, simulations=1, iterations=10, detail=F)
```
If detail flag is true, the plot and virus propation at each time tick will be displayed.

4. Immunization Policy Simualtion. Output is the epidemic threshold for immunized network if only.graph flag is false.
```
immunization(graph, policy=c("A","B","C","D"), beta, delta, k, only.graph=F)    
```
    k is the number of vaccines

    Here immunization policies are : 
    
    **Policy A:** Select k random nodes for immunization 
    
    **Policy B:** Select the k nodes with highest degree for immunization

    **Policy C:** Select the node with the highest degree for immunization. Remove this node (and its incident edges) from the contact network. Repeat until all vaccines are administered.
    
    **Policy D ** Removal of k nodes corresponding k largest eigen vectors
    
5. Estimating optimal number of vaccines needed wrt to immunization policy. Output is the optimal Vaccine needed.
```
optimalVaccine <- function(graph, policy=c("A","B","C","D"), beta, delta, k, increment=20, plot=T)
```    
plot=T flag will plot the vaccines Vs epidemic threshold plot
---
### Input File Sample: ```static.network ```
```
    5715 10932
    0 1
    2 3
    4 5
    12 13
```
First line denotes the vertex edge pair and the rest of the lines denotes the edge connetion between vertex pair.

### Output Results
s <- epidemicThr(g, beta1, delta1); 
checkVal(s)                       
```
epidemic level
--- Epidemic Threshold :  12.52991  ---- 
Epidemic Threshold reached.. Virus will result in an epidemic
```
Rest of the functions will output a plot.

### References
* For igraph eigen value functions, http://igraph.org/r/doc/graph.eigen.html
* For virus propagation: http://www.cs.cmu.edu/~christos/PUBLICATIONS/PKDD2010VirusProp.pdf
