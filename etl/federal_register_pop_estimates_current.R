library(tidyverse)
library(here)
library(readxl)
library(janitor)
library(stringr)



federal_register_areas <- read_csv(here("data", "manual", "federal_register_reshaped.csv"))

# All Census data is 2022 population estimates. Our goal is to show how many people "live" (as in right now) where these decisions were made it in the past 
# TidyCensus API does not support more recent data than 2020 unfortunately, so I manually downloaded these from the Census website, fixed the weird nested formatting by hand to make the data tidy and stored them in a "manual" folder accordingly 


# Places

# Colorado 
co_places <- read_csv(here("data", "manual", "census_format_fixes", "SUB-IP-EST2022-POP-08.csv")) %>% 
  filter(place %in% c("Telluride town, Colorado", "Lamar city, Colorado", "Pagosa Springs town, Colorado")) %>% 
  select(place, `2022`)

# Idaho 
id_places <- read_csv(here("data", "manual", "census_format_fixes", "SUB-IP-EST2022-POP-16.csv")) %>% 
  filter(place == "Pinehurst city, Idaho") %>% 
  select(place, `2022`)

# Oregon 
or_places <- read_csv(here("data", "manual", "census_format_fixes", "SUB-IP-EST2022-POP-41.csv")) %>% 
  filter(place == "Klamath Falls city, Oregon") %>% 
  select(place, `2022`)

# Utah

ut_places <- read_csv(here("data", "manual", "census_format_fixes", "SUB-IP-EST2022-POP-49.csv")) %>% 
  filter(place %in% c("Provo city, Utah", "Logan city, Utah")) %>% 
  select(place, `2022`)

# California 

ca_places <- read_csv(here("data", "manual", "census_format_fixes", "SUB-IP-EST2022-POP-06.csv")) %>% 
  filter(place == "Bakersfield city, California") %>% 
  select(place, `2022`)



places <- rbind(co_places, id_places, or_places, ut_places, ca_places) %>% 
  rename(name = place, pop = `2022`)


# CBSA 

cbsas <- read_csv(here("data", "raw", "census", "2022", "cbsa-est2022.csv")) %>% 
  clean_names() %>% 
  filter(name %in% c("Fairbanks, AK", "Phoenix-Mesa-Chandler, AZ", "Payson, AZ", "Sacramento-Roseville-Folsom, CA")) %>% 
  select(name, popestimate2022) %>% 
  rename(pop = popestimate2022)

# Counties 

counties_fedreg <- federal_register_areas %>% 
  filter(geography == "county") %>% 
  mutate(name = paste(name, "County")) %>% 
  select(name, state)


counties <- read_csv(here("data", "raw", "census", "2022", "co-est2022-alldata.csv")) %>% 
  clean_names() %>% 
  select(ctyname, stname, popestimate2022) %>% 
  right_join(counties_fedreg, by = c("ctyname" = "name", "stname" = "state")) %>% 
  select(-stname) %>% 
  rename(name = ctyname, pop = popestimate2022)


all  <- rbind(places, cbsas, counties) %>% 
  mutate(pop = as.numeric(str_remove(pop, ","))) %>% 
  mutate(year = "2022")

write.csv(all, here("data", "processed", "for_vis", "federal_register_areas_current.csv"))


  
  
  










  