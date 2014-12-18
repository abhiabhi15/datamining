## Named-Entity Recognition
---
#####Software : `Stanford Named Entity Recognizer (NER)`
#####Package Version:`3.4.1`
#####Java version : `1.7`
#####OS : `Ubuntu 12.04 (Linux 3.2.0-58-generic)`
##### Author : `Abhishek (Unity Id : akagrawa)`
 ---

####Description
Named-Entity Recognition(also known as entity identification, entity chunking and entity extraction) is a subtask of information extraction that seeks to locate and classify elements in text into pre-defined categories such as the names of persons, organizations, locations, expressions of times, quantities, monetary values, percentages, etc[2]. Here the models are built using Conditional Random Field(CRF) Classifiers under the software package[1]. Below are the descriptions in order to run the model and generate results.

####System Requirements
* **Software Package** : The models used in this project are build using Stanford Named-Entity Recognizer implementation, available at: http://nlp.stanford.edu/software/CRF-NER.shtml.
Please download version 3.4.1 of the software for the results models to run.  

* **JAVA** : Make sure you have JAVA-7 installed at your system. The model used are not compatible with JAVA-8 in this version. If not installed, then visit the following link to install and set JAVA in your system.
https://www.java.com/en/download/help/download_options.xml

#### Parameters for the model tuning
Please find the .prop files for the parameters used for building CRF Classifiers.
Following are the properties which are varied to generate various models.
```
#location of the training file
trainFile = wikipedia.train

#location where you would like to save (serialize) your classifier;
serializeTo = ner-wiki-model.ser.gz

#structure of your training file; this tells the classifier that the word is in column 0 and the correct answer is in column 1
map = word=0,answer=1

#This specifies the order of the CRF:order 1 means that features apply at   most to a class pair of previous # class and current class  or current class and next class.
maxLeft=1    [Here I made the variations for maxLeft = 1,2,3]

#Training features
useClassFeature=true
useWord=true
useNGrams=true   [Variations for useNGrams= true, false]
noMidNGrams=true
maxNGramLeng=6   [Variations for maxNGramLeng = 6,4]
usePrev=true
useNext=true
useDisjunctive=true
useSequences=true
usePrevSequences=true

#The last 4 properties deal with word shape features
useTypeSeqs=true
useTypeSeqs2=true
useTypeySequences=true
wordShape=chris2useLC
```
### Running the model
Follow the instructions below to run the model:
* **Location of files**<br/>
The data files, models and property files must be on same folder location, before executing the command below.


* **Model Training and Intrepetation**<br/>
Once you have a properties file, you can train a classifier with the command:
```    
java -cp stanford-ner.jar edu.stanford.nlp.ie.crf.CRFClassifier -prop ner-wiki.prop
```
In the above command **stanford-ner.jar** is the main Jar file for CRF classifier, followed by the main **CRFClassifier** Class which takes properties whils as input.<br/>
An NER model will then be serialized to the location specified in the properties file **(ner-wiki-model.ser.gz)** once the program has completed.

* **Model Testing**</br/>
 To check how well it works, you can run the test command:
```    
java -cp stanford-ner.jar edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier ner-wiki-model.ser.gz -testFile wikipedia.test >>output.txt
```
Here we specify the model geneated in the previous model training part in order to test it for our testFile.

###Sample Input Files
* **Training and Test File** <br/>
Sample lines from `wikipedia.train` file. Here words and the labels are tab separated. The labels are [Misc (Miscellaneous), PERS (Person), LOC (Location), ORG (Organization) and O (Other)]. This file is then fed into model generator to build a classifier model wrt to the given dataset. The test file also contain the words in the same format along with the ground truth tagging. **Emma(Dataset2)**, for which manual labeling was required, can be found inside folder data. <br/>
```
Japanese    MISC
Punk    O
band    O
The   ORG
Mad   ORG
Capsule    ORG
Markets    ORG
Founding    O
member   O
Kojima   PERS
Minoru   PERS
played   O
skirmish    O
at   O
Williamsport   LOC
```
**[Note]** For files `emma.train` and `emma.test` the labels are created manually and can be found inside folder data. Various variations of this dataset is also kept inside the same folder with a naming convention. For dataset with {PERSON, ORG} labels, the filename is emma.PO.train/emma.PO.test etc.

### Results and interpretation
In the output, the first column is the input tokens, the second column is the correct answers(ground truth), and the third column is the answer guessed by the classifier. By looking at the output, you can see that the classifier finds most of the person named entities but not all, mainly due to the very small size of the training data (but also this is a fairly basic feature set). The code then evaluates the performance of the classifier for entity level precision, recall, and F1. Below is the sample output results for emma.test file.
```
but	O	O
Mr	PERS	PERS
Woodhouse	PERS	PERS
would	O	O
Randalls	LOC	PERS
from	O	O
Hartfield	LOC	LOC

CRFClassifier tagged 1780 words in 1 documents at 2843.45 words per second.
         Entity	 P	     R	     F1	   TP   FP	FN
            LOC	0.8182	0.6000	0.6923	9	 2	 6
           PERS	0.6889	0.6200	0.6526	31	14	19
         Totals	0.7143	0.5882	0.6452	40	16	28
```
### Other Performance Measures
For other performance measures which are not output by default[1], we will use R packages. But before that the pre-processing of the output file is needed. That can be done, using following script commands:
* **Shell Script** for 2nd and 3rd column removal from output file
```
    grep -v '^$' output.txt >> temp.txt # Removes empty lines in any
    awk '{print $2, $3}' temp.txt >> result.txt # Get 2nd and 3rd column
    rm output.txt temp.txt
```
* Performance measure using confusion matrix in **R** script
```
library(caret) # load this package
rm(list=ls())
raw_data <- read.table("result.txt", header=F, sep=" ", quote=c("\"",","))
raw_data[which(raw_data$V1 == "B-ORG"),]$V1 <- "O"
raw_data[which(raw_data$V1 == "B-LOC"),]$V1 <- "O"
raw_data[which(raw_data$V1 == "B-MISC"),]$V1 <- "O"
raw_data[which(raw_data$V1 == "B-PER"),]$V1 <- "O"
raw_data$V1 <- factor(raw_data$V1)
levels(raw_data$V1) # Convert extra labels to default label "O"
ss <- confusionMatrix(raw_data$V2, raw_data$V1)
print(ss)  # Outputs performance measures
```

### References
1. Jenny Rose Finkel, Trond Grenager, and Christopher Manning. 2005. Incorporating Non-local Information into Information Extraction Systems by Gibbs Sampling. Proceedings of the 43nd Annual Meeting of the Association for Computational Linguistics (ACL 2005), pp. 363-370. http://nlp.stanford.edu/~manning/papers/gibbscrf3.pdf
2. http://en.wikipedia.org/wiki/Named-entity_recognition
