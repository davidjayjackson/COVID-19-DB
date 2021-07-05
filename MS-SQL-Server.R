rm(list = ls())
### SQL Server Code

library(DBI)
library(odbc)

## https://db.rstudio.com/databases/microsoft-sql-server/
con <- DBI::dbConnect(odbc::odbc(), 
                      Driver = "SQL Server", 
                      Server = "localhost\\SQLEXPRESS", 
                      Database = "onefish", 
                      Trusted_Connection = "True")

dbListTables(con)


USA <- read.csv("../COVID-19-NYTimes-data//us.csv")
USA$date <- as.Date(USA$date)

dbWriteTable(con, "redfish",USA ,overwrite=TRUE)
dbListFields(con,"redfish")

df <- dbGetQuery(con,"select * from redfish")
dbCommit(con)

df <- dbGetQuery(con,"select * from ABC")

dbDisconnect(con)




dbDisconnect(con)
