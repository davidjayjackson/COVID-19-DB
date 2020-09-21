library(readxl)
library(httr)

```
```{r, echo=FALSE}
rm(list=ls())
#these libraries are necessary
#create the URL where the dataset is stored with automatic updates every day

url <- paste("https://www.ECDC.europa.eu/sites/default/files/documents/COVID-19-geographic-disbtribution-worldwide-",format(Sys.time(), "%Y-%m-%d"), ".xlsx", sep = "")

#download the dataset from the website to a local temporary file
GET(url, authenticate(":", ":", type="ntlm"), write_disk(tf <- tempfile(fileext = ".xlsx")))
#read the Dataset sheet into “R”
ECDC <- read_excel(tf)