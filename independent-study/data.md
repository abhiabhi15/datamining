
Datasets
=======

For the dynamic attributed graphs community detection, I have explored few datasets of different domain and their attributes,

1. **[DBLP Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/dblp.md):** `(Nodes:authors, Edges:co-authorship)`
2. **[Medline Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/medline-citation.md):** `(Nodes:authors, Edges:co-authorship/citations)`
3. **[Twitter Geography Filtered Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/twitter-data.md):** `(Nodes:users, Edges:followers/friends)`
4. **[Amazon Movie Review Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews.md):** `(Nodes:reviewers, Edges: same product reviews)`
5. **[Bitcoin Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/bitcoin.md):** `(Nodes:users, Edges: transactions)`
6. **[Raleigh Demdebate Dataset](https://github.com/abhiabhi15/datamining/blob/master/independent-study/data/twitter/raleigh_tweets.json):** `(Nodes:users, Edges:followers/friends)`


###Summary:

| Dataset         | Useful Attributes  | Derived Attributes |  Time Attributes | #nodes | #edges | Download Link
|:---------------:|:-----------:|:-------------:|:--------------:|:-------:|:------:|:-------------|
| [DBLP](https://github.com/abhiabhi15/datamining/blob/master/independent-study/dblp.md)| name, journal, title | gender, #papers | year| 2.32M | 10.23M | http://dblp.uni-trier.de/xml/ |    
| [Medline](https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews.md)| name, mesh major, mesh minor | #articles, mesh titles count | year| 240K (articles) |  | https://www.nlm.nih.gov/bsd/sample_records_avail.html |    
| [Twitter Geography](https://github.com/abhiabhi15/datamining/blob/master/independent-study/twitter-data.md)| name, #friends, #followers, location, #tweets, #favorites  | gender | timestamp | 1000 (users) |  | https://dev.twitter.com/rest/public |    
| [Amazon Movie Reviews](https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews.md)| name, id, reviews | genre, genre_count, #reviews, #avg_score | timestamp | 889K | 7.9M | https://snap.stanford.edu/data/web-Movies.html |    
