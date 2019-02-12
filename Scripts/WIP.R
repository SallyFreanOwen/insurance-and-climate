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
hist(claimPortfolioSpatial$eventYear)
hist(claimPortfolioSpatial$eventMonth)

#Subsetting for speed while working out process:
claimPortfolioSpatialTestSub <- filter(claimPortfolioSpatial, eventYear == 2016)
vcsnTestSub <- filter(vcsn, vcsn$vcsnDay > "2015-12-31")

claimPortfolioSpatialTestVCSN <- merge(claimPortfolioSpatialTestSub, vcsnTestSub, by = c("vcsnLongitude", "vcsnLatitude"))

