# EQC 6 - add rain data 

# Splitting out the lat longs 
claimPortfolioSpatial$vcsnLatitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,1]
claimPortfolioSpatial$vcsnLongitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,2]
#note rounded to 3dp

claimPortfolioSpatialVCSN <- merge(claimPortfolioSpatial, vcsn, by = c("vcsnLatitude", "vcsnLongitude"))
