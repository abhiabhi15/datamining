# Java Hadoop Program for Vertex Degree Count
 
 In this problem, the map reduce functions are implemented using Hadoop Map-reduce framework to compute the degree of the vertices provided in the graph 
 
 Jar File : mapreduce-1.0.jar
 
 Java Version : 1.7.0_67
 
 Hadoop Version : 1.2.1

## Code Description
 The code is packaged under mapreduce-1.0.jar which is build using maven builder. Maven Hadoop 1.2.1 dependency is added for the project. VetexDegree.java files contains the controlling part of Hadoop job for the above problem.


## Usage

* Hadoop Run Command

````
    bin/start-all.sh
````
This command execution will starts the namenode, datanode, secondary node, job executor in the hadoop cluster-set. This will enable the ports to load data and perform map-reduce operations


* HDFS Data Load Command

```
   bin/hadoop dfs -copyFromLocal /input-folder /input
```

This command execution will load data in HDFS filesystem. Here input-folder must contains the required graphs.

* Executing Map-Reduce Job

```
    bin/hadoop jar mapreduce-1.0.jar main.java.VertexDegree /input /output
```

This command runs the hadoop map-reduce program from the file VertexDegree.java with two mandatory  arguments as input path and output location at HDFS 

* Merge output into AFS Filesystem

```
    bin/hadoop dfs -getmerge /output /output.txt
```
This command generates a readable output.txt file from the /output in HDFS File system.


## References
http://hadoop.apache.org/docs/r1.2.1/mapred_tutorial.html


