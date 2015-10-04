## Community Detection using Speaker-Listener Label Propagation Algorithm

The algorithm implememts a method to find the overlapping communties and overlapping nodes extending the label propagation algorithm

###Algorithm Description
Algorithm is implemented into three stages
1. Initialization stage : For initializing the label as vertex-id
2. Evolution stage : Multiple iterations to get multiple labels in node memory
3. Post-processing stage : Deleting less probable labels and combining common nodes to form a community


####Code : `spla.R`
####R version : `3.1.0`
####OS : `Ubuntu 12.04 (Linux 3.2.0-58-generic)`
#### Author : `Abhishek
 

## Code Description
The code is written in R script with two functions which converts input file to graph and then process the graph to detect overlapping community using SLPA alsgorithm steps mentioned above. The output file is saved as communitiies.txt for ground truth verification and goodness metrics.

## Usage

* Install Packages

```
    install.packages("igraph")
```
For generating graph, igraph package is needed to be installed

* Run Commands

````
    rm(list=ls())
    source("slpa.R")
    spla(filename ="filename.graph", iters=20, r=0.0003)
```

* Arguments

<filename> : This command execution will read the graph file and load the corresponding graph using getGraph() function implemented internally. Then it follows the stages as mentioned above. Default: youtube.graph.small 

<iters> : It is the number of iterations in the evolution stage for having multiple labels in node memory. Default=20, as per the minimum described in the paper

<r> : It is a criterion for deleting nodes which have less overall probability of occurences. r lies between [0, 1]. Higher values of r, results in disjoint community of very small sizes.
Default r=0.0003 for youtube small graph to get overlapping communities

* Input File

Following is the input file sample for youtube.graph.small file which contains first line as no of vertex and no of edges. Below that are vertex-vertex pair connected by an edge. Graph is taken as undirected graph.

Input Sample: `youtube.graph.small`
```
    2501 2022
    0 1
    2 3
    2 4
    2 5
   
```

* Output File

Output file is stored as communities.youtube.graph.small.txt and the sample output contains the output communties of youtube.graph.small graph. 

Output sample: `communities.youtube.graph.small.txt`
```
   2 '6' 7 8 11 19 20 22 23 24 26 29
   2 4 '6' 7 8 9 10 11 12 13 14 15 16 17 18 19 20 22 23 24 25 26 27 28 29 153 155

   3 '145' 146 147 148 149 150 151 152
   3 '145' 146 148 149 150 151 152


    70 502 602 1314 1315 1316 1317 1318 1403

```

Here many nodes are overlapping nodes in the above sample just like the highlighted 6 and 145. Thus giving us overlapping community and overlapping nodes.


* Performance Metric

```
python metrics.py <graph_file> <groundtruth_file> <communities_file> <output_file>
```
where:

<graph_file> the file containing the edge list of the graph
<groundtruth_file> is the file containing the ground truth communities,
<communities_file> is the file containing the communities identified with the community detection algorithm
<output_file> is the file prefix for the metrics results (two files will be created <output_file>.pmetrics.csv and <output_file>.gmetrics.csv

Please refer youtube.small.pmetrics.csv and youtube.small.gmetrics.csv file for sample performance metrics. The better peformance can be achieved with the variation of parameters.

* Caveat

To obtain disjoint communities, values of r can be changed. Hence with various r values we can control community size and nature(joint and disjoint). To encounter overlapping communities the value of r has been taken in below ranges.


## References
* Slpa: Uncovering Overlapping Communities In Social Networks Via A, and Speaker-Listener Interaction Dynamic Process. "Jierui Xie and Boleslaw K. Szymanski." (n.d.): n. pag. Web.
* Ana, Ig Data. "LabelRank: A Stabilized Label Propagation Algorithm for Community Detection in Networks." Web.
* Zhao, Yunpeng. "Community Extraction for Social Networks." Proceedings of the National Academy of Sciences of the United States of America 108.18 (2011): 7321-326. Web. 
* Kolaczyk, Eric D., and Gábor Csárdi. Statistical Analysis of Network Data with R. NewYork, NY: Springer New York, 2014. Web.

