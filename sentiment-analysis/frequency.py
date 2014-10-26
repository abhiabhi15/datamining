import sys
import json

def hw(tweet_file):
	
	word_counts = {}
	total_count = 0
	tweets = processTweetFile(tweet_file)
	for tweet in tweets:
		print tweet
		word_counts, total_count = countTweetWords(tweet, word_counts, total_count)

	for word,freq in word_counts.iteritems():
		print word + '  ' + computeFreq(freq, total_count) 


def computeFreq(freq, total_count):

	numbr = float(freq)/float(total_count)
	return str(round(numbr, 3))

def countTweetWords(tweet, word_counts, total_count):
	
	words = tweet.split()  # Split the word with default space
	for word in words:

		word = word.rstrip('!,.:~#%*"?;`')  # Stripping out the special extra characters
		total_count += 1
		if word.lower() in word_counts:
			word_counts[word.lower()] += 1 # Mapping the sentiment score with the word
		else:
			word_counts[word.lower()] = 1 # Mapping the sentiment score with the word

	return [word_counts, total_count]


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
	tweet_file = open(sys.argv[1])
	hw(tweet_file)


if __name__ == '__main__':
	main()
				            
