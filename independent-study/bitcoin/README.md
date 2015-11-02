## Bitcoin Data, and other resources

###Overview
Bitcoin [(bitcoin.org)](https://bitcoin.org/en/) is a digital, cryptographically secure currency. Bitcoin allows users to securely and anonymously retain and transfer value in a decentralized P2P network, and is one of the largest open microeconomic transaction network datasets available. 
What is Bitcoin ? https://www.menufy.com/bitcoin

###Dataset and Sample Code Repository
- A bitcoin dataset extracted from it's inception to April 7, 2012, containing 6.2M nodes and 37M directed, weighted, time-stamped edges. This new dataset, its metadata, and extraction code is available at:[Bitcoin Transaction Network Dataset](http://compbio.cs.uic.edu/data/bitcoin/)

- Useful Bitcoin Data Resources : http://www.coindesk.com/9-useful-bitcoin-data-resources/
These websites provide information on pricing, trading, market capitalisations, blockchain statistics and more. 

- Bitcoin API: Query json data on blocks and transactions. [https://blockchain.info/api]  

###Bitcoin Data Mining and Research Articles and Papers
- [MIT computer scientists can predict the price of Bitcoin](http://news.mit.edu/2014/mit-computer-scientists-can-predict-price-bitcoin).  
 Research paper published [Bayesian regression and Bitcoin](http://arxiv.org/pdf/1410.1231v1.pdf)

- Anomaly Detection in Bitcoin Network Using Unsupervised Learning Methods [Paper Link](http://cs229.stanford.edu/proj2014/Phillip%20Pham,Steven%20Li,%20Anomaly%20Detection%20in%20Bitcoin%20Network%20Using%20Unsupervised%20Learning%20Methods.pdf)
- Ground Truth Theft cases for Bitcoin: https://bitcointalk.org/index.php?topic=576337  


- Unsupervised Learning of Bitcoin Transaction Data. Project Goal is to evaluate the concentration of the Bitcoin network. http://aosc.umd.edu/~ide/data/teaching/amsc663/14fall/amsc663_14proposal_stefan_poikonen.pdf

- Automated Bitcoin Trading via Machine Learning Algorithms. [Price Prediction](http://cs229.stanford.edu/proj2014/Isaac%20Madan,%20Shaurya%20Saluja,%20Aojia%20Zhao,Automated%20Bitcoin%20Trading%20via%20Machine%20Learning%20Algorithms.pdf)  

- Bitcoin Data Analysis using Tweets [https://gigaom.com/2014/04/19/i-analyzed-more-than-a-million-bitcoin-tweets-heres-what-that-looks-like/]  

- Other scholar articles and research papers [link](https://scholar.google.com/scholar?q=bitcoin+data+analysis&hl=en&as_sdt=0&as_vis=1&oi=scholart&sa=X&ved=0CBsQgQMwAGoVChMI_aK9oKKiyAIVSZENCh22CQ8S).


##Exploratory Data Analysis

Dataset: [Bitcoin Transaction Network Dataset](http://compbio.cs.uic.edu/data/bitcoin/)  
Nodes:4.86M, Edges: 25M    (Till Januuary 7, 2013)

**1- user_edges.txt:** transaction_key, user_from_key, user_to_key, timestamp, value(bitcoin)  
**2- transactionkey_list.txt:** transaction_key_string  
   
**Time Series Plot**:    
a) Daily Number of Distinct Transaction  
<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/bitcoin/plots/time-series.png" />
</p>

b) Total BTC Vs USD Transactions (In Log Scale)  
<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/bitcoin/plots/bitcoin-ts.png" />
</p>

###Feature Engineering
Aggregated user level features: Using BTC/USD Conversion Rates.  

- Total USD Sent
- Total USD Received
- Number of Transactions as Sender
- Number of Transactions as Receiver
- Highest Amount Transaction in USD

**Summary Stats of the Features:**  
```
total_usd_sent      total_usd_received  num_sent_txns     num_received_txns highest_usd_txn    
 Min.   :        0   Min.   :        0   Min.   :      0   Min.   :      0   Min.   :      0    
 1st Qu.:        2   1st Qu.:        3   1st Qu.:      2   1st Qu.:      1   1st Qu.:      3     
 Median :       64   Median :       67   Median :      2   Median :      1   Median :     65    
 Mean   :     2418   Mean   :     2418   Mean   :      5   Mean   :      5   Mean   :   2226    
 3rd Qu.:      299   3rd Qu.:      299   3rd Qu.:      2   3rd Qu.:      1   3rd Qu.:    289    
 Max.   :205196208   Max.   :204216064   Max.   :4871033   Max.   :4886174   Max.   :8014082   
```

**Basic K-Means Clustering:**  

- Random sample of 800,000 users out of 4.84M users
- Scaled using scale function

**Elbow plot for K-means cluster for Optimal Clusters:**

<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/bitcoin/plots/kmeans_elbow.png" />
</p>

**Fixing clustering parameter,k =6**  
Clustering Results:
```
    1       2       3        4       5       6 
   8480   31481 4798163      56    3758      62 
```

- From the ground-truth data, for Oct-2011 Mt. Fox theft: One user-id clustered in cluster-6, rest ~40-45 users clustered in cluster-3
- Better pre-processing technique, along with other features can potentially identify such thefts
- Other clustering algorithms should be tested


