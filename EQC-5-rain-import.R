# EQC 5 - niwa data import 

# setwd("~/EQC-climate-change-part-two")

# load the ncdf4 package
library(sf)

# Inputing rain data as csv (output from EQC-5a)
precip_table <- read.csv("Data/VCSN_Rain5k_1999_2016.csv", sep=",", stringsAsFactors = FALSE)
names(precip_table) <- gsub("X", "precip", names(precip_table))
#names(precip_table) <- gsub(".", "", names(precip_table))

# This has columns for lat & lon, then a column for each day, containing rainfall 
# Note the "centroid" is not actually a centroid (just NIWA's coordinates for each grid)

precipWorking <- as.data.frame(precip_table)

rm(precip_table)

head(names(precipWorking))

# prefer a "point / day / rain" column format for processing later on, with 
library(reshape2)

## If you're on an old machine, may be a problem with below - slow 
precipWorking <- melt(precipWorking, id=c("lon","lat"))
head(precipWorking)
names(precipWorking) <- c("longitude", "latitude", "day", "rain")
head(precipWorking)
sapply(precipWorking, class)
precipWorking$day <- gsub("precip", "", precipWorking$day)
head(precipWorking)
precipWorking$day <- as.Date(precipWorking$day, format = "%Y.%m.%d")
sapply(precipWorking,class)
