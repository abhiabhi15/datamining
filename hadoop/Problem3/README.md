## Java Hadoop Program for Degree Frequency

The problem is divided into two main parts :
1. Map-Reduce jobs for degree frequency computation
2. Scale free graph tests 
 
 
In the first problem, the map reduce functions are implemented using Hadoop Map-reduce framework to compute the degree of the vertices provided in the graph followed by another map-reduce job to count the frequency of each degree
 
 Jar File : mapreduce-1.0.jar
 
 Java Version : 1.7.0_67
 
 Hadoop Version : 1.2.1

## Code Description
 The code is packaged under mapreduce-1.0.jar which is build using maven builder. Maven Hadoop 1.2.1 dependency is added for the project. VetexDegree.java files contains the controlling part of Hadoop job for the vertex-degree mapping and DegreeFrequency.java performs the task of calculating the degree frequency using another set of map-reduce job.


## Usage

* Hadoop Run Command

````
    bin/start-all.sh
````
This command execution will starts the namenode, datanode, secondary node, job executor in the hadoop cluster-set. This will enable the ports to load data and perform map-reduce operations


* HDFS Data Load Command

```
   bin/hadoop dfs -copyFromLocal /opt-stanford /input
```

This command execution will load data in HDFS filesystem. Here /opt/stanford is the sample input folder name which contains required graphs. In order to load separate graphs in HDFS, the input file must contain that particular graph for a job execution period.

* Executing Map-Reduce Job

```
    bin/hadoop jar mapreduce-1.0.jar main.java.Executor /input /temp /output
```

This command runs the hadoop map-reduce program from the file Executor.java with three mandatory  arguments as input path, temp path and output location at HDFS. It runs the two map-reduce jobs sequentially i.e. it calls VertexDegree.java and DegreeFrequency.java respectively. 

* Merge output into AFS Filesystem

```
    bin/hadoop dfs -getmerge /output /output.txt
```
This command generates a readable output.txt file from the /output in HDFS File system which contains the <Key,Value> as <Degree, Frequency> of the given graph.


## Scale Free Graphs

A scale-free graph is one with a power-law degree distribution. For the graphs to qualify for scale-free most of its degree must follow the power-law. For the graphs given in this problem, we need to test the degree distribution to check if it follows the power law or not. Here such graphs are plotted as a log-log plot using R script where each degree points is tested against power law, i.e. the ratio of a kth degree frequency wrt to all the degree frequency should lie between (1/k) power of 2 and 3. 

To run this script, load R session in R studio or any R IDE.

* Loading R script
```
    source("Project1_p3.R")
```
This command will load the above R file and all the functions and variable will be loaded in the current R session.

* Executing plotgraph function
```
    plotgraph("amazon")
```

This graph will search for the file "amazon.txt" in the current folder and will load the data of amazon <Degree, Count> file in R Session. And after certain internal transformation and power law test, it will plot a scatter plot and save as with the file name amazon.png in the current folder.
Please refer the R script in the code folder for more details and code understanding.


## RMAT Graphs : Random Graphs

RMAT is a graph generator framewok which exposes certain APIs to generate random, SSCALE and scale-free graphs. In order to generate those graphs, we need to modify there config for the no of vertices and edges. It also provides probabilistic distribution configuration of the edges for the graph to be generated which leads us to generate scale free graphs as well.

To generate graphs through RMAT, following are the commands:

* Random graph generation

``` 
    $GTgraph_HOME/random/GTgraph-random -c $GTgraph_HOME/random/config -output         

```

This command generates a random graph with the desired configuration of no of edges and vertices and stores the output in the file output

* RMAT graph generation

```
    $GTgraph_HOME/rmat/GTgraph-rmat -c $GTgraph_HOME/rmat/config -output         

```

This command generates a rmat graph which is scale free graphs with the desired configuration of no of edges and vertices and stores the output in the file output

* Transformation of RMAT Graph into Vertex-Vetex format, using project1_p3_RMAT.R script
```
  transform("filename", "output")
```
The above command is executed in R session after loading the project1_p3_RMAT.R script(Please find it in code folder). It takes arguments of filename which is to be transformed and the output filename

* Test For Scale Free

For this test, we can again follow the same commands as shown above in PART-1 since the graph generated is transformed as the input for the PART-1 problems. After this, the plotgraph command in R session will plot the graphs showing the scale-free degrees.

## References
* http://hadoop.apache.org/docs/r1.2.1/mapred_tutorial.html
* http://blogs.msdn.com/b/avkashchauhan/archive/2012/03/29/how-to-chain-multiple-mapreduce-jobs-in-hadoop.aspx
* http://mathinsight.org/scale_free_network

