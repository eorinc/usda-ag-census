library(tidyverse)
library(usdata)
library(rgeos)
library(tidyUSDA)

# Download data ----

# Get an API key here: https://quickstats.nass.usda.gov/api
apikey <- "YOUR-API-KEY-HERE"

years <- c("2012", "2017")

# Table 3 ---- 
# Cover Crops Seed Purchased (not available for 2012)
data <- list()
for (y in years[2]) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    group = "EXPENSES",
    domain = "TOTAL",
    commodity = "SEEDS"
  ) %>%
    filter(prodn_practice_desc=="FOR COVER CROPS")
}

cover.crops.seed.purchased <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(cover.crops.seed.purchased, "table_3_cover_crops_seed_purchased.csv")

# Table 8 ----
# Land Area
data <- list()
for (y in years) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    domain = "TOTAL",
    commodity = "LAND AREA"
  )
}

land <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(unit_desc %in% c("ACRES")) %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

# Farms & Land in Farms
data <- list()
for (y in years) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    domain = "TOTAL",
    commodity = "FARM OPERATIONS"
  )
}

farms <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(class_desc=="ALL CLASSES" & unit_desc %in% c("ACRES", "OPERATIONS")) %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

# Total Cropland & Harvested Cropland
data <- list()
for (y in years) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    domain = "TOTAL",
    commodity = "AG LAND"
  )
}

cropland <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(class_desc %in% c("CROPLAND", "CROPLAND, HARVESTED") & 
           unit_desc %in% c("ACRES", "OPERATIONS") &
           prodn_practice_desc=="ALL PRODUCTION PRACTICES") %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(bind_rows(land, farms, cropland), "table_8_farms_and_cropland.csv")

# Pastureland
data <- list()
for (y in years) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    domain = "TOTAL",
    commodity = "AG LAND"
  )
}

pastureland <- bind_rows(data) %>%
  filter((str_detect(short_desc, "PASTURELAND") | str_detect(short_desc, "WOODLAND, PASTURED") | str_detect(short_desc, "CROPLAND, PASTURED ONLY")) & !str_detect(short_desc, "EXCL CROPLAND & PASTURELAND")) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(pastureland, "table_8_pastureland.csv")

# Table 11 ----
# Cattle and Calves
data <- list()
for (y in years) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    commodity = "CATTLE"
  )
}

cattle <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(statisticcat_desc=="INVENTORY" &
           prodn_practice_desc=="ALL PRODUCTION PRACTICES") %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(cattle, "table_11_cattle_and_calves.csv")

# Table 12 ----
# Hogs and Pigs
data <- list()
for (y in years) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    commodity = "HOGS"
  )
}

hogs <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(statisticcat_desc=="INVENTORY" &
           prodn_practice_desc=="ALL PRODUCTION PRACTICES") %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(hogs, "table_12_hogs_and_pigs.csv")

# Table 13 ----
# Sheep and Lambs
data <- list()
for (y in years) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    commodity = "SHEEP"
  )
}

sheep <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(statisticcat_desc=="INVENTORY" &
           prodn_practice_desc=="ALL PRODUCTION PRACTICES") %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(sheep, "table_13_sheep_and_lambs.csv")

# Table 14 ----
# Goats
data <- list()
for (y in years) {
  data[[y]] <- getQuickstat(
    key = apikey,
    year = y,
    program = "CENSUS",
    state = "MINNESOTA",
    commodity = "GOATS"
  )
}

goats <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(statisticcat_desc=="INVENTORY" &
           prodn_practice_desc=="ALL PRODUCTION PRACTICES") %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(goats, "table_14_goats.csv")

# Table 26 ----
# Field Seeds, Grass Seeds, Forage, Hay and Silage
data <- list()
for (y in years) {
  data[[y]] <-
    getQuickstat(
      key = apikey,
      year = y,
      program = "CENSUS",
      state = "MINNESOTA",
      group = "FIELD CROPS"
    )
  
}

seeds <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(commodity_desc %in% c("HAY", "HAYLAGE", "HAY & HAYLAGE", "LEGUMES")) %>%
    select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
    arrange(county_name, year, unit_desc, short_desc)

write_csv(seeds, "table_26_seeds_forage_hay_silage.csv")

# Table 41 ----
# Land Use Practices

#NOTE: for some reason the 2012 county-level data does not show up in this query
data <- list()
for (y in years) {
  data[[y]] <-
    getQuickstat(
      key = apikey,
      year = y,
      program = "CENSUS",
      state = "MINNESOTA",
      commodity = "PRACTICES"
    )
}

land.use <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(class_desc %in% c("LAND USE, CROPLAND", 
                           "LAND USE") &
           prodn_practice_desc %in% c("CONVENTIONAL TILLAGE", 
                                      "CONSERVATION TILLAGE, NO-TILL", 
                                      "CONSERVATION TILLAGE, (EXCL NO-TILL)", 
                                      "COVER CROP PLANTED, (EXCL CRP)", 
                                      "CONSERVATION EASEMENT")) %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(land.use, "table_41_land_use_practices.csv")

# Table 43 ----
# Selected Practices
data <- list()
for (y in years) {
  data[[y]] <-
    getQuickstat(
      key = apikey,
      year = y,
      program = "CENSUS",
      state = "MINNESOTA",
      commodity = "PRACTICES"
    )
}

selected.practices <- bind_rows(data) %>%
  filter(agg_level_desc %in% c("STATE", "COUNTY")) %>%
  filter(class_desc %in% c("ALLEY CROPPING & SILVAPASTURE", "ALL CLASSES") &
           prodn_practice_desc %in% c("ALL PRODUCTION PRACTICES", 
                                      "ROTATIONAL OR MGMT INTENSIVE GRAZING")) %>%
  select(county_name, year, Value, unit_desc, source_desc, agg_level_desc, short_desc, domain_desc, domaincat_desc, commodity_desc, class_desc, prodn_practice_desc, statisticcat_desc) %>%
  arrange(county_name, year, unit_desc, short_desc)

write_csv(selected.practices, "table_43_selected_practices.csv")


