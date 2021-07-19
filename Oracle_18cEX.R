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