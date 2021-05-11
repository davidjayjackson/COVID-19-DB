## Date: 2021-05-11 1:15 PM/EDT

library(RSQLite)
library(ggplot2)
library(scales)
library(dplyr)
 
##
rm(list=ls())
db1 <- dbConnect(SQLite(), dbname="../COVID-19-DB/NYTimes.sqlite3")
db <- dbConnect(SQLite(), dbname="../COVID-19-DB/OURWORLD.sqlite3")
##
### John Hopkins University
##
# JHU <-read.csv("../COVID-19-OWID/public/data/jhu/full_data.csv")
# dbWriteTable(db, "JHU",JHU ,overwrite=TRUE)
##
### Our World In Data
##
OWID <-read.csv("../covid-19-data/public/data/owid-covid-data.csv")
dbWriteTable(db,"OWID",OWID ,overwrite=TRUE)
##
### World Heath Organization
##

dbListTables(db)
## 
## Convert date fields
#JHU$date <- as.Date(JHU$date)
OWID$date <- as.Date(OWID$date)
#WHO$date <- as.Date(WHO$date)
##
##  Let's compare Daily Cases from  three Data Sources
##
# JHU <- JHU %>% filter(location =="United States")
OWID <- OWID %>% filter(location =="United States")
#WHO <- WHO %>% filter(location =="United States")
ggplot(OWID) +geom_point(aes(x=date,y=new_cases),col="blue") +
geom_smooth(aes(x=date,y=new_cases),col="red",span=0.25) +
  labs(title="Daily Cases")

ggplot(OWID) +geom_point(aes(x=date,y=new_deaths,col="Daily")) +
  geom_smooth(aes(x=date,y=new_deaths,col="Loess"),span=0.25) +
  labs(title="Daily Deaths") + ylim(0,5000)
