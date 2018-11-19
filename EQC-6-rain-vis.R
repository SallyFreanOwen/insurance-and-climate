# EQC 6 - niwa data vis 

#setwd("~/EQC-climate-change-part-two")

library(sf)
library(tidyverse)
library(viridis)
library(rvest)
library(dplyr)

# Part one - points 
precipOneDay <- filter(precipWorking, day == "1999-01-01")
precipOneDay <- st_as_sf(precipOneDay, coords = c("longitude", "latitude"), crs = 4326)
plot(precipOneDay, main="NIWA grid points") 

# Part Two - series 
precipOneCell <- filter(precipWorking, longitude == first(precipWorking$longitude, order_by = NULL, default = default_missing(x)) & latitude == first(precipWorking$latitude, order_by = NULL, default = default_missing(x)))
precipOneCell <- st_as_sf(precipOneCell, coords = c("longitude", "latitude"), crs = 4326)
plot(precipOneCell$rain)

require(ggplot2)
theme_set(theme_bw()) # Change the theme to my preference
ggplot(aes(x = day, y = rain), data = precipOneCell) + geom_point()

# Part Three - whole dataset 

#par(mar=c(1,1,1,1)) # (making margins large enough) 
#plot(st_geometry(precipSP), main="NIWA grid points", pch = 1, cex = 0.1, col = 1, bg = 1, type = "p")





## Part two - raster 
#
## store this data in a 3-dimensional array (rather than a .nc file) 
#rain.array <- ncvar_get(raindata, "rain") 
#dim(rain.array) 
## Tidying: 
## checking what the convention is for missing variables, known as "fill values"
#fillvalue <- ncatt_get(raindata, "rain", "_FillValue")
#fillvalue
#rain.array[rain.array == fillvalue$value] <- NA # replacing fill value of -9999 for NA 
#
## Pulling out one timeslice (or trying to:)
#rain.tslice1 <- rain.array[, , 1] 
#dim(rain.tslice1)
#
##I     <- rain$varsize
##for(i in 1:I) {
#  #rain.tslice.i <- rain.array[, , i] 
#  #r.i <- raster(t(rain.tslice.i), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
##}
#
## Saving as a raster 
#rasterRain1 <- raster(t(rain.tslice1), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
#par(mar=c(1,1,1,1)) # (making margins large enough) 
#plot(rasterRain1)
