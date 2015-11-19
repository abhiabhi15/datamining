###Amazon Movie Review Data Report


**Dataset URL :** https://snap.stanford.edu/data/web-Movies.html

**Description:** This dataset consists of movie reviews from amazon. The data span a period of more than 10 years, including all ~8 million reviews up to October 2012. Reviews include product and user information, ratings, and a plaintext review. 

**Dataset Statistics:**   
Number of reviews : 7,911,684  
Number of users : 889,176  
Number of products : 253,059  
Users with > 50 reviews : 16,341  
Median no. of words per review : 101  
Timespan : Aug 1997 - Oct 2012  

**Year Wise Distribution**
<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews/plots/movie_review_year.png"/>
</p>

**Quarter Wise Distribution**  
<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews/plots/movie_review_quarter.png" />
</p>

### Amazon Movie Review Graph
Amazon movie review data can be transformed into attributed graph network data. In this network we have:  
**Nodes** Movie reviewers having attributes such as profile name, number of reviews, avg score, avg help score and genre map.    
**Edges** If two reviews are similar on attributes and have reviewed same product.  

###Movie Review Aggregation

In this approach, we thought of aggregating reviews per movie. This will give us all the reviews related to a particular productId (movies). Then, each movies reviews can be separated in k reviews i.e. first k reviews or last k reviews or k-intervals etc. These k reviews will be taken to form an attributed graph community and such communities reviews and transitions will be monitored for its next or last k reviews.  

**Exploratory Analysis**  
We filtered movie reviews from 2005 to 2011, and the below plots shows the movie reviews distribution in log-plot. We can observe pareto law in the network i.e. 80% of the movies have reviews less than 10-20. 

**Movie Reviews Log Scale Distribution**  
<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews/plots/log_plot_movie_reviews.png" />
</p>

**Movie Review Count Cumulative Distribution**  
<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/amazon-movie-reviews/plots/movie_reviews.png" />
</p>







