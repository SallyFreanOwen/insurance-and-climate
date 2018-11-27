# EQC 6 - add rain data 

# Splitting out the lat longs 
claimPortfolioSpatial$vcsnLongitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,1]
claimPortfolioSpatial$vcsnLatitude <- st_coordinates(claimPortfolioSpatial$vcsnPoint)[,2]

# Subsetting - only the columns I actually want... 
claimPortfolioSpatial06 <- dplyr::select(claimPortfolioSpatial,
                                  claimID, 
                                  portfolioID, 
                                  lossDate, 
                                  portfolioLatitude, 
                                  portfolioLongitude, 
                                  vcsnLatitude, 
                                  vcsnLongitude)

# Add rainfall to claim info 
claimPortfolioSpatialVCS <- merge(claimPortfolioSpatial06, vcsn, by = c("vcsnLatitude", "vcsnLongitude"))
