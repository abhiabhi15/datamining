DBLP Dataset
======

####DBLP Data Collection for Dynamic Attributed Network :

DBLP dataset contains the records of the articles, books, publications, thesis etc. published in the scientific communities. Here the records contains the year, title, authors and journal of the publications.  

For the graph Data,  

**Graph Node:** Author , the attributes can be (name, gender, areas of publication)  
**Graph Edge:** A link of  publication /article co-authored by more than one authors  

For DBLP Data collected on 08/31/2015  : http://dblp.uni-trier.de/xml/  

####Summary Statistics:
**Total Papers:** 4681743    ( ~4.68 Million)  
**Total Authors:** Across All years 23278284681743  ( ~2.32 Million)  
**Total Edges (Paper-Author Links):** 10235695    ( ~10.23 Million)    

For the attributed network : We can add more attributes such as gender, area of publications using other APIs and mining techniques.  

We have the year of publication, that can be used to get dynamic network of such attributed networks.  

###Data Processing and Filtering :
 
**dblp.xml to dblp.json:** Parsed the data from xml to json format having attributes such as paper title, year of publication, publication journal, authors etc.  

Filtered Data only for type = “Article”  

Total number of papers = 1330099 (~1.33 Million)  

Currently, aggregating papers by authors and years.  

<p align="center">
<img src="https://github.com/abhiabhi15/datamining/blob/master/independent-study/plots/dblp/authors.png" />
</p>

Then we can add some more attributes to the author nodes.








