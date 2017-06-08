#Load Gapminder Data For PBI Motion Scatter Viz

main_folder <- "C:/Users/markw/Zomalex Ltd/OneDrive - Zomalex Ltd/Demos/Rosling/"
data_folder <-  paste0(main_folder, "Data/")
gdp_raw_path  <-  paste0(data_folder, "indicator gapminder gdp_per_capita_ppp.xlsx")
pop_raw_path  <-  paste0(data_folder, "indicator gapminder population.xlsx")
life_raw_path  <-  paste0(data_folder, "indicator life_expectancy_at_birth.xlsx")

setwd(main_folder)

library(tidyr)
library(dplyr)
library(ggplot2)
library(readxl)

gdp_raw <- read_excel(gdp_raw_path, sheet = "Data")
pop_raw <- read_excel(pop_raw_path, sheet = "Data")
life_raw <- read_excel(life_raw_path, sheet = "Data")

gdp <- 
  gdp_raw %>%  
  rename(Country = `GDP per capita`) %>% 
  gather(key = Year, value = Income, -Country) %>% 
  filter(!is.na(Income)) %>% 
  mutate(Year = as.integer(Year))

pop <- 
  pop_raw %>%  
  rename(Country = `Total population`) %>% 
  gather(key = Year, value = Population, -Country) %>% 
  filter(!is.na(Population)) %>% 
  mutate(Year = as.integer(Year))

life <- 
  life_raw %>%  
  rename(Country = `Life expectancy with projections. Yellow is IHME`) %>% 
  gather(key = Year, value = LifeExpectancy, -Country) %>% 
  filter(!is.na(LifeExpectancy)) %>% 
  mutate(Year = as.integer(Year))

# create a list of all the countries in all three datasets
# the dummy variable is used to get the effect of doing a cross join (since no cross_join verb in dplyr)
country <- 
  bind_rows(
    select(gdp, Country),
    select(pop, Country),
    select(life, Country)
  ) %>% 
  unique() %>% 
  mutate(dummy = 1)

year <- data_frame(Year = 1800:2015, dummy = 1) 

# The motion scatter plot needs a row for eavery country / year once records begin for taht country
# The cross join provides the rows
country_year_x <- 
  inner_join(country, year, by = "dummy") %>% 
  select(-dummy)

# the population data may have gaps in the years (1800, 1810,...)
# it is pivoted so that it can be filled down to remove gaps then unpivoted to original shape
pop_full <-
  country_year_x %>% 
  left_join(pop, by = c("Country", "Year")) %>% 
  spread(key = Country, value = Population) %>% 
  fill(-Year)  %>% 
  gather(key = Country, value = Population, -Year)

# ditto for life and gdp datasets
gdp_full <-
  country_year_x %>% 
  left_join(gdp, by = c("Country", "Year")) %>% 
  spread(key = Country, value = Income) %>% 
  fill(-Year)  %>% 
  gather(key = Country, value = Income, -Year)

life_full <-
  country_year_x %>% 
  left_join(life, by = c("Country", "Year")) %>% 
  spread(key = Country, value = LifeExpectancy) %>% 
  fill(-Year)  %>% 
  gather(key = Country, value = LifeExpectancy, -Year)

# merge the three '_full' datasets into the final_dataset
result <- 
  pop_full %>% 
  inner_join(life_full, by = c("Year", "Country")) %>% 
  inner_join(gdp_full, by = c("Year", "Country"))

# remove all the temporaray dataframes so only result is available
remove(gdp_raw, life_raw, pop_raw, gdp, life, pop, gdp_full, life_full, pop_full, country, year, country_year_x)


