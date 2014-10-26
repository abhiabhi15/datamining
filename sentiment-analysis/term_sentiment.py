import sys
import json

def hw(score_file, tweet_file):
	
	no_scorers = {}
	tweet_count = {}
	scores, multi_words = processScoreFile(score_file)
	tweets = processTweetFile(tweet_file)
	
	for tweet in tweets:
		score, new_words = getTweetScore(tweet, scores, multi_words) #get the score per tweet
		for new_word, new_score in new_words.iteritems():
			if new_word in no_scorers:
				no_scorers[new_word] += new_score
				tweet_count[new_word] += 1
			else:
				no_scorers[new_word] = new_score
				tweet_count[new_word] = 1

	for k, v in no_scorers.iteritems():
		print  k + ' ' + normalizeScore(v, tweet_count[k]) 

	print 'non scorers count :: ' + str(len(no_scorers)) 

def normalizeScore(value, tcount):
	numbr = float(value)/float(tcount)
	return str(round(numbr,3))

def getTweetScore(tweet, scores, multi_words):

	no_scorers = {}
	score, tweet  = checkMultiWordsTweet(tweet, scores, multi_words)
	words = tweet.split()  # Split the word with default space
	for word in words:
		tmp_score = 0
		word = word.rstrip('!,.:~#%*"?;`')  # Stripping out the special extra characters 
		# I could have used regular expression here, but will learn to use that in next exercises
		if ("http" or "@" ) in word:  # Removing hyper link words
			continue
		if word.isdigit():
			continue
		if "@" in word:
			continue
		tmp_score = matchWordScore(word, scores)
		if tmp_score == 0:
			no_scorers[word.lower()] = 0
		else:
			score += matchWordScore(word, scores)
	
	for	word in no_scorers.iterkeys():
		no_scorers[word] = score
	
	return [score, no_scorers]	

def matchWordScore(word, scores):
	try:
		return int(scores[word.lower()])  # Mapping the sentiment score with the word
	except KeyError:
		return 0    # Returning 0 if the word is not found

def checkMultiWordsTweet(tweet, scores, multi_words):
	rand = "@@@@@@"
	score = 0
	for multi_word in multi_words:
		if multi_word in tweet.lower():
			tweet = tweet.replace(multi_word, rand)
			score += int(multi_words[multi_word])
	
	return [score, tweet]


def processScoreFile(score_file):
	scores = {} #initialize an empty dictionary
	multi_words = {}
	for line in score_file:
		if " " in line:     # For multi word cases as cool stuff, fed up etc.
			multi_word, scr = line.split("\t")
			multi_words[multi_word] = int(scr)
		term, score = line.split("\t")
		scores[term] = int(score) # convert the score to an integer
    
	return [scores, multi_words]	


def processTweetFile(tweet_file):
	tweet_arr = []
	for line in tweet_file: 
		tweet_arr.append(line)
	
	tweets = []
	for raw_json in tweet_arr:
		status_json = json.loads(raw_json)["statuses"]      #Loading the content, parsing the json to filter the tweet jsons only
		for tweet_json in status_json:
			tweets.append(tweet_json["text"].encode('utf-8')) # Encoding special characters
	return tweets;


def main():
    score_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    hw(score_file, tweet_file)


if __name__ == '__main__':
    main()
