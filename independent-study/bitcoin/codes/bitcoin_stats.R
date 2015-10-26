rm(list=ls())

library(ggplot2)
library(scales)
options(scipen = 1)

data <- read.csv("../data/bitcoin/time-series.csv", colClasses=c("Date","numeric","numeric"))

ggplot(data, aes(date, freq)) + geom_line(aes(colour = freq)) +
  scale_x_date(labels=date_format("%b-%y"), breaks = "4 month") +  xlab("Date") + ylab("Daily Transactions")

ggplot(data, aes(date, btc)) + geom_line(aes(colour = btc)) +
  scale_x_date(labels=date_format("%b-%y"), breaks = "4 month") +  xlab("Date") + ylab("Daily Transactions Amount(Bitcoin)")

ggplot() + 
  geom_line(data = data, aes(x = date, y = log(freq), color = "Frequency(Log)"))  +
  geom_line(data = data, aes(x = date, y = log(btc), color = "BTC(Log)")) +
  geom_line(data = data, aes(x = date, y = log(usd), color = "USD(Log)")) +
  scale_x_date(labels=date_format("%b-%y"), breaks = "2 month") +
  ggtitle("Time Series : BTC, USD Vs Frequency") +
  xlab('Date') +
  ylab('Values in Log Scale') +
  theme(legend.title=element_blank())
  
price <- read.csv("../data/bitcoin/bitcoin-usd-price.csv")
names(price) <- c("date","usd_rate")
price$date <- as.Date(price$date)
data$date <- as.Date(data$date)

data <- merge(data, price, by=c("date"))
data$usd <- data$btc * data$usd_rate

write.csv(data, file="../data/bitcoin/bitcoin_ts.csv", row.names=F)
