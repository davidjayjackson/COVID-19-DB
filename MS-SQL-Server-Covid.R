## 2023-08-18

rm(list = ls())
### SQL Server Code

library(DBI)
library(odbc)
library(ggplot2)
library(scales)
library(tidyverse)
library(janitor)

##
rm(list=ls())

USA <-read_csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")
#  USA : 160052 obs and 67 vars.
USA <- USA %>% janitor::clean_names()
USA <- USA %>% janitor::remove_empty(which = c("rows","cols"))
USA$date <- as.Date(USA$date)

## https://db.rstudio.com/databases/microsoft-sql-server/
con <- DBI::dbConnect(odbc::odbc(), 
                      Driver = "SQL Server", 
                      Server = "localhost\\SQLEXPRESS", 
                      Database = "pandemic", 
                      Trusted_Connection = "True")

# dbListTables(con)


# USA <- read.csv("../COVID-19-NYTimes-data//us.csv")
# USA$date <- as.Date(USA$date)

dbWriteTable(con, "Covid",USA ,overwrite=TRUE)
dbListFields(con,"Covid")

dbGetQuery(con,"select max(date) from Covid")
# dbCommit(con)






