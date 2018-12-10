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
names(precipWorking) <- c("longitude", "latitude", "day", "rain")
sapply(precipWorking, class)
precipWorking$day <- gsub("precip", "", precipWorking$day)
precipWorking$day <- as.Date(precipWorking$day, format = "%d.%m.%y")

# If above method didn't work, could try below ... (subsetting - old code may need some tweaking)

## Trying with a test subset - worked well.
#precipTest <- precipWorking[1:100,2:100]
#precipTest2 <- melt(precipTest, id=c("niwa_centroid_lon","niwa_centroid_lat"))
#names(precipTest2) <- c("longitude", "latitude", "day", "precip")
#sapply(precipTest2, class)
#precipTest2$day <- gsub("precip", "", precipTest2$day)
#precipTest2$day <- as.Date(precipTest2$day, format = "%d%m%y")

## Breaking up into parts to re-try 
#precipWorking1 <- precipWorking[1:1000]
#precipWorking1 <- melt(precipWorking1, id=c("niwa_centroid_lon","niwa_centroid_lat"))
#names(precipWorking1) <- c("longitude", "latitude", "day", "precip")
#something going on with the date formatting - losing to (N/A) when as.Date() on Working1 
#precipWorking1$day <- gsub("precip", "", precipWorking1$day)
#precipWorking1$day <- as.Date(precipWorking1$day, format = "%d%m%y")
#head(precipWorking1)
#tail(precipWorking1)
#
#precipWorking2 <- precipWorking[c(1,2,1001:3000)]
#precipWorking2 <- melt(precipWorking2, id=c("niwa_centroid_lon","niwa_centroid_lat"))
#names(precipWorking2) <- c("longitude", "latitude", "day", "precip")
#precipWorking2$day <- gsub("precip", "", precipWorking2$day)
##precipWorking2$day <- as.Date(precipWorking2$day, format = "%d%m%y")
#head(precipWorking2, 5)
#tail(precipWorking2, 5)
#
#memory.limit(size=50000)
#
#precipWorking3 <- precipWorking[c(1,2,3001:4500)]
#precipWorking3 <- melt(precipWorking3, id=c("niwa_centroid_lon","niwa_centroid_lat"))
#names(precipWorking3) <- c("longitude", "latitude", "day", "precip")
#precipWorking3$day <- gsub("precip", "", precipWorking3$day)
##precipWorking3$day <- as.Date(precipWorking3$day, format = "%d%m%y")
#head(precipWorking3, 5)
#tail(precipWorking3, 5)
#
#precipWorking4 <- precipWorking[c(1,2,4501:6212)]
#precipWorking4 <- melt(precipWorking4, id=c("niwa_centroid_lon","niwa_centroid_lat"))
#names(precipWorking4) <- c("longitude", "latitude", "day", "precip")
#precipWorking4$day <- gsub("precip", "", precipWorking4$day)
##precipWorking3$day <- as.Date(precipWorking3$day, format = "%d%m%y")
#head(precipWorking4, 5)
#tail(precipWorking4, 5)
#
#precipWorkingLong <- bind_rows(precipWorking1, precipWorking2, precipWorking3, precipWorking4)
#head(precipWorkingLong, 5)
#tail(precipWorkingLong, 5)

#precipWorkingLong$day <- gsub("precip", "", precipWorkingLong$day)
#precipWorkingLong$day <- as.Date(precipWorkingLong$day, format = "%d%m%y")

#rm(precipWorking1)
#rm(precipWorking2)
#rm(precipWorking3)

# check variable "types"
#sapply(precipWorkingLong, class)

# sorting out the date format 
#precipWorkingLong$date <- as.Date(precipWorkingLong$day, format = "%m%d%y")

#precipLongSample <- precipWorkingLong[sample(nrow(precipWorkingLong), 50, replace=FALSE), ]


