###User attributed Data Collection of Twitter users

Twitter provides several REST API for the user based search queries and the full object retrieval APIs for the followers and friends of a particular user.  

For the dynamic attributed network at time t,     
**Graph Nodes:** Twitter users having attributes as location, screen_name, tweets_count, favorites_count etc.  
**Graph Edges:** The followers(people who follow the user) and friends(whom the user follows) links  

Now, we need twitter users search criteria at time t, and their followers and friends linkages to monitor the growth or shrinkage of this network at different time interval. 

**Following are the steps taken so far:**  

**Data Sampling:**  
Given the billion user base of twitter, both actual users and promotional pages as users, it is required to have an effective sampling or filtering technique to have a good sample population to try out the experiments. We can use different search APIs to get the user sample as described below:  

**GET search/tweets :** We can get tweets given a search criteria for a particular place, hashtags, words/phrases and then get the user for those tweet status owners. But such users communities might be hard to track as they are based on tweets search criteria which are based on current trends.  

**GET users/search :** This is also a similar search based API but instead of tweets, we get twitter users based on different search criteria such as location, tweet status, etc. Here we can provide location based queries that takes geocodes as input and returns user profiles.  


**Location based samples:**  

We can query the user given a geocode location as query parameters. The response is limited to 20 users per request and 180 such requests can be made within a 15-min window.

**Sample Query in Node.js:**  

```
Twitter.get('users/search', { q: 'geocode:40.746696,-73.990173,5mi' ,page:1 }, function(err, data, response) {
	console.log(data);
})
```  

For a given page id, we get the same users. Here the geocode query takes latitude, longitude and radial range to filter users.  


**Geocode:** To get the geocode of a place, there are several APIs and websites that provides these coordinates given a valid place.   
Here, I used http://itouchmap.com/latlong.html service, which allows us to pin-point the location and get the co-ordinate data for that location using map interface.   

**Example Cases:**  

Dense User Location :  NY, Manhattan [ 40.746696,-73.990173] , radius = 1mi
	For page:1, we get some of the top users of the location, and parsed the key information of the users.
		
20 Users Data for Page-1
Screen Name =MTV, followers = 12767936, location = NYC, friends = 31886
Screen Name =nytimes, followers = 19107280, location = New York City, friends = 993
Screen Name =Forbes, followers = 6550448, location = New York, NY, friends = 5273
Screen Name =WSJ, followers = 7167464, location = New York, NY, friends = 1010
Screen Name =NewYorker, followers = 5502321, location = New York, NY, friends = 330
Screen Name =TEDTalks, followers = 6534261, location = New York, NY, friends = 390
Screen Name =EW, followers = 3937632, location = New York, NY, friends = 5653
Screen Name =BuzzFeed, followers = 2480619, location = New York, friends = 3039
Screen Name =verge, followers = 977154, location = New York, friends = 121
Screen Name =HillaryClinton, followers = 4139247, location = New York, friends = 143
Screen Name =NateSilver538, followers = 1250636, location = New York, friends = 767
Screen Name =UN, followers = 4666720, location = New York, NY, friends = 984
Screen Name =FastCompany, followers = 1888843, location = New York, NY, friends = 3950
Screen Name =RollingStone, followers = 4696969, location = New York, New York, friends = 258
Screen Name =WIRED, followers = 5008788, location = San Francisco/New York, friends = 229
Screen Name =VanityFair, followers = 2381308, location = New York, NY, friends = 1015
Screen Name =billclinton, followers = 4023599, location = New York, NY, friends = 11
Screen Name =neiltyson, followers = 4156189, location = New York City, friends = 44
Screen Name =FareedZakaria, followers = 615131, location = New York, NY, friends = 394
Screen Name =NYTimeskrugman, followers = 1423573, location = New York City, friends = 2

Observations:
Here the users are mostly same for a fixed co-ordinates and page id
For page ids > 1, we get different users with mostly decreasing order of #followers
For such dense location users, the followers count are in millions and spread all across the world
Most of such user profiles belongs to celebrities or popular groups

b. Sparse User location: NC State - Centennial Campus, Raleigh [35.767745,-78.675585]

20 Users Data for Page-1
Screen Name =newsobserver, followers = 76438, location = Raleigh, NC, friends = 412
Screen Name =PackFootball, followers = 54633, location = Raleigh, N.C., friends = 397
Screen Name =PackAthletics, followers = 42467, location = Raleigh, N.C., friends = 547
Screen Name =PackMensBball, followers = 45367, location = Raleigh, N.C., friends = 183
Screen Name =StateCoachD, followers = 24816, location = Raleigh, NC, friends = 1365
Screen Name =NCStateBaseball, followers = 29691, location = Raleigh, N.C., friends = 179
Screen Name =NCStateNews, followers = 22277, location = Raleigh, North Carolina, friends = 466
Screen Name =DowntownRaleigh, followers = 21781, location = Downtown Raleigh, NC, friends = 11067
Screen Name =PNCArena, followers = 5367, location = Raleigh, NC, friends = 281
Screen Name =therealcliffyb, followers = 303512, location = Raleigh, NC, friends = 1755
Screen Name =samruby, followers = 3266, location = Raleigh, NC, friends = 61
Screen Name =WKNC881, followers = 8965, location = Raleigh, NC, friends = 458
Screen Name =PackVball, followers = 5054, location = Raleigh, N.C., friends = 185
Screen Name =NCStateEngr, followers = 4218, location = Raleigh, NC, friends = 164
Screen Name =wolfpackclub, followers = 11855, location = Raleigh, NC, friends = 183
Screen Name =NCStateAlumni, followers = 11729, location = Raleigh, NC, friends = 326
Screen Name =statefansnation, followers = 13080, location = Raleigh, NC, friends = 1109
Screen Name =NCStateVetMed, followers = 8704, location = Raleigh, NC, friends = 1902
Screen Name =NCSUTechnician, followers = 5455, location = Raleigh, N.C., friends = 386
Screen Name =PackWomensBball, followers = 5506, location = Raleigh, N.C., friends = 502

Observations:
Less number of followers as compare to densely populated and popular area
For pageid > 10, we can have #followers couple of hundreds
The growth of the communities will be slow

Followers and Friends Network:

Now to get the followers and friends of a user obtained from above criteria, we can use another set of twitter API.

GET friends/list: Returns a cursored collection of user objects(max 200 at a time) for every user the specified user is following. 
GET followers/list : Returns a cursored collection of user objects(max 200 at a time) for users following the specified user.
But these APIs have rate limit issues. Only 15 such calls can be made in a 15 min window.

Here we need to apply a filter for those followers and friends out of that radius. Also we need to analyze the data distribution before exploring and applying such filters.

Limitations: 
On user/search we can get only 1000 matching users. These users will be mostly celebrities or organization/group pages.

After meeting with Dr. Samatova :

Twitter Data For Meaningful Community Detection :

The key idea is to find meaningful communities in attributed twitter user network that have similar interests, opinions etc. that are eventually derived through their tweets. Such robust communities opinions can be used as recommendation units for similar communities.

In meaningful robust communities, we have a hypothesis that they will have higher degree of tweet similarities as compare to the random sampled user group tweets. In this manner, we can tune our community detection methods with the tweet similarity measures as a ground truth. 

Approaches for gathering data: Graph nodes and edges will be same as described in previous section.

Approach-1: 
To collect twitter data, there is a challenge of collecting a good sampled data, and for this particular case, the twitter users. Those users can be sampled based on their location, tweet status and other query parameters. 
But collecting such samples using twitter search API queries are :
limited with the number of calls and result size for a given window time.
limited overall result set.(Eg. users/search will result max 1000 matching users).
Maximum celebrity and organization/group pages
Hence tracking such user communities using this approach might not be provide robust communities for recommendation.

Approach 2:
In this approach, 
Step 1 : Collect tweets for a given track words and extract tweets and user related attributes from the resultant tweet objects. 
Step 2 : Fix those users, and massage their attributes to have some meaningful semantics such as age, gender, actual location etc. Those attributed users will behave as attributed nodes in the graph and the user’s followers/friends relationship will hold as a graph edge. 
Step 3: Find communities using graph community detection algorithms
Step 4: Check tweets similarities of the tweets

Such connected social network graph will then be used as an input for detecting meaning communities. Finally the obtained communities tweet similarity metrics will be used for comparing the robustness of communities. 



Experiment: For the above approach, I collected the tweets for some specific words/hashtags.

Collected tweets for the track words : 
['DataScience','BigData','DataScientist','Analytics','Python','MachineLearning','Statistics','rstats','DataMining','DataAnalytics','DataAnalysis','PredictiveAnalytics','SmartCity','IOT','hadoop','dataviz','DeepLearning','BusinessIntelligence’]

For one hour : 6PM -7PM EST 
Total Tweets : 2678
Total Unique Users with lang:english tweets : 1395 (fixed)

User Attributes:
Extracted few user specific attributes = [name, screen_name, followers_count, friends_count, status_count, status]

Derived Attributes: 
Gender : Used 3rd party API to get gender  for the first token of the name attribute https://market.mashape.com/montanaflynn/gender-guesser

Followers and Friends Network:  Now to get all the friends and followers of the fixed users, we can use the followers/ids and friends/ids API for the given user_id or screen_name
https://dev.twitter.com/rest/reference/get/friends/ids

Limitations: 
API call rate limit i.e. 15 calls per 15 min window
Returns maximum 5000 friends/followers in one API call, need to re-call the same API using next cursors


For 1395 Users :

Friends Distribution

  Min.     1st Qu.   Median     Mean        3rd Qu.       Max. 
     0.0    110.2       378.0       1493.0       1298.0     100700.0 

Followers Distribution

  Min. 1st Qu.  Median    Mean    3rd Qu.    Max. 
      0     112     441         3678      1682       567200








ISSUES: 
To get all the friends and followers of these users, the api calling script will need to run for ~50-60 hrs continuously
Re-constructing such user network is time-expensive 
Still, not sure if these analysis or data gathering is eventually useful
	
