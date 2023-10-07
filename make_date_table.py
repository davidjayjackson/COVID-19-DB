import pandas as pd
from datetime import date, timedelta

# Create a range of dates from January 1st, 2010 to September 25th, 2020
start_date = date(2010, 1, 19)
end_date = date(2020, 9, 25)
date_range = pd.date_range(start=start_date, end=end_date, freq='D')

# Convert the date_range to a DataFrame and set the column name
date_table = pd.DataFrame(date_range, columns=['Date'])

# Print the last few rows of date_table
print(date_table.tail())

# Write data to a CSV file
date_table.to_csv('./NIKE-Calendar.csv', index=False)
