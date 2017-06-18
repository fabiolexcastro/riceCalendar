
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


fmerge <- function(rasters1, fun, ...){
  ex <- raster(union(rasters1))
  res(ex) <- res(rasters1[[1]])
  for( i in 1:length(rasters1) )
    rasters[[i]] <- merge(rasters1[[i]], ex)
  rasters <- stack(rasters1)
  fun(rasters1, ...)
}

# Data

path <- 'Z:/RiceCalendar'
delta <- mixedsort(list.files(paste0(path, '/_raster/_climate/_delta'), full.names = T, pattern = '.asc$')) %>%
            lapply(raster)

test <- mosaic(delta[[1]], delta[[2]], fun = mean)
plot(test)


rasters.mosaicargs <- delta
rasters.mosaicargs$fun <- mean
rasters.mosaicargs$na.rm <- TRUE

mosaic  <- do.call(mosaic, rasters.mosaicargs)
mosaic2 <- do.call(mosaic, rasters.mosaicargs)

rm(rasters.mosaicargs)

rast.list <- lapply(1:length(delta), function(x) {
                      
                                          raster(delta[x]) 
    
                                        })






