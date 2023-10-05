library(tidyverse)
library(jsonlite)
library(purrr)
library(glue)
library(gluedown)
library(lubridate)
library(zoo)
library(here)

# Read in the json data that was scraped from all 'final_demonstration' tagged data on DocumentCloud 
# These documents (around 138) come from open records requests to all 10 EPA Regions across the country for all demonstrations submitted after 1/12016
json <- read_csv(here("data", "manual", "blame_metadata_demonstrations.csv"))

df <- 
  json %>% 
  select(id, description, `Key Value Pairs`) %>% 
  mutate(key_pairs = gsub("'", '"', `Key Value Pairs`)) %>% 
  mutate(key_pairs = map(key_pairs, fromJSON)) %>% 
  select(id, key_pairs) %>% 
  unnest_wider(key_pairs) 

blamers_long <- df %>% 
  select(id, state, starts_with("origin")) %>% 
  pivot_longer(cols = -c("state", "id"), names_to = "origin", values_to = "blamed") %>% 
  mutate(blamed = str_to_lower(blamed)) %>% 
  mutate(blamed = str_replace(blamed, "_", " ")) %>% 
  filter(!is.na(blamed)) %>% 
  filter(!state == blamed) %>% 
  group_by(state, blamed) %>%
  rename(blamer = state) %>% 
  summarize(num_times = n()) 

blamed_long <- df %>% 
  select(id, state, starts_with("origin")) %>% 
  pivot_longer(cols = -c("state", "id"), names_to = "origin", values_to = "blamed") %>% 
  mutate(blamed = str_to_lower(blamed)) %>% 
  mutate(blamed = str_replace(blamed, "_", " ")) %>% 
  filter(!is.na(blamed)) %>% 
  filter(!state == blamed) %>% 
  group_by(blamed) %>%
  summarize(num = n())

# Export to csv for data vis 
write.csv(blamers_long, here("data", "processed", "for_vis", "demos_blamed.csv"))
