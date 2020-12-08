# COVIDDB
### Raw data for SQLite database.

#### John Hopkins Uni CSSE
* https://github.com/CSSEGISandData/COVID-19

#### New York Times COVID-19 Data
* https://github.com/nytimes/covid-19-data

#### European CDPC COVID-19:

* https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide

#### SQLite Daily Script (Uses John Hopkins data)
SELECT date, confirmed,deaths, confirmed - LAG ( confirmed, 1, 0 ) OVER ( ORDER BY date ) DailyCases,
deaths - LAG ( deaths, 1, 0 ) OVER ( ORDER BY date ) DailyDeaths
FROM JHUDATA where country = "Sweden"

#### Weekly Cases and Deaths
select enddate,
       sum(...),
       ...
  from (
        select date(cast(julianday(datecolumn)-1721061.5 as integer)/7*7+1721067.5) as enddate,
               *
          from theTable
       )
group by enddate
order by enddate;

#### Using curl and wget to pull down directories.

sudo curl -bla /ihave/idea ./
wget --no-parent -r http://mysite.ie/mydirectory

#### Covid-19 data from Our World In Data repo:

https://github.com/owid/covid-19-data
