## Date: 2022-12-09
library(ggplot2)
library(scales)
library(tidyverse)
library(RSQLite)
 
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

OWID <-read_csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")
OWID$date <- as.character(OWID$date)
dbWriteTable(db,"OWID",OWID ,overwrite=TRUE)
OWID$date <- as.Date(OWID$date)


##
### World Heath Organization
##

dbListTables(db)

###
### Begin SQL Server Code
## 

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
OWID$MAC <- forecast::ma(OWID$new_cases,7,centre = TRUE)
OWID$MAD <- forecast::ma(OWID$new_deaths,7,centre = TRUE)
#WHO <- WHO %>% filter(location =="United States")
ggplot(OWID) +geom_point(aes(x=date,y=new_cases,col="Daily" ),col="blue") +
geom_line(aes(x=date,y=MAC,col="14 Day Mov Avg"),linewidth=2) +
  labs(title="Daily Cases")

ggplot(OWID) +geom_point(aes(x=date,y=new_deaths,col="Daily")) +
  geom_line(aes(x=date,y=MAD,col="14 Day Mov. Avg."),linewidth=2) +
  labs(title="Daily Deaths") + ylim(0,5000)


ggplot(OWID) +geom_point(aes(x=date,y=new_cases,col="Daily" ),col="blue") +
  geom_smooth(aes(x=date,y=new_cases,col="GAM"),method="gam") +
  labs(title="Daily Cases")

ggplot(OWID) +geom_point(aes(x=date,y=new_deaths,col="Daily")) +
  geom_smooth(aes(x=date,y=new_deaths,col="GAM"),method="gam") +
  labs(title="Daily Deaths") + ylim(0,5000) 
  
# Try to make errorsbars

# ggplot(OWID,aes(x=date)) +geom_errorbar(aes(ymin=min(new_cases,ymax=max(new_cases))))
