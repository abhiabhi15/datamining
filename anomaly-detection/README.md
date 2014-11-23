## NetSimile : A Scalable Approach to Size-Independent Network Similarity

#### Code :       `netsimile.R`
#### R version :  `3.1.0`
#### OS :         `Ubuntu 12.04 (Linux 3.2.0-58-generic)`
#### Author :     `Abhishek`
#### Unity ID :   `akagrawa`


###Algorithm Description
Netsimile[1] is an approach to find similarity between graphs by computing signature vectors that captures most of the features in the aggregated form. These signature vectors can be further used for any data mining methods like clustering, anomaly detection, pattern finding etc. The below implementation is to detect anomaly in the graphs.

Algorithm is implemented into four stages
1. **Feature Extraction** : Seven features which comprises of local network properties of graph is captured in (node **x** feature) matrix.
2. **Feature Aggregation** : Aggregating the above features vectors in 5 different measures and forming a single **signature vector** for  a graph.
3. **Similarity Score** : Computing similarity between signature vectors as distance measure using **canberra** distance and captured as scores.
4. ** Anomaly Detection** :   These scores are then used to detect anomalies by computing moving range average. Points above a threshold are considered as anomalous points in time sequence. Threshold is computed using median + 3 * moving_range_average


## Code Description
The code is written in R script with a main function "netsimile" which detects anomalies implementing all the stages mentioned above. The output file is saved as output_anomaly_graphName for the anomalies detected.

## Usage

* **Install Packages**

```
    install.packages("igraph")
    install.packages("gtools") 
    install.packages("sna")
    install.packages("e1071")

```
For generating graph and finding neighbours, igraph package is needed to be installed

For sorting files in the integer order, gtools package is needed to be installed

For extracting ego network, sna package[4] is needed to be installed

For extracting ego network, sna package[4] is needed to be installed

For aggreagation functions, e1071 package is needed to be installed


* **Run Commands**

````
    rm(list=ls())
    setwd() # Set Directory to the folder where the source code is present
    source("netsimile.R")
    netsimile(directory ="datasets/enron-noempty", graphName = "enron")
```

* **Arguments**

<directory> : This is the directory location of the graph files. It is a mandatory field.

<graphName> : Name of the graph, which is just used for output file name.

* **Input File**

Following is the input file sample for reality_mining_voices/0_voices.txt file which contains first line as no of vertex and no of edges. Below that are vertex-vertex pair connected by an edge. Graph is taken as undirected graph. No changes in input file is required, the code itself takes care of the existing file format.

Input Sample: `reality_mining_voices/0_voices.txt`
```
   107 13
   22 3
   103 3
   106 101
   7 3
   106 4
   14 5
   5 11

   
```

* **Output File**

Output file is stored as output_anomaly_graphName.txt and the sample output contains the number of anomalies in the first line and anamolus time sequence plots and the corresponding graphs in the next lines.

Output sample: `output_anomaly_Reality-Mining Voices.txt`
```
    1
    "16" "16_voices.txt" "17_voices.txt"

```

Here 1 is the number of anomaly detected, which is the 16th scores generated from graph 16_voices.txt and 17_voices.txt 

* **Caveat**

Three different graph sets are tested and since many anomalous points are between 1-15, I have kept the **top 15** anomalies. Not ignored any anomalies since for the large graphs these numbers are not big enough to ignore. But only considered the middle graph as anomalous if there exist adjacent anomalies.


## References
[1] M. Berlingerio, D. Koutra, T. Eliassi-Rad,  and C. Faloutsos,   "NetSimile: A Scalable Approach to Size-Independent Network Similarity",  ;presented at CoRR, 2012. 

[2] Kolaczyk, Eric D., and Gábor Csárdi. Statistical Analysis of Network Data with R. NewYork, NY: Springer New York, 2014. Web.

[3] "Enron Email Network." SNAP: Network Datasets:. N.p., n.d. Web. 01 Nov. 2014.

[4]  http://cran.r-project.org/web/packages/sna/sna.pdf

