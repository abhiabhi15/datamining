import sys
import json
import math
import re

def hw(tweet_file):
    tweets = process_files(tweet_file)
    hashtags = process_tags(tweets).items()
    hashtags.sort(key=extract_key, reverse=True)
    for i in range(10):
        print "%s %f".encode("utf-8") % (hashtags[i][0], float(hashtags[i][1]))

def extract_key(coll):
    return coll[1]


def process_files(tweet_file):
    tweets = []
    for line in tweet_file:
        tweets.append(line)
    return tweets

def process_tags(tweets):
    result = {}
    for tweet in tweets:
        hashtags = process_tweet_hashtags(tweet)
        if hashtags:
            for tag in hashtags:
                text = tag["text"]
                if text in result:
                    result[text] += 1
                else:
                    result[text] = 1
    return result

def process_tweet_hashtags(tweet):
    try:
        return json.loads(tweet)["entities"]["hashtags"]
    except KeyError:
        return None

def main():
    tweet_file = open(sys.argv[1])
    hw(tweet_file)

if __name__ == '__main__':
    main()
