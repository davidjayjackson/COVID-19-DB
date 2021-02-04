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
##
## Read US Daily COVID-19 Data for each day
##
CSSE <-dir("../DATA/csse/",full.names=T) %>% map_df(data.table::fread)
CSSE <-CSSE %>% clean_names()
USA <- CSSE %>% filter(country_region=="US")
USA$last_update <- gsub("/","-",USA$last_update)
USA$Ymd <- substr(USA$last_update,1,10)
USA$last_update <- as.Date(USA$last_update,format="%Y-%m-%d" )
USA <- USA[order(USA$last_update,decreasing = FALSE)]

### 
### Calc Ohio
###
Ohio <- CSSE %>% filter(province_state == "Ohio")
ggplot(Ohio) + geom_line(aes(x=last_update,y=deaths))
##
## Calc Daily Grand Totals
##
USA <- aggregate(confirmed~last_update,data=CSSE,FUN=sum)
ggplot(USA) + geom_line(aes(x=last_update,y=confirmed)) +
  labs(title="US Accum Cases")

USAD <- aggregate(deaths~last_update,data=CSSE,FUN=sum)
ggplot(USAD) + geom_line(aes(x=last_update,y=deaths)) +
  labs(title="US Accum Deaths")

## Calc and Plot  Daily Cases and Deaths
##
DCases <- diff(USA$confirmed,lag=1)
df <- USA[2:147,]
DD <- as.data.table(DCases)
df$DD <-DD
df$Cases <- DD$DCasesdf$confirmed - DD$DCases
##
ggplot(df) +geom_line(aes(x=last_update,y=Cases,col="Deaths")) +
  geom_smooth(aes(x=last_update,y=Cases,col="Lm"),method="lm")
  
##
## Create SQLite table
##
CSSE$last_update <- as.character(CSSE$last_update)
db <- dbConnect(SQLite(),dbname="../COVIDDB/COVID.sqlite3")
dbWriteTable(db,"CSSE",CSSE,row.names=FALSE,overwrite=TRUE)
  ##
