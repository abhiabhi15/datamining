### Twitter Data For Meaningful Community Detection :

The key idea is to find meaningful communities in attributed twitter user network that have similar interests, opinions etc. that are eventually derived through their tweets. Such robust communities opinions can be used as recommendation units for similar communities.   

In meaningful robust communities, we have a hypothesis that they will have higher degree of tweet similarities as compare to the random sampled user group tweets. In this manner, we can tune our community detection methods with the tweet similarity measures as a ground truth.   

Approaches for gathering data: Graph nodes and edges will be same as described in previous section.  

**Approach-1:**
To collect twitter data, there is a challenge of collecting a good sampled data, and for this particular case, the twitter users. Those users can be sampled based on their location, tweet status and other query parameters. 
But collecting such samples using twitter search API queries are :  
- limited with the number of calls and result size for a given window time.  
- limited overall result set.(Eg. users/search will result max 1000 matching users).  
- Maximum celebrity and organization/group pages

Hence tracking such user communities using this approach might not be provide robust communities for recommendation.  

**Approach 2:**
In this approach, we follow the steps as below:  
**Step 1:**Collect tweets for a given track words and extract tweets and user related attributes from the resultant tweet objects.   
**Step 2:** Fix those users, and massage their attributes to have some meaningful semantics such as age, gender, actual location etc. Those attributed users will behave as attributed nodes in the graph and the user’s followers/friends relationship will hold as a graph edge.   
**Step 3:** Find communities using graph community detection algorithms.  
**Step 4:** Check tweets similarities of the tweets  

Such connected social network graph will then be used as an input for detecting meaning communities. Finally the obtained communities tweet similarity metrics will be used for comparing the robustness of communities.   

####Experiment: For the above approach, I collected the tweets for some specific words/hashtags.  

Collected tweets for the track words :   
```
['DataScience','BigData','DataScientist','Analytics','Python','MachineLearning',
'Statistics','rstats','DataMining','DataAnalytics','DataAnalysis','PredictiveAnalytics',
'SmartCity','IOT','hadoop','dataviz','DeepLearning','BusinessIntelligence’]
```

For one hour: 6PM -7PM EST   
Total Tweets : 2678  
Total Unique Users with lang:english tweets : 1395 (fixed)  

**User Attributes:**
Extracted few user specific attributes = [name, screen_name, followers_count, friends_count, status_count, status]  

**Derived Attributes:**
Gender : Used 3rd party API to get gender  for the first token of the name attribute   https://market.mashape.com/montanaflynn/gender-guesser  

**Followers and Friends Network:**  Now to get all the friends and followers of the fixed users, we can use the followers/ids and friends/ids API for the given user_id or screen_name
https://dev.twitter.com/rest/reference/get/friends/ids  

**Limitations:**
- API call rate limit i.e. 15 calls per 15 min window  
- Returns maximum 5000 friends/followers in one API call, need to re-call the same API using next cursors  


**For 1395 Users :**

**Friends Distribution**  

<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/plots/twitter/friends.png"/>
</p>

```
  Min.     1st Qu.   Median     Mean        3rd Qu.       Max. 
   0.0     110.2     378.0      1493.0      1298.0     100700.0 
```


**Followers Distribution**
<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/plots/twitter/followers.png"/>
</p>

```
  Min. 1st Qu.  Median    Mean    3rd Qu.    Max. 
   0     112     441      3678    1682       567200
```


**ISSUES**
- To get all the friends and followers of these users, the api calling script will need to run for ~50-60 hrs continuously
- Re-constructing such user network is time-expensive 
