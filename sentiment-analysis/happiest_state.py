import sys
import json
import math
import re

def hw(sent_file, tweet_file):
    sentiments, tweets = process_files(sent_file, tweet_file)
    scored_tweets = tweet_sentiments(sentiments, tweets)
    state_scores = get_state_scores(scored_tweets).items()
    state_scores.sort(key=extract_key, reverse=True)
    print "%s" % state_scores[0][0]

def extract_key(coll):
    return coll[1]

    

def process_files(sent_file, tweet_file):
    tweets = []
    sentiments = {}
    for line in sent_file:
        term, score = line.split("\t")
        sentiments[term] = float(score)
    for line in tweet_file:
        tweets.append(line)
    return [sentiments, tweets]

def get_state_scores(scored_tweets):
    result = state_dict()
    for tweet in scored_tweets:
        values = scored_tweets[tweet]
        if values["location"] in result:
            result[values["location"]] += values["sentiment"]
    return result


def state_dict():
    state_str = """Alabama  AL
Alaska  AK
Arizona AZ
Arkansas    AR
California  CA
Colorado    CO
Connecticut CT
Delaware    DE
Florida FL
Georgia GA
Hawaii  HI
Idaho   ID
Illinois    IL
Indiana IN
Iowa    IA
Kansas  KS
Kentucky    KY
Louisiana   LA
Maine   ME
Maryland    MD
Massachusetts   MA
Michigan    MI
Minnesota   MN
Mississippi MS
Missouri    MO
Montana MT
Nebraska    NE
Nevada  NV
New Hampshire   NH
New Jersey  NJ
New Mexico  NM
New York    NY
North Carolina  NC
North Dakota    ND
Ohio    OH
Oklahoma    OK
Oregon  OR
Pennsylvania    PA
Rhode Island    RI
South Carolina  SC
South Dakota    SD
Tennessee   TN
Texas   TX
Utah    UT
Vermont VT
Virginia    VA
Washington  WA
West Virginia   WV
Wisconsin   WI
Wyoming WY
"""
    result = {}
    matches = re.findall(r"\w+\s+(\w\w)\n", state_str)
    for match in matches:
        result[match] = 0
    return result



def tweet_sentiments(sentiments, tweets):
    result = {}
    for tweet in tweets:
        text = process_tweet_text(tweet)
        location = process_tweet_location(tweet)
        if text:
            phrases = extract_words_and_phrases(text.split())
            tweet_sentiment = 0.0
            for phrase in phrases:
                tweet_sentiment += word_sentiment(sentiments, phrase)
            result[text] = {"sentiment": tweet_sentiment, "location": location}
    return result

def compute_estimated_sentiments(scored_tweets):
    result = {}
    for tweet in scored_tweets.keys():
        score = scored_tweets[tweet]
        for phrase in extract_words_and_phrases(tweet.split()):
            if phrase not in result:
                result[phrase] = {"avg": scored_tweets[tweet], "count": 1.0}
            else:
                avg = result[phrase]["avg"]
                count = result[phrase]["count"]
                result[phrase] = {"avg": (avg * count + score) / (count + 1.0), "count": count + 1.0}
    return result

def extract_words_and_phrases(wordlist):
    """
    Given a list built from a sentence in order of occurance, builds
    a list of all possible phrases that could be extracted from that sentence
    including just individual words.
    Returns the list of words and phrases
    """
    phrases_list = linear_sublists(wordlist)
    result = []
    for word_list in phrases_list:
        result.append(stringify(word_list))
    return result

def stringify(coll):
    """
    Returns all members of coll concatenated into one string.
    """
    return " ".join(coll)    

def linear_sublists(coll):
    """
    Given a collection, returns a list of the linear sublists
    """
    result = []
    l = len(coll)
    for i in range(l):
        for j in range(i, l):
            result.append(coll[i:j])
    return result

def empty(coll):
    return bool(len(coll))

def process_tweet_text(tweet):
    try:
        return json.loads(tweet)["text"]
    except KeyError:
        return None

def process_tweet_location(tweet):
    try:
        location = json.loads(tweet)["user"]["location"]
        return re.search(r"\s([A-Z][A-Z])", location).group(1)
    except:
        return None

def word_sentiment(sentiments, word):
    try:
        return float(sentiments[word])
    except KeyError:
        return 0.0

def print_result(result):
    for word in result:
        print("%s %f".encode("utf-8") % (word, result[word]))

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    hw(sent_file, tweet_file)

if __name__ == '__main__':
    main()
