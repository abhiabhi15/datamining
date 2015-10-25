###Independent Study Coursework :  CSC630
====
###Datasets

For the dynamic attributed graphs community detection, I have explored few datasets of different domain and their attributes,

1. **[DBLP Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/dblp.md):** `(Nodes:authors, Edges:co-authorship)`
2. **[Medline Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/medline-citation.md):** `(Nodes:authors, Edges:co-authorship/citations)`
3. **[Twitter Geography Filtered Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/twitter-data.md):** `(Nodes:users, Edges:followers/friends)`
4. **[Amazon Movie Review Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews.md):** `(Nodes:reviewers, Edges: same product reviews)`
5. **[Bitcoin Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/bitcoin.md):** `(Nodes:users, Edges: transactions)`
6. **[Raleigh Demdebate Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/data/twitter/raleigh_tweets.json):** `(Nodes:users, Edges:followers/friends)`


####Summary:

| Dataset         | Useful Attributes  | Derived Attributes |  Time Attributes | #nodes | #edges | Download Link
|:---------------:|:-----------:|:-------------:|:--------------:|:-------:|:------:|:-------------|
| [DBLP](https://github.com/abhiabhi15/datamining/blob/master/independent-study/dblp.md)| name, journal, title | gender, #papers | year| 2.32M | 10.23M | http://dblp.uni-trier.de/xml/ |    
| [Medline](https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews.md)| name, mesh major, mesh minor | #articles, mesh titles count | year| 240K (articles) |  | https://www.nlm.nih.gov/bsd/sample_records_avail.html |    
| [Twitter Geography](https://github.com/abhiabhi15/datamining/blob/master/independent-study/twitter-data.md)| name, #friends, #followers, location, #tweets, #favorites  | gender | timestamp | 1000 (users) |  | https://dev.twitter.com/rest/public |    
| [Amazon Movie Reviews](https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews.md)| name, id, review score, helpfulness | genre, genre_count, #reviews, #avg_score | timestamp | 889K | 7.9M | https://snap.stanford.edu/data/web-Movies.html |    
| [Bitcoin Network](https://github.com/abhiabhi15/datamining/blob/master/independent-study/bitcoin.md)| sender-id, receiver-id, amount($B) | amt($USD) | timestamp | 6.2M | 37M | http://compbio.cs.uic.edu/data/bitcoin/bitcoin_uic_data_and_code_20130107.zip |    

##Community Detection Algorithms
===
1. **[LabelRank & LabelRankT](https://github.com/abhiabhi15/datamining/blob/master/independent-study/papers/LabelRank:%20A%20Stabilized%20Label%20Propagation.pdf):** Dynamic Graph Community Detection Algorithm    
   Code: [Labelrank R Implementation](https://github.com/abhiabhi15/datamining/tree/master/independent-study/code/labelrank)  
   Analysis: [Results and Discussion on Labelrank](https://github.com/abhiabhi15/datamining/blob/master/independent-study/algorithms/labelrank.md)    
   
2. **[SAC (Structure-Attribute Clustering)](https://github.com/abhiabhi15/datamining/blob/master/independent-study/papers/Community%20detection%20based%20on%20structural%20and%20attribute%20similarities.pdf):** Static Attributed Graph Community Detection Algorithm  
   Code: [SAC1 R Implementation](https://github.com/abhiabhi15/datamining/tree/master/independent-study/code/sac)  
   Analysis: [Results and Discussion on SAC](https://github.com/abhiabhi15/datamining/blob/master/independent-study/algorithms/sac.md)      


