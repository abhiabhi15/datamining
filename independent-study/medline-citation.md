Medline Dataset Analysis
==============

PubMed comprises over 25 million citations for biomedical literature from MEDLINE, life science journals, and online books. PubMed citations and abstracts include the fields of biomedicine and health, covering portions of the life sciences, behavioral sciences, chemical sciences, and bioengineering. PubMed also provides access to additional relevant web sites and links to the other NCBI molecular biology resources. Its citation index, which tracks the publication of articles across thousands of journals, can trace its history back to 1879, and it has been available online to medical schools since 1971 and to the general public via the World Wide Web since 1996.  

**MESH Headings**: Due to the volume of citations and the frequency of updates, the research community
developed an extensive set of semantic tags called MeSH (Medical Subject Headings) that are applied to all of the citations in the index. These tags provide a meaningful framework that can be used to explore relationships between documents in order to facilitate literature reviews.  

**Getting the data**: We can retrieve a sample of the citation index data from the NIH’s FTP server:  
```
$ mkdir medline_data
$ cd medline_data
$ wget ftp://ftp.nlm.nih.gov/nlmdata/sample/medline/*.gz
```
**Data Field Description**: The data fields description and details can be found at https://www.nlm.nih.gov/bsd/mms/medlineelements.html#crdt  

**Full Data Access**: https://www.nlm.nih.gov/databases/journal.html
