# Working on EQC 

library(dplyr)
library(reshape2)
library(lubridate)

rm(claim0004, claim0508, claim0912, claim1316, 
   vcsn0004, vcsn0508, vcsn0912, vcsn1316, 
   tree, spatial, 
   claimPortfolioSpatial06,
   claimPortfolioSpatialVCS0004, claimPortfolioSpatialVCS0508, 
   claimPortfolioSpatialVCS0912, claimPortfolioSpatialVCS1316
)

# Quick eyeball, getting up to speed 
summary(claimPortfolioSpatial)

claimPortfolioSpatial <- mutate(claimPortfolioSpatial, eventMonth=month(eventDate))
claimPortfolioSpatial <- mutate(claimPortfolioSpatial, eventYear=year(eventDate))

# Recreating histograms from first paper 
# (Note to self needs major tidying up!) 
hist(claimPortfolioSpatial$eventYear)
hist(claimPortfolioSpatial$eventMonth)

#Subsetting for speed while working out process:
claimPortfolioVCSNSpatialSub2012 <- filter(claimPortfolioSpatial, eventYear == 2012)
vcsnSub2012 <- filter(vcsn, vcsn$vcsnDay > "2011-12-31", vcsn$vcsnDay < "2013-01-01")

claimPortfolioRain2012 <- merge(claimPortfolioVCSNSpatialSub2012, vcsnSub2012, by = c("vcsnLongitude", "vcsnLatitude"))

#working with NOAA/NASA nighttime light TIFs

library(stars)
library(dplyr)
library(sf)
library(raster)

## create sf object of boundary box around portfolios in NZ
#source("Scripts/EQC-02-portfolio-import.R") # if haven't already loaded eqc property data
nzboundary <- st_bbox(portfolios)
# read in and crop first test layers, with eyeball checks:
nl201204raw <- read_stars("Data/SVDNB_npp_20120401-20120430_00N060E_vcmcfg_v10_c201605121456.avg_rade9h.tif")
nl201204raw # eyeball data 
nl201204 <- st_crop(x=nl201204raw, y=nzboundary, crop=TRUE, epsilon=0) #note crop takes size down from 3.3Gb to 74.5Mb - definitely worth doing first
rm(nl201204raw)

nl201205raw <- read_stars("Data/SVDNB_npp_20120501-20120531_00N060E_vcmcfg_v10_c201605121458.avg_rade9h.tif")
nl201205 <- st_crop(x=nl201205raw, y=nzboundary, crop=TRUE, epsilon=0)
rm(nl201205raw)

# combine these, with new dimension 
nl_combined <- c(c(nl201204, nl201205)) 
dimnames(nl_combined)[3]<-"time"
rm(nl201204, nl201205)

# Link to property data ... 

# first inspect the stats object: 
nl_combined

# load required packages:
library(tidyverse);
library(sf);
library(rvest);
library(SearchTrees);
library(Imap);
library(leaflet);
library(htmltools);
library(devtools)

# convert to sf object 
nl_combined_sf <- st_as_sfc(nl_combined, as_points=TRUE, na.rm=TRUE)

## Find indices of the nearest point in A to each of the points in B
tree <- createTree(st_coordinates(nl_combined_sf)) #A=nl
inds <- knnLookup(tree, newdat=st_coordinates(portfolios), k=1) #B=portfolios #can be 2 or more

# Create a tibble of the index 
spatial <- tibble("nlPoint"=nl_combined_sf[inds[,1]],
                  "portfolioID"=portfolios$portfolioID,
                  "portfolioPoint"=portfolios$geometry)

head(spatial)
tail(spatial)

# Re-format neighbour link dataset from tibble to dataframe 
portfolioNLSpatialSF <- as.data.frame((spatial))

#Tidying up workspace:
rm(spatial)
rm(claimPortfolioSpatialTestSub)
rm(claimPortfolio)
rm(portfolios)
rm(claims)
rm(tree)
rm(vcsnTestSub)
rm(inds)

# Splitting out the lat longs 
portfolioNLSpatialSF$nlLongitude <- st_coordinates(portfolioNLSpatialSF$nlPoint)[,1]
portfolioNLSpatialSF$nlLatitude <- st_coordinates(portfolioNLSpatialSF$nlPoint)[,2]

<<<<<<< HEAD
# Merge vcsn identifier information onto this

#claimPortfolioVcsnID <- data.frame(claimID=claimPortfolioSpatial$claimID, portfolioID=claimPortfolioSpatial$portfolioID, vcsnPoint =  claimPortfolioSpatial$vcsnPoint, vcsnLongitude = claimPortfolioSpatial$vcsnLongitude, vcsnLatitude = claimPortfolioSpatial$vcsnLatitude)
#portfolioNLSFVcsnID <- merge(portfolioNLSF, claimPortfolioVcsnID, by = c("portfolioID"))

# From "EQC 04" script on building spatial link 
# using output: portfolioVcsnID 
portfolioNLVcsnID <- merge(portfolioNLSF, portfolioVcsnID, by = "portfolioID")

# And merging cliam info on to that:
claimPortfolioNLVcsnID <- merge(portfolioNLVcsnID, claims, by = "portfolioID", all = TRUE)

# Building out the relevant precip information:

# So that we don't attach ALL rain/NL info, first finding year/month pairs for each claim:
#claimPortfolioNLVcsnID$eventMonth <- month(claimPortfolioNLVcsnID$eventDate)
#claimPortfolioNLVcsnID$eventYear <- year(claimPortfolioNLVcsnID$eventDate)
# line above took far too long to load 
#claims$eventMonth <- month(claims$eventDate)
#claims$eventMontht1 <- (claims$eventMonth) + 1
=======
#Re order for ease of reading:
  
portfolioNLSpatialSF <- select(portfolioNLSpatialSF, portfolioID, nlLongitude, nlLatitude)
>>>>>>> 6e5512815e45738b7e099c5e57f5fe7e2a92dd16

portfolioNLSpatialSF %>% 
  select(portfolioID, nlLongitude, nlLatitude)
