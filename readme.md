# 200 Years of Human History implemented in Power BI

This recreated Hans Rosling's famous visualisation of 200 Years of human history. It was popularised it in his TED talk which have attracted over 8m views.

Hans used his own bespoke software to plot a motion scatter plot showing wealth (or lack of poverty) on the x axis, lifespan on the y axis and year on the time-line.  Each circle represents a country - the size of the circle is proportional to the population at that year.  This shows that we can do the same using Power BI.

Hans's Gapminder foundation also provided the data; income, lifespan and population size by country and year. However the data is not entirely consistent, for example there are some gaps (as you might expect from the nature of the data.)

The visual is simple to implement using the standard scatter chart visual.  However it does require a row  of data (income, lifespan, population) for each country for every year since 1800 - or at least from when records start in that country, and in a single dataset.  

The magic here is in the data preparation in the Query Editor.  It loads the separate income, lifespan, and population datasets then applies a series of transformations (pivot, fill down, unpivot, merge,...) to each dataset to clean the data ready for the visual.

## Demo notes

- explain the chart, and optimistic message
- show the chart variations to focus on a particular country / period
- show the Query Editor and the Query Dependencies






