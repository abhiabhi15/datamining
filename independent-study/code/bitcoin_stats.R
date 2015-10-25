rm(list=ls())

library(ggplot2)
library(scales)
options(scipen = 1)

data <- read.csv("../data/bitcoin/time_series.csv", colClasses=c("Date","numeric"))

ggplot(data, aes(Date, value)) + geom_line(aes(colour = value)) +
  scale_x_date(labels=date_format("%b-%y"), breaks = "4 month") +  xlab("Date") + ylab("Daily Transactions")
