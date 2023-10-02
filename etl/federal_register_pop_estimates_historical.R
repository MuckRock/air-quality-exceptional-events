library(tidyverse)
library(here)
library(readxl)



federal_register_areas <- read_csv(here("data", "processed", "federal_register_reshaped.csv"))


# California 2008
california_counties_2008 <- read_excel(here("data", "processed", "census", "2000_2010", "ca_co-est00int-01-06.xls"), sheet = 2) %>% 
  select(county, `2008`) %>%
  mutate(county = str_sub(county, 2)) %>% 
  filter(county %in% c("Stanislaus County", "Merced County", "Madera County", "Fresno County", "Tulare County", "Kings County", "San Joaquin County")) %>% 
  pivot_longer(cols = `2008`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "California") %>% 
  rename(area = county)

bakersfield_2008 <-  read_csv(here("data", "processed", "census", "2000_2010", "city_and_town_sub-est00int.csv")) %>% 
  select(NAME, STNAME, POPESTIMATE2008) %>% 
  filter(NAME == "Bakersfield city") %>% 
  filter(STNAME == "California") %>% 
  slice(1) %>% 
  pivot_longer(cols = "POPESTIMATE2008", names_to = "drop", values_to = "pop") %>% 
  mutate(year = "2008") %>% 
  rename(area = NAME, state = STNAME) %>% 
  select(!drop)
  
 

# 2010 - 2019 metro/micro areas 
# Sacramento = 2012
# Fairbanks = 2013
# Phoenix = 2018 
# Payson = 2018

metro_areas <- read_excel(here("data", "processed", "census", "2010_2019", "metro_areas_cbsa-met-est2019-annres.xlsx"), sheet = 2) %>% 
  mutate(area = str_sub(area, 2)) 

sacramento_2012 <- metro_areas %>%
  select(area, `2012`) %>% 
  filter(area == "Sacramento-Roseville-Folsom, CA Metro Area") %>% 
  pivot_longer(cols = `2012`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "California")

fairbanks_2013 <- metro_areas %>%
  select(area, `2013`) %>% 
  filter(area == "Fairbanks, AK Metro Area") %>% 
  pivot_longer(cols = `2013`, names_to = "year", values_to = "pop") %>%
  mutate(state = "Alaska")

phoenix_2018 <- metro_areas %>% 
  select(area, `2018`) %>% 
  filter(area == "Phoenix-Mesa-Chandler, AZ Metro Area") %>% 
  pivot_longer(cols = `2018`, names_to = "year", values_to = "pop") %>%
  mutate(state = "Arizona")

  
micro_areas <- read_excel(here("data", "processed", "census", "2010_2019", "micro_areas_cbsa-mic-est2019-annres.xlsx"), sheet = 2) %>% 
  mutate(area = str_sub(area, 2))

payson_2018 <- micro_areas %>% 
  select(area, `2018`) %>% 
  filter(area == "Payson, AZ Micro Area") %>% 
  pivot_longer(cols = `2018`, names_to = "year", values_to = "pop") %>%
  mutate(state = "Arizona")



# Towns and places 2010 to 2019 
# Pinehurst city, Idaho - 2014 
# Lamar city, Colorado - 2016
# Klamath Falls city, Oregon - 2016 
# Pagosa Springs town, Colorado - 2014
# Telluride town, Colorado - 2014 
# Provo and Logan, UT - 2019 


cities_and_towns <- read_excel(here("data", "processed", "census", "2010_2019","towns_and_cities_SUB-IP-EST2019-ANNRNK.xlsx"), sheet = 2)
colorado_towns <- read_excel(here("data", "processed", "census", "2010_2019", "co_SUB-IP-EST2019-ANNRES-08.xlsx"), sheet = 2)

telluride_2014 <- colorado_towns %>% 
  select(city, `2014`) %>% 
  filter(city == "Telluride town, Colorado") %>% 
  mutate(`2014` = as.numeric(`2014`)) %>% 
  pivot_longer(cols = `2014`, names_to = "year", values_to = "pop") %>%
  mutate(state = "Colorado") %>% 
  rename(area = city)


lamar_2016 <- colorado_towns %>% 
  select(city, `2016`) %>% 
  filter(city == "Lamar city, Colorado") %>% 
  mutate(`2016` = as.numeric(`2016`)) %>% 
  pivot_longer(cols = `2016`, names_to = "year", values_to = "pop") %>%
  mutate(state = "Colorado") %>% 
  rename(area = city)

pinehurst_2014 <- read_excel(here("data", "processed", "census", "2010_2019", "id_SUB-IP-EST2019-ANNRES-16.xlsx"), sheet = 2) %>% 
  select(city, `2014`) %>% 
  filter(city == "Pinehurst city, Idaho") %>% 
  pivot_longer(cols = `2014`, names_to = "year", values_to = "pop") %>%
  mutate(state = "Idaho") %>% 
  rename(area = city)


klamath_falls_2016 <- read_excel(here("data", "processed", "census", "2010_2019", "or_SUB-IP-EST2019-ANNRES-41.xlsx"), sheet = 2) %>% 
  select(city, `2016`) %>% 
  filter(city == "Klamath Falls city, Oregon") %>% 
  pivot_longer(cols = `2016`, names_to = "year", values_to = "pop") %>%
  mutate(state = "Oregon") %>% 
  rename(area = city)


provo_and_logan_2019 <- cities_and_towns %>% 
  select(area, `2019`) %>% 
  filter(area %in% c("Provo city, Utah", "Logan city, Utah")) %>% 
  pivot_longer(cols = `2019`, names_to = "year", values_to = "pop") %>%
  mutate(state = "Utah")


# Counties 2010 to 2019 

maryland_2018 <- read_excel(here("data", "processed", "census", "2010_2019", "md_co-est2019-annres-24.xlsx"), sheet = 2) %>% 
  mutate(county = str_sub(county, 2)) %>%
  select(county, `2018`) %>% 
  filter(county %in% c("Anne Arundel County, Maryland", "Baltimore County, Maryland", "Carroll County, Maryland", "Howard County, Maryland",
         "Harford County, Maryland")) %>% 
  pivot_longer(cols = `2018`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "Maryland") %>% 
  rename(area = county)
  

utah_2019 <- read_excel(here("data", "processed", "census", "2010_2019", "ut_co-est2019-annres-49.xlsx"), sheet = 2) %>% 
  mutate(county = str_sub(county, 2)) %>%
  select(county, `2019`) %>% 
  filter(county %in% c( "Salt Lake County, Utah", "Davis County, Utah")) %>% 
  pivot_longer(cols = `2019`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "Utah") %>% 
  rename(area = county)


idaho_2014 <- read_excel(here("data", "processed", "census", "2010_2019", "id_co-est2019-annres-16.xlsx"), sheet = 2) %>% 
  mutate(county = str_sub(county, 2)) %>%
  select(county, `2014`) %>% 
  filter(county == "Ada County, Idaho") %>% 
  pivot_longer(cols = `2014`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "Idaho") %>% 
  rename(area = county)


# Counties 2020 and after

# California

imperial_2020 <- read_excel(here("data", "processed", "census", "2020_2022", "ca_co-est2022-pop-06.xlsx"), sheet = 2) %>% 
  mutate(county = str_sub(county, 2)) %>%
  select(county, `2020`) %>% 
  filter(county == "Imperial County, California") %>% 
  pivot_longer(cols = `2020`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "California") %>% 
  rename(area = county)
  
california_counties_2021 <- read_excel(here("data", "processed", "census", "2020_2022", "ca_co-est2022-pop-06.xlsx"), sheet = 2) %>% 
  mutate(county = str_sub(county, 2)) %>%
  select(county, `2021`) %>% 
  filter(county %in% c("Butte County, California", "Calaveras County, California", "Tuolumne County, California", "Ventura County, California",
                       "Imperial County, California")) %>% 
  pivot_longer(cols = `2021`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "California") %>% 
  rename(area = county)
  
detroit_2022 <- read_excel(here("data", "processed", "census", "2020_2022", "mi_co-est2022-pop-26.xlsx"), sheet = 2) %>% 
  mutate(county = str_sub(county, 2)) %>%
  select(county, `2022`) %>% 
  filter(county %in% c("Livingston County, Michigan", "Macomb County, Michigan", "Monroe County, Michigan",
                       "Oakland County, Michigan", "St. Clair County, Michigan", "Washtenaw County, Michigan", "Wayne County, Michigan")) %>% 
  pivot_longer(cols = `2022`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "Michigan") %>% 
  rename(area = county)
  
washington_2020 <- read_excel(here("data", "processed", "census", "2020_2022","wa_co-est2022-pop-53.xlsx"), sheet = 2) %>% 
  mutate(county = str_sub(county, 2)) %>%
  select(county, `2020`) %>% 
  filter(county %in% c("Walla Walla County, Washington", "Benton County, Washington", "Franklin County, Washington")) %>% 
  pivot_longer(cols = `2020`, names_to = "year", values_to = "pop") %>% 
  mutate(state = "Washington") %>% 
  rename(area = county)




federal_register_areas <- rbind(california_counties_2008, bakersfield_2008, sacramento_2012, fairbanks_2013, phoenix_2018,
              payson_2018, telluride_2014, lamar_2016, pinehurst_2014, klamath_falls_2016, provo_and_logan_2019,
              maryland_2018, utah_2019, idaho_2014, imperial_2020, california_counties_2021, detroit_2022, washington_2020)


write.csv(federal_register_areas, "data/processed/for_vis/federal_register_areas.csv")















  