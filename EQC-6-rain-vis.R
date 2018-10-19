# EQC-6-rain-vis 

setwd("~/EQC-climate-change-part-two")

library(ncdf4)
library(ncdf.tools)
library(sf)
library(raster)

# store this data in a 3-dimensional array (rather than a .nc file) 
rain.array <- ncvar_get(raindata, "rain") 
dim(rain.array) 
# Tidying: 
# checking what the convention is for missing variables, known as "fill values"
fillvalue <- ncatt_get(raindata, "rain", "_FillValue")
fillvalue
rain.array[rain.array == fillvalue$value] <- NA # replacing fill value of -9999 for NA 

# Pulling out one timeslice (or trying to:)
rain.tslice1 <- rain.array[, , 1] 
dim(rain.tslice1)

#I     <- rain$varsize
#for(i in 1:I) {
  #rain.tslice.i <- rain.array[, , i] 
  #r.i <- raster(t(rain.tslice.i), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
#}

# Saving as a raster 
rasterRain1 <- raster(t(rain.tslice1), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
par(mar=c(1,1,1,1)) # (making margins large enough) 
plot(rasterRain1)
