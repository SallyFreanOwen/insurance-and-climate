library(tidyverse);
library(sf);
library(rvest);
library(SearchTrees);
library(Imap);
library(leaflet);
library(htmltools);
library(lubridate);
library(SearchTrees)
library(devtools)
library(ggplot2)
library(tidyr)
library(tidyverse)
library(haven)
library(stars)

### Make portfolios spatial, and attach all nL and precip nearest coords: 

# First copy the lat long columns 
portfolios$lat <- portfolios$portfolioLatitude
portfolios$long <- portfolios$portfolioLongitude
# Now define as an sf point object 
portfolios <- st_as_sf(portfolios, coords = c("long", "lat"), crs = 4326) 

#note crs tells it the latlons are wgs84
# NB the new lat longs change to a list-column, called geometry, which is an sfc_POINT class.

# check projection
st_crs(portfolios)
# it is, but if it wasn't we'd want: 
#st_crs(ph_sf) <- 4326

### Then, by nearest coordinate, attach the nearest precip point to each portfolioID

# Finding indices of the nearest point in A(rain) to each of the points in B(portfolios)
tree <- createTree(st_coordinates(vcsnWide))
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) # can be 2 or more

# Create a tibble of the index 
spatial <- tibble("vcsnPoint"=vcsnWide$geometry[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)
head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial <- as.data.frame((spatial))

# Splitting out the lat longs 
spatial$vcsnLongitude <- st_coordinates(spatial$vcsnPoint)[,1]
spatial$vcsnLatitude <- st_coordinates(spatial$vcsnPoint)[,2]
portfolioVcsnID <- spatial

#Drop the points (portfolio and precip sf points columns) 
portfolioVcsnID <- portfolioVcsnID[c("portfolioID", "vcsnLongitude", "vcsnLatitude")]

# clean up workspace:
rm(inds)
rm(spatial)
rm(tree)
rm(vcsnWide)




#########

### Next, NL to portfolios link 
nl201506sf <- st_as_sfc(nl201506, as_points=TRUE, na.rm=TRUE)

## Find indices of the nearest point in A to each of the points in B
tree <- createTree(st_coordinates(nl201506sf)) #A=nl
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) #B=portfolios #can be 2 or more

# Create a tibble of the index 
spatial <- tibble("nlPoint"=nl201506sf[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)

head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
spatial <- as.data.frame((spatial)[1:2]) #dropping portfolioPoint (unnecessary now)

portfolioNlID <- spatial

rm(tree)
rm(inds)
rm(spatial)

# Splitting out the lat longs 
portfolioNlID$nlLongitude <- st_coordinates(portfolioNlID$nlPoint)[,1]
portfolioNlID$nlLatitude <- st_coordinates(portfolioNlID$nlPoint)[,2]

portfolioNlID <- as.data.frame(portfolioNlID[2:4]) #dropping portfolioPoint (unnecessary now)

##########

portfolios <- merge(portfolios, portfolioNlID, by = "portfolioID")
portfolios <- merge(portfolios, portfolioVcsnID, by = "portfolioID")
portfolios <- merge(portfolios, mbStats, by.x = "portfolioID", by.y = "portfolioid", all.x = TRUE)

rm(portfolioNlID)
rm(portfolioVcsnID)
rm(mbStats)

