## Date: 2021-02-13 3:45 PM/EST

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
JHU <-read.csv("../COVID-19-OWID/public/data/jhu/full_data.csv")
dbWriteTable(db, "JHU",JHU ,overwrite=TRUE)
##
### Our World In Data
##
OWID <-read.csv("../COVID-19-OWID/public/data/owid-covid-data.csv")
dbWriteTable(db,"OWID",OWID ,overwrite=TRUE)
##
### World Heath Organization
##

dbListTables(db)
## 
## Convert date fields
JHU$date <- as.Date(JHU$date)
OWID$date <- as.Date(OWID$date)
#WHO$date <- as.Date(WHO$date)
##
##  Let's compare Daily Cases from  three Data Sources
##
JHU <- JHU %>% filter(location =="United States")
OWID <- OWID %>% filter(location =="United States")
#WHO <- WHO %>% filter(location =="United States")
ggplot(JHU) +geom_point(aes(x=date,y=new_cases),col="blue") +
geom_line(data=OWID,aes(x=date,y=new_cases),col="red") +
  labs(title="Daily Cases")

ggplot(JHU) +geom_point(aes(x=date,y=new_deaths,col="JHU")) +
  geom_line(data=OWID,aes(x=date,y=new_deaths,col="OWID")) +
  labs(title="Daily Deaths")
