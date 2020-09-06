library(tidyverse)
library(RSQLite)
library(data.table)
library(janitor)
library(lubridate)
##
## John Hopkins CSSE COVID-19 for the World
##
rm(list=ls())
db <- dbConnect(SQLite(), dbname="../COVIDDB/COVID.sqlite3")
CSSE <-dir("../DATA/csse/",full.names=T) %>% map_df(data.table::fread)
CSSE <-CSSE %>% clean_names()
CSSE$last_update <- gsub("/","-",CSSE$last_update)
CSSE$last_update <- substr(CSSE$last_update,1,10)
CSSE$last_update <- as.Date(CSSE$last_update,format="%Y-%m-%d" )

CSSE$last_update <- as.character(CSSE$last_update)

db <- dbConnect(SQLite(),dbname="../COVIDDB/COVID.sqlite3")
dbWriteTable(db,"CSSE",CSSE,row.names=FALSE,overwrite=TRUE)
##
## Calc and Plot  Daily Cases and Deaths
##
USA <- aggregate(confirmed~last_update,data=CSSE,FUN=sum)
ggplot(USA) + geom_line(aes(x=last_update,y=confimed))
