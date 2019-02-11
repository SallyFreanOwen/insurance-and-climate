# Working on EQC 

library(dplyr)
library(reshape2)

rm(claim0004, claim0508, claim0912, claim1316, 
   vcsn0004, vcsn0508, vcsn0912, vcsn1316, 
   tree, spatial, 
   claimPortfolioSpatial06,
   claimPortfolioSpatialVCS0004, claimPortfolioSpatialVCS0508, 
   claimPortfolioSpatialVCS0912, claimPortfolioSpatialVCS1316
   )

# Quick eyeball, getting up to speed 
sumary(claimPortfolioSpatial)

claimPortfolioSpatial <- mutate(claimPortfolioSpatial, eventMonth=month(eventDate))
claimPortfolioSpatial <- mutate(claimPortfolioSpatial, eventYear=year(eventDate))
