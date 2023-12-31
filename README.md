# air-quality-exceptional-events

This repository contains data and findings for a collaboration between MuckRock, National Public Radio's The California Newsroom and the Guardian about the use of a legal tool called the exceptional events rule, which allows local air agencies across the United States to remove bad air days from the regulatory record of the Environmental Protection Agency (EPA) if the data is affected by an "exceptional event," like a wildfire.

You can find earlier work about wildfire pollution from MuckRock and the California Newsroom in [`california-wildfire-pollution`](https://github.com/MuckRock/california-wildfire-pollution) and [`gao-wildfire-exceptions`](https://github.com/MuckRock/gao-wildfire-exceptions). More data and analysis driving the investigations of MuckRock's news team are cataloged in [`news-team`](https://github.com/MuckRock/news-team).

## Data

All raw data can be found in [`data/raw`](data/raw), any data that involved manual work, like annotating documents, can be found in [`data/manual`](data/manual). The scripts to clean and organize this data can be found in [`etl`](etl) and the output of those scripts can be found in [`data/processed`](data/processed). Processed data is used for [`analysis`](data/analysis) and [`visualization`](data/processed/for_vis).

We have also published the data in a more user-friendly way through [a tool called Datasette](https://datasette.io/). If you follow the the link to our [Datasette of exceptional events data](https://muckrock.datasette.cloud/epa-air-quality-exceptional-events/request_exclusion_flagged_hours_by_monitor), you will be able to see a map of all EPA monitors flagged for exceptional events. From there, you can toggle, or “facet,” to view the data by different categories and organize it, by state, type of event (Canadian or U.S. wildfire, high winds) or type of pollutant (particulate matter, ozone).

### EPA's Air Quality System

The [EPA’s Air Quality System (AQS)](https://www.epa.gov/aqs) is a hub of the different types of air quality data the EPA collects across the country. These data are provided by the EPA in different forms for scientists and members of the public to analyze.

The exceptional events rule was passed into law in 2005 and allows local air agencies to earmark or "flag" data from regulatory air monitors to be excluded from official EPA statistics and regulatory decisions if the EPA agrees that the data has “regulatory significance” and has been affected by pollution that is “uncontrollable.” 

One year ago, we noticed a column in some of the AQS datasets called `Events Included`. When we referred back to the [AQS data dictionary](https://aqs.epa.gov/aqsweb/documents/AQS_Data_Dictionary.html), we found that this column indicates whether the data recorded includes or excludes data that was affected by [an exceptional event](https://www.epa.gov/air-quality-analysis/treatment-air-quality-data-influenced-exceptional-events-homepage-exceptional). 

### AQS Readings
Data on exceptional events and whether the EPA agreed to forgive them is hard to find in the EPA's AQS data. MuckRock, The California Newsroom and The Guardian negotiated a data request with the EPA to recieve this hard to find data, which includes variables and information mentioned in [the slides from both older](https://www.epa.gov/sites/default/files/2018-05/documents/webinar_on_exceptional_events_mitigation_plans_20180418_508.pdf) and [more recent presentations given by the EPA’s air quality department](https://cleanairact.org/wp-content/uploads/2022/05/Exceptional-Events-Program-Updates-Beth-Palma.pdf).

The [data we recieved](data/raw/muckrock_req_excl_ee_v2.xlsx) are air monitor readings for all EPA air monitors across the country that were flagged for an exceedence caused by exceptional events  from Jan. 1, 2016, to Jan. 31, 2022 — the most recent "request exclusion" [data the EPA could provide](https://www3.epa.gov/ttnairs1/airsaqsORIG/conference/AQSBasics_IntrotoRetrievals.pdf), as of September 2023. Each row has a monitor ID and a reading at that monitor, along with several columns that describe what the event was, when it was submitted and any text comments on the event. 

Flagging data with a "request exclusion" flag in AQS is one of the first steps in the exceptional events process, though agencies can also add an "informational" flag to data as well. We were able to recieve more recent [data that was informationally flagged](data/raw/muckrock_informational_ee.csv) from May 1, 2023 to Aug. 31, 2023. As the name implies, these flags are not necessarily a step towards the exceptional events rule, but rather a snapshot in time and a note for the agency as they earmark data they may want to review later. 

### Exceptional Events

The EPA also provided us with [a dataset of exceptional events](data/raw/exceptional_events_1_1_2016_copy_for_MuckRock.xls). The relationship between this data and other data we received, the AQS data, is often called a one-to-many relationship in database language. That is, one exceptional event could include multiple readings over multiple days.

Each row in this data is an exceptional event with similar columns to the AQS data described above. We requested that the EPA join the AQS data with the IDs in this exceptional events dataset so that we would have request exclusion flagged data that were ultimately tied to an exceptional event submission in a seperate system. Otherwise, a portion of the data would have included flags that agencies may not have pursued or submitted as exceptional events. 

### Final agency actions

When the EPA issues a concurrence to exclude the AQS data from later [Design Values](https://www.epa.gov/air-trends/air-quality-design-values), the agency [often includes a sentence at the end of the concurrence letter](https://www.documentcloud.org/documents/23843798-gbuapcd_2020_wildfirepm10_epa_concurrence_letter) clarifying that this change in numbers may affect future decisions: “EPA’s concurrence is a preliminary step in the regulatory process for actions that may rely on these data and does not constitute final Agency action.”

To understand how often final agency actions happen and where, we reviewed 93 rules published by the EPA in the [Federal Register](https://www.federalregister.gov/) that included the words “exceptional events.” We sorted out documents that were not final actions tied to state or local decisions, or didn’t explicitly confirm the decision was influenced by exceptional events that were excluded from the relevant data in all but one case. In one case, we did include a final agency action that did not mention "exceptional events" because the proposed rule did include the mention of exceptional event and we knew that location, Salt Lake City, Utah, had recieved concurrence for data that the rule pertained to. We include the EPA's concurrence on that event with the other documents [we have made public](https://www.documentcloud.org/projects/final-agency-actions-215474/). In those doucments, you will see we whittled 93 rules rules down to [18 actions](https://www.documentcloud.org/projects/final-agency-actions-215474/). In our review process, we added metadata on DocumentCloud to each document for which county, city or core-based statistical area the EPA's decision pertains to and the year the decision was made. We then [scraped this metadata using a DocumentCloud Add-On](https://www.documentcloud.org/app?q=%2Buser%3Adillon-bergin-104081%20#add-ons/cam-garrison/documentcloud-metadata-grabber) to create [a list of areas across the country](data/manual/federal_register_reshaped.csv) where the EPA has issued final Agency action.

## Methodology

We also consulted with five atmospheric scientists who have experience studying air pollution and its health impacts. As we received data and documents from the EPA, these experts helped shape our methodology. Once we finished our analysis, we shared our findings with them, to help validate and interpret the data. In collaboration with one of these experts, Dan Jaffe, a University of Washington-Bothell professor of atmospheric and environmental chemistry, we will present our work at the annual American Geophysical Union conference.

### Events and demonstrations

We count exceptional events as any event in the [exceptional events dataset](data/raw/exceptional_events_1_1_2016_copy_for_MuckRock.xls). This data contains 699 events with a unique exceptional event ID.

A smaller subset of events later become "demonstrations," meaning the local air agency has both flagged the event and written a "demonstration" to the EPA to advocate that the EPA officially concur on excluding some or all of the data that the agency initially flagged. Demonstrations are the longform evidence, logic and analysis in a single document, usually over 100 pages, that the agency sends to the EPA to request exclusion of data for exceptional events. 

In addition to the data we received on exceptional events, the newsrooms [filed open-records requests](https://www.muckrock.com/project/air-quality-exceptions-1117/) for emails, contracts and demonstrations for exceptional events. In response to our open records requests, [we received 138 demonstrations](https://www.documentcloud.org/projects/exceptional-event-demonstrations-215472/) submitted to the EPA from Jan. 1, 2016, to Feb. 15, 2023. 

Because the EPA doesn’t collect all these demonstrations in one place, nor connect them to the AQS data about the events, we cannot ensure that the 138 figure represents all demonstrations for this given time period. The EPA also asserts that the unique identifiers given to event submissions in that data are just a tool generated to manage data and don’t align with events as demonstrations either. However, we found 139 unique exceptional event IDs that EPA issued a decision on in the data and the states involved closely mirror the demonstrations we received for the same time period. 

### States and provinces blamed in demonstrations 

We used the [138 demonstrations](https://www.documentcloud.org/projects/exceptional-event-demonstrations-215472/) that we recieved through [open-records requests](https://www.muckrock.com/project/air-quality-exceptions-1117/) to analyze which states were filing and who they blamed. We annotated the documents in DocumentCloud and then [scraped this metadata using a DocumentCloud Add-On](https://www.documentcloud.org/app?q=%2Buser%3Adillon-bergin-104081%20#add-ons/cam-garrison/documentcloud-metadata-grabber). Reporters Lindsay Shachnow and Holly J. McDede reviewed and annotated all the demonstrations to make this possible. 

### County-days

Because demonstrations and IDs are not a one-to-one match, we relied more on the amount of days submitted by air agencies than the amount of events. The EPA calls their decision to agree with a state or local air agency on what data to exclude from the record a “concurrence” and a rejection of that proposal a “nonconcurrence.” In [the AQS data](data/raw/muckrock_req_excl_ee_v2.xlsx), this is recorded in a column called `concurrence_indicator` with a value of either "Y" for yes and "N" for no. These indicators are added to hourly data by monitor.

As journalists, we are interested in both counting the amount of air pollution excluded from the regulatory record and understanding how different areas of the country and different pollutants compare. To this end, we developed a metric called "county-days." For any single day in a county where there is a concurrence for any number of concurrence standards at any number of monitors, we counted one county-day.

The most important trade-off is that this methodology underweights counties with more monitors where data was excluded while heavily weighting states with exceptional events that involve multiple counties. It also forgoes measuring exceptional events as single events, and highlights more clearly how much data was removed and where. Accordingly, this method makes comparing exceptional events and their impact on potential regulatory decisions easier to compare across counties and states. The EPA often, but not always, [measures attainment by county](https://www.epa.gov/green-book), so the number of days removed by county is a close proxy to the days that would cited in a regulatory decision based on the data. 

### Population impacted

With the “final Agency actions” we analyzed from the [Federal Register](https://www.federalregister.gov/), we calculated the number of people those decisions impact. The [18 documents of final action]((https://www.documentcloud.org/projects/final-agency-actions-215474/)) that we found represent several different types of geographies: towns and cities, counties and core-based statistical areas. We reviewed each document to be sure that our geographic area aligned as closely with the EPA’s as possible, and when needed, erred on the conservative side, for example, by excluding counties the EPA defined as partially included in their ruling. [We then calculated the populations](etl/federal_register_pop_estimates_current.R) for these areas [using Census population estimates](data/processed/census) for both 2022 and the year the decision was made. In the end, we estimated more than 21 million people lived in this areas when the decisions were made and 22 million live there now, so we refer to this number as "more than 21 million."

## Questions / Feedback
Contact Dillon Bergin at dillon@muckrock.com
