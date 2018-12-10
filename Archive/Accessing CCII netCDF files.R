### Beginning to think about extracting data from a netCDF using R 

# Sally Owen 
# Public Insurance Project 
# November 2017 

# Using the ncdf4 package:
install.packages("ncdf4")
install.packages("ncdf.tools")
install.packages("ncdf.tools")
install.packages("RNetCDF")
install.packages("chron")
install.packages("RColorBrewer")
install.packages("lattice")
install.packages("reshape2")
install.packages("dplyr")
install.packages("raster") # package for raster manipulation
install.packages("rgdal") # package for geospatial analysis
install.packages("ggplot2")
install.packages("RSAGA")
install.packages("GISTools")

library(ncdf.tools)
library(ncdf4)
library(ncdf4.helpers)
library(RNetCDF)

#Loading other helpful things: 
library(chron)
library(RColorBrewer)
library(lattice)
library(reshape2)
library(dplyr)

# More helpful things 
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(RSAGA)
library(ggplot2) # package for plotting
library(GISTools)

# Setting working directory 
#setwd("/Downloads")

# Reading in a first file:
  raindata <- nc_open("Mon_TotalPrecipCorr_VCSN_BCC-CSM1.1_1971-2005_RCPpast.nc", write=FALSE, readunlim=TRUE, verbose=FALSE, auto_GMT=TRUE, suppress_dimvals=FALSE)
  #raindata <- nc_open("Mon_TotalPrecipCorr_VCSN_BCC-CSM1.1_2006-2120_RCP8.5.nc", write=FALSE, readunlim=TRUE, verbose=FALSE, auto_GMT=TRUE, suppress_dimvals=FALSE)
  
  print(raindata)
  
  print(paste("The file has",raindata$nvars,"variables"))
  
  rain <- raindata$var[[3]] # naming the "rain" variable, which has three dimension (lat long time)
  
  lon <- ncvar_get(raindata, "longitude")
  lat <- ncvar_get(raindata, "latitude")
  t <- ncvar_get(raindata, "time")
  
  rain.array <- ncvar_get(raindata, "rain") # store the data in a 3-dimensional array
  dim(rain.array) 
  
  fillvalue <- ncatt_get(raindata, "rain", "_FillValue")
  fillvalue
  
  nc_close(raindata)

# Tidying: 
  rain.array[rain.array == fillvalue$value] <- NA # replacing fill value of -9999 for NA 

# Pulling out one timeslice (or trying to:)
  rain.tslice <- rain.array[, , 1] 
  dim(rain.tslice)
  
  # Saving as a raster 
  r <- raster(t(rain.tslice), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
  plot(r)
  # Exporting raster as ascii 
  write.ascii.grid(rain.tslice, "raster", header = NULL, write.header = TRUE)
  # Exporting as Polygon attempt 
  rainpolygons <- rasterToPolygons(r)
  writeOGR(obj=rainpolygons, dsn="tempdir", layer="TotalPrecip", driver="ESRI Shapefile") # this is in geographical projection
  
varsize <- rain$varsize
ndims   <- rain$ndims
nt      <- varsize[ndims]  # Remember timelike dim is always the LAST dimension!

library(arrayhelpers)
test<-array2df(rain.array,matrix=TRUE)

for( i in 1:nt ) {
  # Initialize start and count to read one timestep of the variable.
  start <- rep(1,ndims)	# begin with start=(1,1,1,...,1)
  start[ndims] <- i	# change to start=(1,1,1,...,i) to read timestep i
  count <- varsize	# begin w/count=(nx,ny,nz,...,nt), reads entire var
  count[ndims] <- 1	# change to count=(nx,ny,nz,...,1) to read 1 tstep
  data <- ncvar_get( raindata, rain, start=start, count=count )
  
  # Now read in the value of the timelike dimension
  timeval <- ncvar_get( raindata, rain$dim[[ndims]]$name, start=i, count=1 )
  
  #print(paste("Data for variable",rain$name,"at timestep",i,"(time value=",timeval,rain$dim[[ndims]]$units,"):"))
  #print(data)
  
}

