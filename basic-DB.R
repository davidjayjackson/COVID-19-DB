rm(list = ls())
### Load Library
# library(RORacle) Oracle
# library(MariaDB) MYSql


## Connect to DB SQLite
library(RSQLite)

db <- dbConnect(SQLite(), dbname="../COVID-19-DB/OURWORLD.sqlite3")

## If you are using a DB that needs a username and  password 
#  The connect statement  would lookesomething like this:

dbConnect(db, username = "", password = "", dbname = "")

## Read In CSV file.

USA <- read.csv("../COVID-19-NYTimes-data//us.csv")
USA$date <- as.character(USA$date) # SQLite doesn't have a Date Type.

## Create Table and load data.(Overwrites existing table)

dbWriteTable(db, "USA",USA ,overwrite=TRUE)

## Check if  table wS created

dbListTables(db)

## Run query and create data frame.

df <- dbGetQuery(db,"select * from OWID")

## Bonus Create Key field in DB

dbSendQuery(db, "CREATE INDEX IDate ON OWID(location)")


### SQL Server Code
## https://db.rstudio.com/databases/microsoft-sql-server/
library(DBI)
library(odbc)

con <- DBI::dbConnect(odbc::odbc(), 
                      Driver = "SQL Server", 
                      Server = "localhost\\SQLEXPRESS", 
                      Database = "onefish", 
                      Trusted_Connection = "True")

dbListTables(con)
