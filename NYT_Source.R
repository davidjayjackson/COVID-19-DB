## Updated 2021-02-05 10:40 AM/EST

library(RSQLite)
library(dplyr)
## 
### Update New York Times COVID-19 Table(2020-12-07)
## NY Times US States Data Analysis
##  GitHub: https://github.com/nytimes/covid-19-data.git
db <- dbConnect(SQLite(), dbname="../COVID-19-DB/NYTimes.sqlite3")

USA <- read.csv("../COVID-19-NYTimes-data//us.csv")
us_counties <- read.csv("../COVID-19-NYTimes-data/us-counties.csv")
us_states <- read.csv("../COVID-19-NYTimes-data/us-states.csv")


USA$date <- as.character(USA$date)
dbWriteTable(db, "USA",USA ,overwrite=TRUE)

us_states$date <- as.character(us_states$date)
dbWriteTable(db, "us_counties",us_counties ,overwrite=TRUE)

us_states$date <- as.character(us_states$date)
dbWriteTable(db, "us_states",us_states ,overwrite=TRUE)
dbListTables(db)


##
us_total <- us_states %>% group_by(date) %>% 
summarise(Cases=sum(cases), Deaths = sum(deaths),                                                                   DeathRate = Deaths/Cases)

us_state_total <- us_states %>% group_by(state,date) %>% 
  summarise(Cases=sum(cases), Deaths = sum(deaths),  DeathRate = Deaths/Cases)

us_county_summary <- us_counties %>% group_by(state,county,date) %>% summarise(Cases=sum(cases),Deaths = sum(deaths),DeathRate = Deaths/Cases)


STATESDAILY <-  us_states %>% 
  group_by(date, state) %>%
  summarise(
    TotalCases = sum(cases, na.rm=TRUE),
    TotalDeaths = sum(deaths, na.rm=TRUE)
  ) %>%
  group_by(state) %>%
  arrange(desc(date)) %>%
  mutate(
    PreviousTotalCases = lead(TotalCases),
    PreviousTotalDeaths = lead(TotalDeaths)
  ) %>%
  ungroup() %>%
  na.omit()
STATESDAILY <- STATESDAILY %>% mutate(new_cases = TotalCases - PreviousTotalCases)
STATESDAILY <- STATESDAILY %>% mutate(new_deaths = TotalDeaths - PreviousTotalDeaths)
STATESDAILY <- STATESDAILY %>% mutate(death_rate = new_deaths / new_cases)
STATESDAILY$date <- as.character(STATESDAILY$date)
dbWriteTable(db, "STATESDAILY",STATESDAILY ,overwrite=TRUE)
##
COUNTYDAILY <-  us_counties %>% 
  group_by(date,state, county) %>%
  summarise(
    TotalCases = sum(cases, na.rm=TRUE),
    TotalDeaths = sum(deaths, na.rm=TRUE)
  ) %>%
  group_by(state,county) %>%
  arrange(desc(date)) %>%
  mutate(
    PreviousTotalCases = lead(TotalCases),
    PreviousTotalDeaths = lead(TotalDeaths)
  ) %>%
  ungroup() %>%
  na.omit()
COUNTYDAILY <- COUNTYDAILY%>% mutate(new_cases = TotalCases - PreviousTotalCases)
COUNTYDAILY <- COUNTYDAILY%>% mutate(new_deaths = TotalDeaths - PreviousTotalDeaths)
COUNTYDAILY <- COUNTYDAILY%>% mutate(death_rate = new_deaths/new_cases)
COUNTYDAILY$date <- as.character(COUNTYDAILY$date)
dbWriteTable(db, "COUNTYDAILY",COUNTYDAILY,overwrite=TRUE)

## Create JHU Vaccination data for USA
# 
# us_vaccine <- read.csv("../COVID-19-vaccine-data/data_tables/vaccine_data/raw_data/vaccine_data_us_state_timeline.csv")
# us_vaccine$date <- as.character(us_vaccine$date)
# dbWriteTable(db, "usvaccine",us_vaccine ,overwrite=TRUE)

