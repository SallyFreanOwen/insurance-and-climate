# EQC 5 - niwa data import 

setwd("~/EQC-climate-change-part-two")

#  install.packages("roperators")

# load the ncdf4 package
library(ncdf4)
library(ncdf.tools)
library(sf)

# read in one of the original .nc files from niwa (note this is only one model, and just the historic, 1971-2005)
raindata <- nc_open("Data/Mon_TotalPrecipCorr_VCSN_BCC-CSM1.1_1971-2005_RCPpast.nc")

# info on the data:
print(raindata)
# print(paste("The file has",raindata$nvars,"variables"))

# naming the "rain" variable, which has three dimensions (lat lon t)
rain <- raindata$var[[3]] 
# and naming each dimension: 
#lon <- ncvar_get(raindata, "longitude")
#lat <- ncvar_get(raindata, "latitude")
#t <- ncvar_get(raindata, "time")

# coordinates from niwa grids are simply:
#niwa_coordinates <- expand.grid(lon, lat)
#plot(st_geometry(niwa_grid), main = "Niwa cell points", pch = 1, cex = 0.1, col = 1, bg = 1, type = "p")

# checking what the convention is for missing variables, known as "fill values"
fillvalue <- ncatt_get(raindata, "rain", "_FillValue")
fillvalue

# now that we have the array of rain info saved, closing the .nc file 
nc_close(raindata)

library(sf)

## Note:  at this point I use a pre-extracted/shaped csv from the actual raindata model.. 
## I want to use - need to add this code in eventually. 

# Inputing rain data as csv, transformed earlier (NB need to add that code to repository)
precip_table <- read.csv2("Data/VCSN_Rain5k_1999-2016.csv", sep=";", stringsAsFactors = FALSE)
#csv2 deals with european standards (commas/decimals swapped)

# This has columns for lat & lon, then a column for each day, containing rainfall 
# Note the "centroid" is not actually a centroid (just NIWA's coordinates for each grid)

precipWorking <- as.data.frame(precip_table)

rm(precip_table)

# prefer a "point / day / rain" column format for processing later on, with 
library(reshape2)

precipWorking <- precipWorking[2:6213]
## Problem with below - too slow 
#precipWorking <- melt(precipWorking, id=c("niwa_centroid_lon","niwa_centroid_lat"))
#names(precipWorking) <- c("longitude", "latitude", "day", "precip")
#sapply(precipWorking, class)
#precipWorking$day <- gsub("precip", "", precipWorking$day)
#precipWorking$day <- as.Date(precipWorking$day, format = "%d%m%y")

## Trying with a test subset - worked well.
#precipTest <- precipWorking[1:100,2:100]
#precipTest2 <- melt(precipTest, id=c("niwa_centroid_lon","niwa_centroid_lat"))
#names(precipTest2) <- c("longitude", "latitude", "day", "precip")
#sapply(precipTest2, class)
#precipTest2$day <- gsub("precip", "", precipTest2$day)
#precipTest2$day <- as.Date(precipTest2$day, format = "%d%m%y")

## Breakign up into parts to re-try 
precipWorking1 <- precipWorking[1:1000]
precipWorking1 <- melt(precipWorking1, id=c("niwa_centroid_lon","niwa_centroid_lat"))
names(precipWorking1) <- c("longitude", "latitude", "day", "precip")
#something going on with the date formatting - losing to (N/A) when as.Date() on Working1 
precipWorking1$day <- gsub("precip", "", precipWorking1$day)
#precipWorking1$day <- as.Date(precipWorking1$day, format = "%d%m%y")
head(precipWorking1)
tail(precipWorking1)

precipWorking2 <- precipWorking[c(1,2,1001:3000)]
precipWorking2 <- melt(precipWorking2, id=c("niwa_centroid_lon","niwa_centroid_lat"))
names(precipWorking2) <- c("longitude", "latitude", "day", "precip")
precipWorking2$day <- gsub("precip", "", precipWorking2$day)
#precipWorking2$day <- as.Date(precipWorking2$day, format = "%d%m%y")
head(precipWorking2, 5)
tail(precipWorking2, 5)

precipWorking3 <- precipWorking[c(1,2,3001:6212)]
precipWorking3 <- melt(precipWorking3, id=c("niwa_centroid_lon","niwa_centroid_lat"))
names(precipWorking3) <- c("longitude", "latitude", "day", "precip")
precipWorking3$day <- gsub("precip", "", precipWorking3$day)
#precipWorking3$day <- as.Date(precipWorking3$day, format = "%d%m%y")
head(precipWorking3, 5)
tail(precipWorking3, 5)

precipWorkingLong <- bind_rows(precipWorking1, precipWorking2, precipWorking3)
head(precipWorkingLong, 5)
tail(precipWorkingLong, 5)

#precipWorkingLong$day <- gsub("precip", "", precipWorkingLong$day)
#precipWorkingLong$day <- as.Date(precipWorkingLong$day, format = "%d%m%y")

rm(precipWorking1)
rm(precipWorking2)
rm(precipWorking3)

# check variable "types"
sapply(precipWorkingLong, class)

# sorting out the date format 
precipWorkingLong$date <- as.Date(precipWorkingLong$day, format = "%m%d%y")

#precipLongSample <- precipWorkingLong[sample(nrow(precipWorkingLong), 50, replace=FALSE), ]


