## Sally Owen
## EQC project, part two - community recovery 

## Re-importing/working in R with Git, for ability 
## to deal with spatial objects and analyse in 
## one script type - for reproducibility and to
## supply code upon publishing if necessary 

setwd("~/EQC-climate-change-part-two")

# Installation of packages required

# install.packages("sp") # enables transformations and projections, provides functions for working with spatial polygon objects. 
# install.packages("tidyverse")
#install.packages("ncdf4") # for working with netcdf data - e.g. climate data
#install.packages("ncdf.tools")
#install.packages("ncdf.tools")
#install.packages("RNetCDF")
#install.packages("chron")
#install.packages("RColorBrewer")
#install.packages("lattice")
#install.packages("reshape2")
#install.packages("dplyr")
#install.packages("raster") # package for raster manipulation
#install.packages("gdalUtils") #necessary for tmap 
#install.packages("rgdal", type='binary') # package for geospatial analysis
#install.packages("ggplot2")
#install.packages("units", type='binary') #required for tmap
#install.packages("tmap", type='binary') #alternative to ggplot2 designed for spatial data
#install.packages("RSAGA")
#install.packages("GISTools")
#install.packages("Hmisc") # for equivalent of Stata "codebook" 

###################################################################################

### EQC data

#loading packages required 
library(sp) 
library(tidyverse)

portfolio_raw <- read_csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/From_Work_Computer/EQC_Portfolio_2017_Motu.csv")
head(portfolio_raw)

portfolio_geo <- filter(portfolio_raw, PortfolioID != ".") #only valid portfolio lines
#portfolio_valid <- filter(portfolio_raw, $PortfolioID != is.na)

# Set coordinates (in doing so promote argument from dataframe to SpatialPointsDataFrame)
coordinates(portfolio_geo) <- portfolio_geo[c("WGS84Longitude", "WGS84Latitude")]

# Eyeballing the property data
class(portfolio_geo)
dimensions(portfolio_geo)
summary(portfolio_geo) #min/max summary stats
#str(portfolio_geo)
plot(portfolio_geo)

### Small exercise: practicing subsetting and re-plotting 
portfolio_over250k <- portfolio_geo[portfolio_geo$MDwellingValue >= 250000, ]
# check (eyeball)
head(portfolio_over250k$MDwellingValue, 5)

library(tmap) 
# checking what attributes we have connected to the portfolio SpatialPoints  
names(portfolio_geo) 
# EQC supplied WGS84 coordinates, so assigning this as projection below. wgs684 has epsg code 4326
proj4string(portfolio_geo) <- CRS("+init=epsg:4326")
qtm(portfolio_geo) #alternative to plot - Quick Thematic Map (qtm)

###########################################################################

# import claim data
claim_raw <- read.csv("/Users/sallyowen/Documents/Public_Insurance_and_Climate_Change_Project/Raw_Data/Motu_EQC_LSF_claims_post_2000.csv")
head(claim_raw)

library(dplyr)
portfolio_geo_claim <- merge(portfolio_geo, claim_raw, by = "PortfolioID", all.x = TRUE, duplicateGeoms = TRUE )
# NTS: should also check whether there are others I can merge in - eg on EQCPropertyGroup geo codes or suburbs
# claim_portfolio_EQCprop_geo <- merge(claim_portfolio_geo, portfolio_raw, by="EQCPropertyGroup")

# checking we know what this is and what's in it...
class(portfolio_geo_claim)
slotNames(portfolio_geo_claim)
summary(portfolio_geo_claim)
## load a library for simple summary stats (for use on dataframes only - not spatial)
library(Hmisc)
describe(portfolio_geo_claim)

# seeing if I can subset portfolio by claim data...
claim_geo <- subset(portfolio_geo_claim, !is.na(ClaimID) )
summary(claim_geo) 

#plot(claim_geo)
qtm(claim_geo)
plot(portfolio_geo)


####
## for import of external spatial formats:
# install.packages("rgdal") 
# install.packages("maptools")

### Map base data 

# Get coastal and country world maps as Spatial objects
#install.packages("rnaturalearth")
library(rnaturalearth)
coast_sp <- ne_coastline(scale = "medium")
countries_sp <- ne_countries(scale = "medium")

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








