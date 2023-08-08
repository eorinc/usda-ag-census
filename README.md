# USDA Agricultural Census processing scripts

This repository was created by Emmons & Olivier Resources, Inc. in August of 2023 to memorialize and document the steps used to recreate some of the summary tables that can be found on [this page](https://www.nass.usda.gov/Publications/AgCensus/2017/Full_Report/Volume_1,_Chapter_2_County_Level/Minnesota/). The tables are downloadable only as PDFs, and contain formatting that makes converting the data to something usable (e.g., copying and pasting into Excel) quite cumbersome. 

To sidestep this issue, the source data was downloaded using the `tidyUSDA` package and summarized at both the state and county levels. The [script](recreate-summary-tables.R) contained in this repository will hopefully facilitate repeating this process on future census data.

To use this script, all that is needed is an API key, which can be obtained [here](https://quickstats.nass.usda.gov/api/).
