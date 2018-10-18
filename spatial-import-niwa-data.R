### Weather data 

# load the ncdf4 package
library(ncdf4)
# and for using the ncdf4 package:
library(ncdf.tools)
library(ncdf4)
library(ncdf4.helpers)
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

# store this data in a 3-dimensional array (rather than a .nc file) 
rain.array <- ncvar_get(raindata, "rain") 
dim(rain.array) 

# checking what the convention is for missing variables, known as "fill values"
fillvalue <- ncatt_get(raindata, "rain", "_FillValue")
fillvalue

# now that we have the array of rain info saved, closing the .nc file 
nc_close(raindata)

