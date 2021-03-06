library(RSQLite)
library(tidyverse)
## Update European CDPC Data table
## Data: https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide
##
rm(list=ls())
db <- dbConnect(SQLite(), dbname="../COVIDDB/COVID.sqlite3")

ECDC <- read.csv("../DATA/COVID-19.csv")
ECDC$dateRep <- gsub("/","-",ECDC$dateRep)
ECDC$dateRep <- as.Date(ECDC$dateRep,format="%m-%d-%Y")
colnames(ECDC) <- c("Reported","Cases","Deaths","Countries","geoID","Continent","Population")
  
ECDC$Countries <-ifelse(ECDC$Countries=="United_States_of_America","USA",ECDC$Countries)
ECDC$Countries <-ifelse(ECDC$Countries=="Cases_on_an_international_conveyance_Japan","Japan",ECDC$Countries)
ECDC$Reported <- as.character(ECDC$Reported)
dbWriteTable(db, "ECDC",ECDC ,overwrite=TRUE)
##
## 
### Update New York Times COVID-19 Table
## NY Times US States Data Analysis
##  GitHub: https://github.com/nytimes/covid-19-data.git

USA <- read.csv("../DATA/us.csv")
us_counties <- read.csv("../DATA/us-counties.csv")
us_states <- read.csv("../DATA/us-states.csv")
source("./NYT_Source.R")

USA$date <- as.character(USA$date)
dbWriteTable(db, "USA",USA ,overwrite=TRUE)

us_states$date <- as.character(us_states$date)
dbWriteTable(db, "us_counties",us_counties ,overwrite=TRUE)

us_counties$date <- as.character(us_counties$date)
dbWriteTable(db, "us_counties",us_counties ,overwrite=TRUE)
dbListTables(db)
