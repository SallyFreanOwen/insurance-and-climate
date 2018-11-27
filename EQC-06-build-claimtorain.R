# EQC 6 - add rain data 

# Splitting out the lat longs 
claimPortfolioSpatial$vcsnLatitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,1]
claimPortfolioSpatial$vcsnLongitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,2]

# Subsetting - only the columns I actually want... 
claimPortfolioSpatial06 <- dplyr::select(claimPortfolioSpatial,
                                  claimID, 
                                  portfolioID, 
                                  lossDate, 
                                  portfolioLatitude, 
                                  portfolioLongitude, 
                                  vcsnLatitude, 
                                  vcsnLongitude)

claimPortfolioSpatialVCS <- merge(claimPortfolioSpatial06, vcsn, by = c("vcsnLatitude", "vcsnLongitude"))
