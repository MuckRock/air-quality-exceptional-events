# air-quality-exceptional-events
This repository contains data and findings that are part of a collaboration between MuckRock, the California Newsroom and the Guardian about the use of a legal tool called the exceptional events rule, which allows local air agencies across the United States to remove bad air days from the records of the Environmental Protection Agency (EPA) if the data is affected by an "exceptional event," like a wildfire. 

You can find earlier work about wildfire pollution from MuckRock and the California Newsroom in [`california-wildfire-pollution`](https://github.com/MuckRock/california-wildfire-pollution) and [`gao-wildfire-exceptions`](https://github.com/MuckRock/gao-wildfire-exceptions). More data and analysis driving the investigations of MuckRock's news team is cataloged in [`news-team`](https://github.com/MuckRock/news-team).

## Data

All raw data can be found in [Google Drive](https://drive.google.com/drive/u/0/folders/1YCLncS7uQkZBWLybMU5tR4OeLuNRIysP). The scripts to clean and organize this data can be found in [`etl`](etl) and the output of those scripts can be found in [`data/processed`](data/processed). Processed data used for [`analysis`](analysis) and visualization. 

### EPA's Air Quality System 
The [EPA’s Air Quality System (AQS)](https://www.epa.gov/aqs) is a hub of all the different types of air quality data the EPA collects across the country. These data are provided by the EPA in different forms for scientists and members of the public to analyze data primarily in the context of public health, according to the EPA. 

One year ago, we noticed a column in some of these publicly available datasets called “Events Included.” When we referred back to the [AQS data dictionary](https://aqs.epa.gov/aqsweb/documents/AQS_Data_Dictionary.html), we found that this column indicates whether the data recorded includes or excludes data that was affected by [an exceptional event](https://www.epa.gov/air-quality-analysis/treatment-air-quality-data-influenced-exceptional-events-homepage-exceptional). This is the only data on exceptional events that the EPA makes available to the public. 

### AQS Readings 
Over a period of several months, we negotiated a data request with the EPA to recieve more extensive AQS data that includes variables and information mentioned in [the slides from both older](https://www.epa.gov/sites/default/files/2018-05/documents/webinar_on_exceptional_events_mitigation_plans_20180418_508.pdf) and [more recent presentations given by the EPA’s air quality department](https://cleanairact.org/wp-content/uploads/2022/05/Exceptional-Events-Program-Updates-Beth-Palma.pdf). 

The [data we recieved](https://drive.google.com/file/d/1bSQ8-3ljmUkrWKIxyuSHIbUxDc4qxdiZ/view?usp=drive_link) are air monitor readings for all EPA air monitors across the country that were flagged for an exceedence caused by exceptional events. Each row has a monitor ID and a reading at that monitor along with several columns that describe what the event was, when it was submitted, and any text comments on the event. 


### Exceptional Events 

The EPA also provided us with [a dataset of exceptional events](https://docs.google.com/spreadsheets/d/13AODNzQFGAAyaNCHSm7ROTk65_4_0FKU/edit?usp=drive_link&ouid=106876771194730767051&rtpof=true&sd=true). The relationship between this data and other data we received, the AQS data, is often called a one-to-many relationship in database language. That is, one exceptional event could include multiple readings over multiple days. 

Each row in this data is an exceptional event with similar columns to the AQS data described above. 

### Final agency actions 


## Methodology 

### Demonstrations

### County-days 

### Population impacted 

## Questions / Feedback
Contact Dillon Bergin at dillon@muckrock.com
