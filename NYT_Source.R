
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



