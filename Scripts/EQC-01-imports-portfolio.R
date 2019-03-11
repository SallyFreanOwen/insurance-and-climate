# EQC portfolio import  

# setwd("~/EQC-climate-change-part-two")

library(sf) 
# note sf is designed to supercede package(sp) 
# it's more dataframe-based, with or w/o geospatial elements - a better fit for this project 
library(tidyverse)

# Note data deliberately not saved in wd - confidential, only want code in cloud (not data itself)
portfolioRaw <- read.csv("Data/Motu_EQC_Portfolio_2017.csv", stringsAsFactors = FALSE)

# Check columns type - numeric 
sapply(portfolioRaw, class)

portfolios <- portfolioRaw

#Updating names to standard lowerUpper format:
first.letter  <- tolower(substring(names(portfolios),1, 1))
other.letters <- substring(names(portfolios), 2)
newnames      <- paste(first.letter, other.letters, sep="")
names(portfolios) <- newnames
names(portfolios)[2] <- c("nzRegionNumber")
names(portfolios)[7] <- c("nzCensusAreaUnit")
names(portfolios)[8] <- c("crestaZone")
names(portfolios)[9] <- c("portfolioLatitude")
names(portfolios)[10] <- c("portfolioLongitude") 
#to do: change syntax of above to below
#names(my.data2)[names(my.data2)=="Basinandrange"]   <- "BasinandRange"

#sorting out ID
portfolios$portfolioID <- as.numeric(portfolioRaw$PortfolioID)

library(sf)

### Make spatial: 

# First copy the lat long columns 
portfolios$lat <- portfolios$portfolioLatitude
portfolios$long <- portfolios$portfolioLongitude
# Now define as an sf point object 
portfolios <- st_as_sf(portfolios, coords = c("long", "lat"), crs = 4326) #note crs tells it the latlons are wgs84
# NB the new lat longs change to a list-column, called geometry, which is an sfc_POINT class.

# check projection
st_crs(portfolios)
# it is, but if it wasn't we'd want: 
#st_crs(ph_sf) <- 4326

rm(portfolioRaw)
rm(first.letter)
rm(other.letters)
rm(newnames)
