
# Calculate the delta between future and current to countries products of Rice 
# Author: 
# CIAT, 2017

# Load libraries

require(raster)
require(rgdal)
require(tidyverse)
require(lubridate)
require(spdplyr)
require(chron)
require(magrittr)
require(sf)

# Load data

path <- 'Z:/RiceCalendar'
cnt  <- shapefile(paste0(path, '/_shp/_base/all_countries.shp')) %>%
            dplyr::select(ENGLISH, UNREG1)
shp  <- shapefile(paste0(path, '/_shp/RiceCalendar_v1/RiceCalendar_v1.shp')) %>%
            dplyr::select(ISO, COUNTRY, REGION, SUB_REGION, PLANT_PK1, HARV_PK1)

sort(unique(cnt$UNREG1))
cnt_la <- filter(cnt, UNREG1 %in% c('South America', 'Central America'))

# Conversion julian day to month

plant <- shp %>%
            dplyr::select(PLANT_PK1) %>%
            extract2(1)

harv <- shp %>%
            dplyr::select(HARV_PK1) %>%
            extract2(1) %>%
            as.numeric()

month_plant <- month.day.year(plant)$month#x <- as.vector(unlist(month.day.year(plant))[1:length(plant)])
month_harv  <- month.day.year(harv)$month

shp_month <- shp %>%
                mutate(month_plan = month_plant,
                       month_harv = month_harv)

# Selection contries for Latin America and write the shapefile into the disk

shp_month_la <- filter(shp_month, COUNTRY %in% cnt_la$ENGLISH)
shp_month_la_2 <- st_as_sf(as(shp_month_la, "SpatialPolygonsDataFrame"))
# write_sf(obj = shp_month_la_2, dsn = path, layer = 'Rice_calendar_v1_month', driver = 'ESRI Shapefile')

# Dissolve the maps to get the study area, then we are going to do the extraction by mask (current and 2030)

studyArea <- mutate(shp_month_la, ID = rep(1, 203))
studyArea <- aggregate(studyArea, by = shp_month_la$ID)
writeOGR(studyArea, dsn = paste0(path, '_shp'), layer = 'studyArea.shp', driver = 'ESRI Shapefile')

