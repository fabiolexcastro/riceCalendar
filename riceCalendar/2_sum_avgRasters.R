
# Calculate the cliamte set to periods between harvest and crop 
# Author: 
# CIAT, 2017

# Load libraries

require(raster)
require(rgdal)
require(tidyverse)
require(spdplyr)
require(magrittr)
require(sf)
require(rgeos)
require(gtools)

# Load data

path <- 'Z:/RiceCalendar'
toMatch  <- c('prec', 'tmean')
lyrs_cur <- mixedsort(list.files(paste0(path, '/_raster/_climate/_current/_asc'), full.names = T, pattern = '.asc$')) %>%
                grep(paste0(toMatch, collapse = '|'), ., value = T) %>%
                unique() %>%
                lapply(raster)
st_cur   <- stack(lyrs_cur)

tmean_fut <- lapply(paste0(path, '/_raster/_climate/_future/_rcp85/_2030/_la/_asc/tmean_', 1:12, '.asc'), raster)
prec_fut  <- lapply(paste0(path, '/_raster/_climate/_future/_rcp85/_2030/_la/_asc/prec_', 1:12, '.asc'), raster)
st_fut    <- addLayer(stack(prec_fut), stack(tmean_fut)); rm(prec_fut, tmean_fut)

shp  <- shapefile(paste0(path, '/_shp/RiceCalendar_v1/Rice_calendar_v1_month.shp')) %>%
            mutate(ID = paste0(1:nrow(.), '_a'))

# Test

month_plant <- 'month_plan'
month_harvs <- 'month_harv'# as.numeric(as.data.frame(shp[i, month_harvs])) > as.numeric(as.data.frame(shp[i, month_plant]))

for(i in 1:nrow(shp)){
    
   print(shp$ID[i])
   # Current
  
   st_cur_cut <- st_cur %>%
                    raster::crop(., shp[i,]) %>%
                    raster::mask(., shp[i,])
   lyr_cur_cut <- unstack(st_cur_cut)
   names(lyr_cur_cut) <- names(st_cur_cut)
  
   prec_cur  <- lyr_cur_cut[1:12]
   tmean_cur <- lyr_cur_cut[12:24]
  
   # Future
   
   st_fut_cut <- st_fut %>%
                     raster::crop(., shp[i,]) %>%
                     raster::mask(., shp[i,])
   lyr_fut_cut <- unstack(st_fut_cut)
   names(lyr_fut_cut) <- names(st_fut_cut)
   
   prec_fut  <- lyr_fut_cut[1:12]
   tmean_fut <- lyr_fut_cut[12:24]
   
   if(shp$month_harv[i] > shp$month_plan[i]) {#if(posPolygon(shp, i, 'month_harv') > posPolygon(shp, i, 'month_plan'))
    
    # Current
     prec_current  <- stack(prec_cur[shp$month_plan[i]:shp$month_harv[i]]) %>%
                          sum()
     tmean_current <- stack(tmean_cur[shp$month_plan[i]:shp$month_harv[i]]) %>%
                          mean()
     
    # Future
     prec_future  <- stack(prec_fut[shp$month_plan[i]:shp$month_harv[i]]) %>%
                          sum()
     tmean_future <- stack(tmean_fut[shp$month_plan[i]:shp$month_harv[i]]) %>%
                          mean()
     
   } else {
    
    # Current
     prec_current  <- stack(prec_cur[c((shp$month_plan[i]:12),(1:shp$month_harv[i]))]) %>%
                        sum()
     tmean_current <- stack(tmean_cur[c((shp$month_plan[i]:12),(1:shp$month_harv[i]))]) %>%
                        mean()
     
     # Future
     prec_future  <- stack(prec_fut[c((shp$month_plan[i]:12),(1:shp$month_harv[i]))]) %>%
                        sum()
     tmean_future <- stack(tmean_fut[c((shp$month_plan[i]:12),(1:shp$month_harv[i]))]) %>%
                        mean()
    
   }
   
   # Calculate delta
   
   print('To write Raster')
   
   dif_prec  <- prec_future - prec_current
   dif_tmean <- tmean_future - tmean_current
   
   myproj <- CRS("+proj=longlat +datum=WGS84")
   crs(dif_prec)  <- myproj
   crs(dif_tmean) <- myproj
   
   
   writeRaster(dif_prec, paste0(path, '/_raster/_climate/_delta2/prec_', shp$ID[i], '.tif'))
   writeRaster(dif_tmean, paste0(path, '/_raster/_climate/_delta2/tmean_', shp$ID[i], '.tif'))
   
}






