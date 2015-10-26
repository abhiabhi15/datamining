
# Mooc Data Processing
rm(list=ls())
columnNames = c("key","year","month","day","hour","minute","user_ip","username","session","page_url","latitude","longitude","city","country")
moocData <-  read.csv("data/moocData.csv", header = F, row.names=NULL, skip=1) # Loading data
names(moocData) <- columnNames
head(moocData,1)

## EDA on Mooc Data
library(ggplot2)
#summary(moocData) # Summary statistics of the data
countryWise <- as.data.frame(table(moocData$country))
names(countryWise) <- c("Country", "Count")
countryWise <- countryWise[countryWise$Count > 10000,]
countryWise[is.na(countryWise)] <- "Other"
countryWise[which(is.na(countryWise$Country)),]$Country <- "Other"

ggplot(countryWise, aes(x = Country, y = Count, fill= Country)) + ylab("Number of Events") + xlab("Country Wise") + ggtitle("Country Wise Event Distribution") + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = "none")

library(rworldmap)
data("countryExData",envir=environment(),package="rworldmap")
sPDF <- joinCountryData2Map(countryWise
                            , joinCode = "NAME"
                            , nameJoinColumn = "Country"
                            , nameCountryColumn = "Country"
)

mapCountryData( sPDF, nameColumnToPlot="Count", mapTitle="MOOC Data Event World Distribution", colourPalette="topo", catMethod="logFixedWidth")

mapCountryData( sPDF, nameColumnToPlot="Count", mapTitle="MOOC Data Event World Distribution", colourPalette="heat", catMethod="logFixedWidth")


#### From Aggregated Data 
usrCountry <- read.csv("data/country_users_count.csv")
usrCountry <- na.omit(usrCountry)

sPDF1 <- joinCountryData2Map(usrCountry
                            , joinCode = "NAME"
                            , nameJoinColumn = "country"
                            , nameCountryColumn = "Country"
)

mapCountryData( sPDF1, nameColumnToPlot="count", mapTitle="MOOC Data Distinct Users World Distribution", colourPalette="heat", catMethod="logFixedWidth")


