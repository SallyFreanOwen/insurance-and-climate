setwd("~/EQC-climate-change-part-two")

### Weather data 

# load the ncdf4 package
library(ncdf4)
# and for using the ncdf4 package:
library(ncdf.tools)
library(RNetCDF)

# other helpful things... 
library(chron)
library(RColorBrewer)
library(lattice)
library(reshape2)
library(dplyr)

# more helpful things 
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis - "Rgdal is what allows R to understand the structure of shapefiles by providing functions to read and convert spatial data into easy-to-work-with R dataframes" 
library(RSAGA)
library(ggplot2) # package for plotting
library(GISTools)

# read in the rain data (note this is only one model, and initially just the historic, 1971-2005)
raindata <- nc_open("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/Precip/Mon_TotalPrecipCorr_VCSN_BCC-CSM1.1_1971-2005_RCPpast.nc")

# info on the data:
print(raindata)
# print(paste("The file has",raindata$nvars,"variables"))

# naming the "rain" variable, which has three dimensions (lat lon t)
rain <- raindata$var[[3]] 
# and naming each dimension: 
lon <- ncvar_get(raindata, "longitude")
lat <- ncvar_get(raindata, "latitude")
t <- ncvar_get(raindata, "time")



rain <- raindata$var[[3]] 
# store this data in a 3-dimensional array (rather than a .nc file) 
rain.array <- ncvar_get(raindata, "rain") 
dim(rain.array) 

# NB IGNORE ELEVATION VARIABLE - NIWA DID NOT INCLUDE THIS INFO.
#elevation <- raindata$var[[2]]
#head(elevation)
#elevation.table <- ncvar_get(raindata, "elevation") 
#dim(elevation.table) 

# checking what the convention is for missing variables, known as "fill values"
fillvalue <- ncatt_get(raindata, "rain", "_FillValue")
fillvalue

# now that we have the array of rain info saved, closing the .nc file 
nc_close(raindata)

# Tidying: 
rain.array[rain.array == fillvalue$value] <- NA # replacing fill value of -9999 for NA 

# Pulling out one timeslice (or trying to:)
rain.tslice1 <- rain.array[, , 1] 
dim(rain.tslice1)

I     <- rain$varsize

for(i in 1:I) {
  rain.tslice.i <- rain.array[, , i] 
  r.i <- raster(t(rain.tslice.i), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
}

# Saving as a raster 
r <- raster(t(rain.tslice1), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat), crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))
par(mar=c(1,1,1,1)) # (making margins large enough) 
plot(r)

# Exporting raster as ascii 
# write.ascii.grid(rain.tslice, "raster", header = NULL, write.header = TRUE)

# Exporting as Polygon attempt 
rainpolygons <- rasterToPolygons(r)
plot(rainpolygons)
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
