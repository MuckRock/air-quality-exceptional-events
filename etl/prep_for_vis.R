library(tidyverse)
library(here)
library(janitor)
library(readxl)
library(lubridate)
library(hms)
library(tidycensus)
library(plotly)
library(stringr)



# Load crosswalk for FIPS codes to connect monitor IDs (which have FIPS in them) to the county and state they're located in 
fips <- as.data.frame(fips_codes) %>% 
  mutate(state_county_fips = paste0(state_code, county_code)) %>%  
  select(state_name, county, state_county_fips) %>% 
  rename(state = state_name)

# Load EPA data on all readings connected to exceptional events that the EPA has concurred on
concurrences_and_non <- read_csv(here("data", "raw", "muckrock_request_exclusion_ee.csv")) %>% 
  clean_names() %>% 
  mutate(date = as_date(sample_date_time)) %>% 
  mutate(state_county_fips = str_remove(str_sub(airs_monitor_id, 1, 6), pattern= "-"))


# Count the number of concurred days by county, the metric we call "county-days"
concurrenced_county_days_by_county <- concurrences_and_non %>%
  filter(concurrence_ind == "Y") %>% 
  distinct(state_county_fips, date) %>% 
  group_by(state_county_fips) %>% 
  summarize(days = n()) %>% 
  left_join(fips, by = "state_county_fips") 

concurrenced_county_days_by_state <-  concurrenced_county_days_by_county %>% 
  group_by(state) %>% 
  summarize(days = sum(days))

# Write clean CSVs to folder for visualizations 
write.csv(concurrenced_county_days_by_county, "data/processed/for_vis/concurrenced_county_days_by_county.csv")
write.csv(concurrenced_county_days_by_state, "data/processed/for_vis/concurrenced_county_days_by_state.csv")


# Now count events by county and state 
events_by_county <- concurrences_and_non %>%
  group_by(state_county_fips) %>% 
  summarize(events = n_distinct(exceptional_event_id)) %>% 
  left_join(fips, by = "state_county_fips")

events_by_state <- concurrences_and_non %>%
  left_join(fips, by = "state_county_fips") %>% 
  group_by(state) %>% 
  summarize(events = n_distinct(exceptional_event_id))
  

# Write clean CSVs to folder for visualizations 
write.csv(events_by_county, "data/processed/for_vis/events_by_county.csv")
write.csv(events_by_state, "data/processed/for_vis/events_by_state.csv")


# Concurred days for Fort McMurray fire in May 2016

mcmurray_concurrences <- concurrences_and_non %>% 
  filter(concurrence_ind == "Y") %>% 
  filter(event_type_code == "RF") %>% 
  filter(date >= "2016-05-01" & date <= "2016-06-01") %>% 
  left_join(fips, by = "state_county_fips")

wayne_and_nevada_concurrences <- concurrences_and_non %>%
  left_join(fips, by = "state_county_fips") %>% 
  filter(county %in% c("Wayne County", "Nevada County")) 


write.csv(mcmurray_concurrences, "data/processed/for_vis/mcmurray_concurrences.csv")

# Dataframe to help look up concentration plots and join later to mark concurred days 
for_concetration_plot <- rbind(mcmurray_concurrences, wayne_and_nevada_concurrences) %>% 
  distinct(airs_monitor_id, state, county, date) %>% 
  mutate(site_id = substr(gsub("-", "", airs_monitor_id), start = 1, stop = 9)) %>% 
  mutate(concurred = "Y")
  

# Impacts Connecticut, Maryland, Massachusetts, New Jersey, Pennsylvania and Rhode Island ozone
# Impacts Ohio for both Ozone and PM2.5 
  

# Exceptional events by days and type for High Winds and Wildfires

all_events <- read_excel(here("data", "raw", "exceptional_events_1_1_2016_copy_for_MuckRock.xls")) %>% 
  clean_names() %>% 
  mutate(event_begin_date = dmy(event_begin_date)) %>% 
  mutate(event_end_date = dmy(event_end_date)) %>% 
  mutate(event_length = 1 + (event_end_date - event_begin_date))

high_winds <- all_events %>% 
  filter(qualifier_code == "RJ") 


wildfires_vs_high_winds <- all_events %>% 
  # Anything a year or more will skew the data and is likely just questionable/imprecise data entry
  filter(event_length < 365) %>% 
  filter(qualifier_code %in% c("RT", "RJ", "RF")) %>% 
  # RJ is for High Winds events, RT is US wildfire and RF is Canadian wildfire
  mutate(event_type = case_when(qualifier_code == "RJ" ~ "High Winds", TRUE ~ "Wildfire")) %>% 
  mutate(year = year(event_begin_date)) %>% 
  group_by(year, event_type) %>% 
  summarize(days = sum(event_length))


write.csv(wildfires_vs_high_winds, "data/processed/for_vis/wildfires_vs_high_winds.csv")


# Connecticut, Maryland, Massachusetts, New Jersey, Pennsylvania, Ohio and Rhode Island data for Ozone exceedences during McMurray fires
file_names <- list.files("data/raw/concentration_plot/")
index <- 1
df <- data.frame(matrix(nrow = 0, ncol = length(cols)))
for (file in file_names){
  current_file <- file_names[index]
  data <- read_csv(paste0("data/raw/concentration_plot/", current_file))
  df <- rbind(df, data)
  index <- index + 1 
  
}

concentration_plot_df <-  df %>% 
  clean_names %>% 
  select(date, site_id, daily_max_8_hour_ozone_concentration, state, county, site_longitude, site_latitude) %>% 
  mutate(date = mdy(date)) %>% 
  left_join(select(for_concetration_plot, c("site_id", "date", "concurred")), by = c("site_id", "date")) %>% 
  mutate(concurred = case_when(is.na(concurred) ~ "N", TRUE ~ concurred))


write.csv(concentration_plot_df, "data/processed/for_vis/concentration_plot_df.csv")

# Latitude and longitude for monitors with concurrences 
all_monitors <- read_csv(here("data", "raw", "aqs_monitors.csv")) %>% 
  clean_names() %>% 
  mutate(airs_monitor_id = paste(state_code, county_code, site_number, parameter_code, sep = "-")) %>% 
  distinct(airs_monitor_id, latitude, longitude, local_site_name, state_name, county_name) 


concurred_monitors <- concurrences_and_non %>%
  filter(concurrence_ind == "Y") %>%
  distinct(airs_monitor_id) %>% 
  mutate(airs_monitor_id = str_sub(airs_monitor_id, end = 17)) %>% 
  left_join(all_monitors, by = "airs_monitor_id")


write.csv(concurred_monitors, "data/processed/for_vis/concurred_monitors_with_lat_longs.csv")


# Data for Wayne County and Nevada County concurrences 

wayne_and_nevada <- concurrences_and_non %>%
  left_join(fips, by = "state_county_fips") %>% 
  filter(county %in% c("Wayne County", "Nevada County")) %>% 
  distinct(county, pollutant_name, airs_monitor_id, date)

# Data for Chris Amico lookup

df <- read_excel(here("data", "raw", "muckrock_req_excl_ee_v2.xlsx")) %>% 
  clean_names() %>% 
  mutate(date = as_date(sample_date_time)) %>% 
  mutate(state_county_fips = str_remove(str_sub(airs_monitor_id, 1, 6), pattern= "-"))

df_fips_lat_longs <- df %>% 
  left_join(fips, by = "state_county_fips") %>% 
  left_join(all_monitors, by = "airs_monitor_id")

#write_csv(df_fips_lat_longs, "for_chris_lookup.csv")

